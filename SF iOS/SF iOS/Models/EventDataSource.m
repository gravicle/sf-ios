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

@end


@implementation EventDataSource

- (instancetype)initWithDatabase:(CKDatabase *)database {
    if (self = [super init]) {
        self.database = database;
    }
    
    return self;
}

- (void)fetchPreviousEventsWithCompletionHander:(EventsFetchCompletionHandler)completionHandler {
    __block NSArray<CKRecord *> *eventRecords = [NSArray new];
    
    __weak typeof(self) welf = self;
    CKQueryOperation *eventRecordsOperation = [self eventRecordsQueryOperationWithCursor:self.cursor completionHandler:^(CKQueryCursor *cursor, NSArray<CKRecord *> *records, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, error);
            });
            return;
        }
        welf.cursor = cursor;
        eventRecords = records;
    }];
    eventRecordsOperation.resultsLimit = 10;
    
    CKFetchRecordsOperation *locationsOperation = [self locationRecordsFetchOperationForEventRecords:eventRecords withCompletionHandler:^(NSArray<CKRecord *> * _Nullable locationRecords, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, error);
            });
            return;
        }
        
        NSArray<Event *> *events = [welf eventsFromEventRecords:eventRecords locationRecords:locationRecords];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(events, nil);
        });
    }];
    
    [locationsOperation addDependency:eventRecordsOperation];
    [self.database addOperation:eventRecordsOperation];
    [self.database addOperation:locationsOperation];
}

- (CKFetchRecordsOperation *)locationRecordsFetchOperationForEventRecords:(NSArray<CKRecord *> *)eventRecords
                                                    withCompletionHandler:(void (^)(NSArray<CKRecord *> * _Nullable locationRecords, NSError * _Nullable error))completionHandler {
    NSMutableArray<CKRecordID *> *recordIDs = [NSMutableArray new];
    for (CKRecord *record in eventRecords) {
        CKReference *locationReference = [record objectForKey:@"location"];
        [recordIDs addObject:locationReference.recordID];
    }
    
    NSMutableArray<CKRecord *> *locationRecords = [NSMutableArray new];
    CKFetchRecordsOperation *operation = [[CKFetchRecordsOperation alloc] initWithRecordIDs:recordIDs];
    operation.perRecordCompletionBlock = ^(CKRecord * _Nullable record, CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        if (record == nil) {
            NSError *fallbackError = [NSError appErrorWithDescription:@"Record of type %@ with id %@ could not be found."];
            completionHandler(nil, error ? error : fallbackError);
            return;
        }
        
        [locationRecords addObject:record];
    };
    
    operation.completionBlock = ^{
        completionHandler(locationRecords, nil);
    };
    
    return operation;
}

- (CKQueryOperation *)eventRecordsQueryOperationWithCursor:(CKQueryCursor *)cursor completionHandler: (void (^)(CKQueryCursor *cursor, NSArray<CKRecord *> *records, NSError *error))completionHandler {
    NSString *recordType = Event.recordName;
    
    CKQueryOperation *operation = nil;
    if (cursor) {
        operation = [[CKQueryOperation alloc] initWithCursor:cursor];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@""];
        CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:predicate];
        operation = [[CKQueryOperation alloc] initWithQuery:query];
    }
    
    NSMutableArray<CKRecord *> *records = [NSMutableArray new];
    operation.recordFetchedBlock = ^(CKRecord * _Nonnull record) {
        if (record.recordType != recordType) {
            NSAssert(true, @"Received a record of unexpected type: %@", record.recordType);
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

- (NSArray<Event *> *)eventsFromEventRecords:(NSArray<CKRecord *> *)eventRecords locationRecords:(NSArray<CKRecord *> *)locationRecords {
    NSAssert(eventRecords.count == locationRecords.count,
             @"Number of events %lu != Number of locations %lu", (unsigned long)eventRecords.count, locationRecords.count);
    
    NSMutableArray<Event *> *events = [NSMutableArray new];
    for (CKRecord *eventRecord in eventRecords) {
        NSUInteger locationIndex = [locationRecords indexOfObjectPassingTest:^BOOL(CKRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return ((CKReference *)[eventRecord objectForKey:@"location"]).recordID == obj.recordID;
        }];
        
        Location *location = [[Location alloc] initWithRecord:locationRecords[locationIndex]];
        Event *event = [[Event alloc] initWithRecord:eventRecord location:location];
        [events addObject:event];
    }
    
    return events;
}

@end
