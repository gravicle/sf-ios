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

@class EventDataSource;

@protocol EventDataSourceDelegate
- (void)willUpdateDataSource:(EventDataSource *)datasource;
- (void)didUpdateDataSource:(EventDataSource *)datasource withNewData:(BOOL)hasNewData error:(nullable NSError *)error;
@end

@interface EventDataSource : NSObject

@property (nonatomic, weak) id<EventDataSourceDelegate> delegate;
@property (nonatomic, assign) BOOL hasMoreEvents;
@property (nonatomic, readonly, assign) NSUInteger numberOfEvents;

- (instancetype)initWithEventType:(EventType)eventType database:(CKDatabase *)database;
- (void)refresh;
- (Event *)eventAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
