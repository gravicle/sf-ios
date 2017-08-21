//
//  EventDataSOurce.m
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventDataSource.h"
#import "Event.h"
#import "NSDate+Utilities.h"
#import "NSError+Constructor.h"
#import "NSNotification+ApplicationEventNotifications.h"

@interface EventDataSource ()

@property (nonatomic) CKDatabase *database;
@property (nonatomic, assign) EventType eventType;
@property (nonatomic) NSMutableArray<Event *> *events;

@end

@implementation EventDataSource

- (instancetype)initWithEventType:(EventType)eventType database:(CKDatabase *)database {
    if (self = [super init]) {
        self.eventType = eventType;
        self.database = database;
        self.events = [NSMutableArray new];
        [self observeAppActivationEvents];
    }
    return self;
}

- (void)refresh {
    __weak typeof(self) welf = self;
    __block NSArray<CKRecord *> *eventRecords;
    
    CKFetchRecordsOperation *locationsOperation = [self locationRecordsFetchOperationWithCompletionHandler:^(NSDictionary<CKRecordID *,CKRecord *> * _Nullable recordsByRecordID, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [welf.updateStatusDelegate didUpdateDataSource:welf withNewData:false error:error];
            });
            return;
        }
        
        NSArray<Event *> *newEvents = [welf eventsFromEventRecords:eventRecords locationRecordsByID:recordsByRecordID];
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL updatedEvents = [welf reconcileNewEvents:newEvents];
            [welf.updateStatusDelegate didUpdateDataSource:welf withNewData:updatedEvents error:nil];
        });
    }];
    
    CKQueryOperation *eventRecordsOperation = [self eventRecordsQueryOperationForEventsOfType:self.eventType withCompletionHandler:^(CKQueryCursor *cursor, NSArray<CKRecord *> *records, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [welf.updateStatusDelegate didUpdateDataSource:welf withNewData:false error:error];
            });
            return;
        }
        
        eventRecords = records;
        
        locationsOperation.recordIDs = [welf locationRecordIDsFromEventRecords:eventRecords];
        [self.database addOperation:locationsOperation];
    }];
    
    [self.updateStatusDelegate willUpdateDataSource:self];
    [self.database addOperation:eventRecordsOperation];
}

- (Event *)eventAtIndex:(NSUInteger)index {
    return self.events[index];
}

- (NSUInteger)numberOfEvents {
    return self.events.count;
}


- (NSUInteger)indexOfCurrentEvent {
    // index of the first future event
    for (Event *event in self.events.reverseObjectEnumerator) {
        // Basing on end-date allows ongoing event to show up first
        if (event.isActive) {
            return [self.events indexOfObjectIdenticalTo:event];
        }
    }
    
    return NSNotFound;
}

// MARK: - CloudKit Operations

- (CKQueryOperation *)eventRecordsQueryOperationForEventsOfType:(EventType)eventType withCompletionHandler: (void (^)(CKQueryCursor *cursor, NSArray<CKRecord *> *records, NSError *error))completionHandler {
    NSString *recordType = Event.recordName;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventType == %u", eventType];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:predicate];
    query.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"eventDate" ascending:false]];
    CKQueryOperation *operation = [[CKQueryOperation alloc] initWithQuery:query];
    
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
    
    return operation;
}

- (CKFetchRecordsOperation *)locationRecordsFetchOperationWithCompletionHandler:(void (^)(NSDictionary<CKRecordID *,CKRecord *> * _Nullable recordsByRecordID, NSError * _Nullable error))completionHandler {
    CKFetchRecordsOperation *operation = [CKFetchRecordsOperation new];
    operation.fetchRecordsCompletionBlock = completionHandler;
    
    return operation;
}

// MARK: - Records Parsing

- (NSArray<Event *> *)eventsFromEventRecords:(NSArray<CKRecord *> *)eventRecords locationRecordsByID:(NSDictionary<CKRecordID *,CKRecord *> *) locationRecordsByRecordID {
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
    CKReference *locationReference = eventRecord[@"location"];
    return locationReference.recordID;
}

- (NSArray<CKRecordID *> *)locationRecordIDsFromEventRecords:(NSArray<CKRecord *> *)eventRecords {
    NSMutableArray<CKRecordID *> *recordIDs = [NSMutableArray new];
    for (CKRecord *eventRecord in eventRecords) {
        [recordIDs addObject:[self locationRecordIDFromEventRecord:eventRecord]];
    }
    return recordIDs;
}

//MARK: - Respond To app Events

- (void)observeAppActivationEvents {
    __weak typeof(self) welf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSNotification.applicationBecameActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [welf refresh];
    }];
}

// MARK: - Bookeeping

- (BOOL)reconcileNewEvents:(NSArray<Event *> *)newEvents {
    BOOL updatedEvents = false;
    NSMutableArray *newUniqueEvents = [NSMutableArray new];
    for (Event *event in newEvents) {
        NSUInteger index = [self.events indexOfObject:event];
        if (index == NSNotFound) {
            [newUniqueEvents addObject:event];
        } else {
            Event *exsistingEvent = self.events[index];
            if ([event hasBeenModifiedSinceRecord:exsistingEvent]) {
                updatedEvents = true;
                [self.events replaceObjectAtIndex:index withObject:event];
            }
        }
    }
    
    if (newUniqueEvents.count > 0) {
        updatedEvents = true;
        [self.events addObjectsFromArray:newUniqueEvents];
    }
    
    if (updatedEvents) {
        [self.events sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [[(Event *)obj2 date] compare:[(Event *)obj1 date]];
        }];
    }
    
    return updatedEvents;
}

@end
