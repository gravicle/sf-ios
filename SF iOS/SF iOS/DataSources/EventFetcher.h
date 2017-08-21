//
//  EventFetcher.h
//  SF iOS
//
//  Created by Amit Jain on 8/20/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

@import CloudKit;
#import <Foundation/Foundation.h>
#import "Event.h"
#import "EventType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Wrapper around CloudKit operations for fetching records, and parsing CK objects into concrete Events.
 */
@interface EventFetcher : NSObject

typedef void(^EventsFetchCompletionHandler)(NSArray<Event *> *_Nullable events, NSError *_Nullable error);

+ (void)fetchLatestEventsOfType:(EventType)eventType fromDatabase:(CKDatabase*)database withCompletionHandler:(EventsFetchCompletionHandler)completionHandler;
+ (void)fetchEventWithID:(CKRecordID *)eventID fromDatabase:(CKDatabase *)database withCompletionHandler:(EventsFetchCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
