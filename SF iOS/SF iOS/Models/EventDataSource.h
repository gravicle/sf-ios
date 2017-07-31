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

@property (nonatomic, assign) BOOL hasMoreEvents;

- (instancetype)initWithEventType:(EventType)eventType database:(CKDatabase *)database;
- (void)fetchPreviousEventsWithCompletionHandler:(void (^)(BOOL didUpdate, NSError * _Nullable error))completionHandler;

@property (nonatomic, readonly, assign) NSUInteger numberOfEvents;
- (Event *)eventAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
