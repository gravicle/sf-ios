//
//  EventDataSOurce.h
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

@import CloudKit;
#import <Foundation/Foundation.h>
#import "Event.h"
#import "EventFetcher.h"

NS_ASSUME_NONNULL_BEGIN

@class EventDataSource;

@protocol EventDataSourceUpdateStausDelegate
- (void)willUpdateDataSource:(EventDataSource *)datasource;
- (void)didUpdateDataSource:(EventDataSource *)datasource withNewData:(BOOL)hasNewData error:(nullable NSError *)error;
@end

@interface EventDataSource : NSObject

@property (nonatomic, weak) id<EventDataSourceUpdateStausDelegate> updateStatusDelegate;
@property (nonatomic, readonly, assign) NSUInteger numberOfEvents;

/// Index of the next upcoming event. If not found, returns NSNotFound
@property (nonatomic, readonly, assign) NSUInteger indexOfCurrentEvent;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithEventType:(EventType)eventType database:(CKDatabase *)database;

- (void)refresh;

- (Event *)eventAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
