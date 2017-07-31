//
//  EventDataSOurce.h
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
@import CloudKit;

NS_ASSUME_NONNULL_BEGIN
@interface EventDataSource : NSObject

- (instancetype)initWithDatabase:(CKDatabase *)database;

typedef void (^EventsFetchCompletionHandler)(NSArray<Event *> * _Nullable events, NSError * _Nullable error);
- (void)fetchPreviousEventsOfType:(EventType)eventType withCompletionHander:(EventsFetchCompletionHandler)completionHandler;

@end
NS_ASSUME_NONNULL_END
