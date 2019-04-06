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
#import "FeedFetchService.h"
#import <Realm/Realm.h>

@interface EventDataSource ()

@property (nonatomic, assign) EventType eventType;
@property (nonatomic) RLMResults<Event *> *events;
@property (nonatomic) FeedFetchService *service;

@end

@implementation EventDataSource

- (instancetype)initWithEventType:(EventType)eventType {
    if (self = [super init]) {
        self.eventType = eventType;
        self.events = [Event allObjects];
        self.service = [[FeedFetchService alloc] init];
        [self observeAppActivationEvents];
    }
    return self;
}

- (void)refresh {
    __weak typeof(self) welf = self;
    [self.service getFeedWithHandler:^(NSArray<Event *> * _Nonnull feedFetchItems, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [welf.delegate didUpdateDataSource:welf withNewData:false error:error];
            });
            return;
        }
        // Persist your data easily
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addOrUpdateObjects:feedFetchItems];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [welf.delegate didUpdateDataSource:welf withNewData:true error:nil];
        });
    }];
    [self.delegate willUpdateDataSource:self];
}

- (Event *)eventAtIndex:(NSUInteger)index {
    return self.events[index];
}

- (NSUInteger)numberOfEvents {
    return self.events.count;
}

- (NSUInteger)indexOfCurrentEvent {
    return [self.events indexOfObjectWhere:@"endDate > %@", [NSDate date]];
}

//MARK: - Respond To app Events

- (void)observeAppActivationEvents {
    __weak typeof(self) welf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSNotification.applicationBecameActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [welf refresh];
    }];
}

@end
