//
//  EventFetcher.m
//  SF iOS
//
//  Created by Amit Jain on 8/20/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventFetcher.h"

@implementation EventFetcher

+ (void)fetchLatestEventsOfType:(EventType)eventType fromDatabase:(CKDatabase *)database withCompletionHandler:(EventsQueryCompletionHandler)completionHandler {
    void(^fail)(NSError *_Nullable) = ^void(NSError *error) {
        completionHandler(nil, error);
    };
    
    void(^finish)(NSArray<Event *> *) = ^void(NSArray<Event *> *events) {
        completionHandler(events, nil);
    };
    
    __block NSArray<CKRecord *> *eventRecords = nil;
    
    CKFetchRecordsOperation *locationsFetch = [self recordsFetchOperationWithCompletionHandler:^(NSDictionary<CKRecordID *,CKRecord *> * _Nullable recordsByRecordID, NSError * _Nullable error) {
        if (!recordsByRecordID || error) {
            fail(error);
            return;
        }
        
        NSArray *events = [self eventsFromEventRecords:eventRecords locationRecordsByID:recordsByRecordID];
        finish(events);
    }];
    
    CKQueryOperation *eventsQuery = [self eventQueryOperationForEventsOfType:eventType withCompletionHandler:^(CKQueryCursor *cursor, NSArray<CKRecord *> *records, NSError *error) {
        if (!records || error) {
            fail(error);
            return;
        }
        
        eventRecords = records;
        
        locationsFetch.recordIDs = [self locationIDsFromEventRecords:records];
        [database addOperation:locationsFetch];
    }];
    
    [database addOperation:eventsQuery];
}

+ (void)fetchEventWithID:(CKRecordID *)eventID fromDatabase:(CKDatabase *)database withCompletionHandler:(EventFetchCompletionHandler)completionHandler {
    void(^abort)(NSError *_Nullable) = ^void(NSError *error) {
        completionHandler(nil, error);
    };
    
    void(^finish)(Event *) = ^void(Event *event) {
        completionHandler(event, nil);
    };
    
    __block CKRecord *eventRecord = nil;
    
    CKFetchRecordsOperation *locationFetch = [self recordsFetchOperationWithCompletionHandler:^(NSDictionary<CKRecordID *,CKRecord *> * _Nullable recordsByRecordID, NSError * _Nullable error) {
        if (!recordsByRecordID || error) {
            abort(error);
            return;
        }
    
        CKRecordID *locationID = [self locationIDFromEventRecord:eventRecord];
        Event *event = [self eventFromEventRecord:eventRecord locationRecord:recordsByRecordID[locationID]];
        finish(event);
    }];
    
    CKFetchRecordsOperation *eventFetch = [self recordsFetchOperationWithCompletionHandler:^(NSDictionary<CKRecordID *,CKRecord *> * _Nullable recordsByRecordID, NSError * _Nullable error) {
        if (!recordsByRecordID || error) {
            abort(error);
            return;
        }
        
        eventRecord = recordsByRecordID[eventID];
        locationFetch.recordIDs = @[[self locationIDFromEventRecord:eventRecord]];
        [database addOperation:locationFetch];
    }];
    
    [database addOperation:eventFetch];
}

//MARK: - Operation Builders

+ (CKFetchRecordsOperation *)recordsFetchOperationWithCompletionHandler:(void (^)(NSDictionary<CKRecordID *,CKRecord *> * _Nullable recordsByRecordID, NSError * _Nullable error))completionHandler {
    CKFetchRecordsOperation *operation = [CKFetchRecordsOperation new];
    operation.fetchRecordsCompletionBlock = completionHandler;
    
    return operation;
}

+ (CKQueryOperation *)eventQueryOperationForEventsOfType:(EventType)eventType withCompletionHandler: (void (^)(CKQueryCursor *cursor, NSArray<CKRecord *> *records, NSError *error))completionHandler {
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

// MARK: - Records Parsing

+ (Event *)eventFromEventRecord:(CKRecord *)eventRecord locationRecord:(CKRecord *)locationRecord {
    Location *location = [[Location alloc] initWithRecord:locationRecord];
    return [[Event alloc] initWithRecord:eventRecord location:location];
}

+ (NSArray<Event *> *)eventsFromEventRecords:(NSArray<CKRecord *> *)eventRecords locationRecordsByID:(NSDictionary<CKRecordID *,CKRecord *> *) locationRecordsByRecordID {
    NSMutableArray<Event *> *events = [NSMutableArray new];
    for (CKRecord *eventRecord in eventRecords) {
        CKRecordID *locationID = [self locationIDFromEventRecord:eventRecord];
        if (!locationID) {
            NSAssert(false, @"Location corresponding to Event does not exist\n%@", eventRecord);
            break;
        }
        
        Event *event = [self eventFromEventRecord:eventRecord locationRecord:locationRecordsByRecordID[locationID]];
        [events addObject:event];
    }
    
    return events;
}

+ (CKRecordID *)locationIDFromEventRecord:(CKRecord *)eventRecord {
    CKReference *locationReference = eventRecord[@"location"];
    return locationReference.recordID;
}

+ (NSArray<CKRecordID *> *)locationIDsFromEventRecords:(NSArray<CKRecord *> *)eventRecords {
    NSMutableArray<CKRecordID *> *recordIDs = [NSMutableArray new];
    for (CKRecord *eventRecord in eventRecords) {
        [recordIDs addObject:[self locationIDFromEventRecord:eventRecord]];
    }
    return recordIDs;
}


@end
