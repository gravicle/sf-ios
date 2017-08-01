//
//  EventDataSOurce.m
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventDataSource.h"
#import "Event.h"
#import "NSError+Constructor.h"

@interface EventDataSource ()

@property (nonatomic) CKDatabase *database;
@property (nonatomic) CKQueryCursor *cursor;
@property (nonatomic, assign) EventType eventType;
@property (nonatomic) NSMutableArray<Event *> *events;

@end

@implementation EventDataSource

- (instancetype)initWithEventType:(EventType)eventType database:(CKDatabase *)database {
    if (self = [super init]) {
        self.eventType = eventType;
        self.database = database;
        self.events = [NSMutableArray new];
    }
    return self;
}

- (void)fetchPreviousEventsWithCompletionHandler:(void (^)(BOOL didUpdate, NSError * _Nullable))completionHandler {
    __weak typeof(self) welf = self;
    __block NSArray<CKRecord *> *eventRecords;
    
    CKFetchRecordsOperation *locationsOperation = [self locationRecordsFetchOperationWithCompletionHandler:^(NSDictionary<CKRecordID *,CKRecord *> * _Nullable recordsByRecordID, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(false, error);
            });
            return;
        }
        
        NSArray<Event *> *newEvents = [welf eventsFromEventRecords:eventRecords locationRecordsByID:recordsByRecordID];
        [welf storeNewEvents:newEvents];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(true, nil);
        });
    }];
    
    CKQueryOperation *eventRecordsOperation = [self eventRecordsQueryOperationForEventsOfType:self.eventType withCursor:self.cursor completionHandler:^(CKQueryCursor *cursor, NSArray<CKRecord *> *records, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(false, error);
            });
            return;
        }
        welf.cursor = cursor;
        eventRecords = records;
        
        locationsOperation.recordIDs = [welf locationRecordIDsFromEventRecords:eventRecords];
        [self.database addOperation:locationsOperation];
    }];
    
    [self.database addOperation:eventRecordsOperation];
}

- (Event *)eventAtIndex:(NSUInteger)index {
    return self.events[index];
}

- (NSUInteger)numberOfEvents {
    return self.events.count;
}

// MARK: - CloudKit Operations Construction

- (CKQueryOperation *)eventRecordsQueryOperationForEventsOfType:(EventType)eventType withCursor:(CKQueryCursor *)cursor completionHandler: (void (^)(CKQueryCursor *cursor, NSArray<CKRecord *> *records, NSError *error))completionHandler {
    NSString *recordType = Event.recordName;
    
    CKQueryOperation *operation = nil;
    if (cursor) {
        operation = [[CKQueryOperation alloc] initWithCursor:cursor];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventType == %u", eventType];
        CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:predicate];
        query.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"eventDate" ascending:false]];
        operation = [[CKQueryOperation alloc] initWithQuery:query];
    }
    
    __block NSMutableArray<CKRecord *> *records = [NSMutableArray new];
    operation.recordFetchedBlock = ^(CKRecord * _Nonnull record) {
        if (![record.recordType isEqualToString:recordType]) {
            NSAssert(false, @"Received a record of unexpected type: %@", record.recordType);
            return;
        }
        [records addObject:record];
    };
    operation.queryCompletionBlock = ^(CKQueryCursor * _Nullable cursor, NSError * _Nullable operationError) {
        if (operationError != nil) {
            completionHandler(nil, nil, operationError);
            return;
        }
        
        completionHandler(cursor, records, nil);
    };
    operation.resultsLimit = 10;
    
    return operation;
}

- (CKFetchRecordsOperation *)locationRecordsFetchOperationWithCompletionHandler:(void (^)(NSDictionary<CKRecordID *,CKRecord *> * _Nullable recordsByRecordID, NSError * _Nullable error))completionHandler {
    NSMutableArray<CKRecord *> *locationRecords = [NSMutableArray new];
    CKFetchRecordsOperation *operation = [CKFetchRecordsOperation new];
    operation.perRecordCompletionBlock = ^(CKRecord * _Nullable record, CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        if (record == nil) {
            NSError *fallbackError = [NSError appErrorWithDescription:@"Record of type %@ with id %@ could not be found."];
            completionHandler(nil, error ? error : fallbackError);
            return;
        }
        
        [locationRecords addObject:record];
    };
    
    operation.fetchRecordsCompletionBlock = completionHandler;
    
    return operation;
}

// MARK: - Records Parsing

- (NSArray<Event *> *)eventsFromEventRecords:(NSArray<CKRecord *> *)eventRecords locationRecordsByID:(NSDictionary<CKRecordID *,CKRecord *> *) locationRecordsByRecordID {
    NSAssert(eventRecords.count == locationRecordsByRecordID.count,
             @"Number of events %lu != Number of locations %lu", (unsigned long)eventRecords.count, locationRecordsByRecordID.count);
    
    NSMutableArray<Event *> *events = [NSMutableArray new];
    for (CKRecord *eventRecord in eventRecords) {
        CKRecordID *locationRecordID = [self locationRecordIDFromEventRecord:eventRecord];
        if (!locationRecordID) {
            NSAssert(false, @"Location corresponding to Event does not exist\n%@", eventRecord);
            break;
        }
        Location *location = [[Location alloc] initWithRecord:locationRecordsByRecordID[locationRecordID]];
        Event *event = [[Event alloc] initWithRecord:eventRecord location:location];
        [events addObject:event];
    }
    
    return events;
}
                                          
- (CKRecordID *)locationRecordIDFromEventRecord:(CKRecord *)eventRecord {
    CKReference *locationReference = [eventRecord objectForKey:@"location"];
    return locationReference.recordID;
}

- (NSArray<CKRecordID *> *)locationRecordIDsFromEventRecords:(NSArray<CKRecord *> *)eventRecords {
    NSMutableArray<CKRecordID *> *recordIDs = [NSMutableArray new];
    for (CKRecord *eventRecord in eventRecords) {
        [recordIDs addObject:[self locationRecordIDFromEventRecord:eventRecord]];
    }
    return recordIDs;
}

// MARK: - Bookeeping

- (void)storeNewEvents:(NSArray<Event *> *)newEvents {
    [self.events addObjectsFromArray:newEvents];
    [self.events sortUsingComparator:^NSComparisonResult(Event * _Nonnull obj1, Event * _Nonnull obj2) {
        return [obj2.date compare:obj1.date];
    }];
}

@end
