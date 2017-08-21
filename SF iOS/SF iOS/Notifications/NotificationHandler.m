//
//  NotificationHandler.m
//  SF iOS
//
//  Created by Amit Jain on 8/20/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

@import UIKit;
@import UserNotifications;
@import CloudKit;
#import "NotificationHandler.h"
#import "RemindersScheduler.h"
#import "EventFetcher.h"
#import "NSError+Constructor.h"

static NSString * const newEventSubscriptionIDv1 = @"newEventCreatedSubscription-v-1";
static NSString * const userInfoEventIDKey = @"eventID";

@interface NotificationHandler ()

@property (nonatomic) CKDatabase *database;

@end

@implementation NotificationHandler

+ (NSDictionary<NSString *,id> *)userInfoDictionaryWithEvent:(Event *)event {
    return @{userInfoEventIDKey : event.identifier};
}

- (instancetype)initWithDatabase:(CKDatabase *)database {
    if (self = [super init]) {
        self.database = database;
    }
    return self;
}

- (void)registerForReceivingNotifications {
    [[UNUserNotificationCenter currentNotificationCenter]
     requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionSound
     completionHandler:^(BOOL granted, NSError * _Nullable error) {
         if (!granted || error) {
             NSLog(@"Could not register for notifications: %@", error);
             return;
         }
         
         [[UIApplication sharedApplication] registerForRemoteNotifications];
     }];
}

- (void)subscribeToEventNotifications {
    __weak typeof(self) welf = self;
    [self getSubscriptionStatusForEventNotificationsWithCompletionHandler:^(BOOL isSubscribed) {
        if (isSubscribed) {
            return;
        }
        
        [welf createNewEventSubscription];
    }];
}

- (void)processNotification:(NSDictionary *)notificationPayload withCompletionHandler:(NotificationHandlerCompletion)completionHandler {
    CKNotification *note = [CKNotification notificationFromRemoteNotificationDictionary:notificationPayload];
    
    if (note.notificationType != CKNotificationTypeQuery) {
        completionHandler([NSError appErrorWithDescription:@"Cannot handle notification: %@", note]);
    }
    
    CKRecordID *eventID = [(CKQueryNotification *)note recordID];
    
    [EventFetcher fetchEventWithID:eventID fromDatabase:self.database withCompletionHandler:^(Event * _Nullable event, NSError * _Nullable error) {
        if (!event || error) {
            completionHandler(error);
            return;
        }
        
        [RemindersScheduler scheduleReminderForEvent:event withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                completionHandler([NSError appErrorWithDescription:@"Could not schedule reminder for event: %@", note]);
                return;
            }
            
            completionHandler(nil);
        }];
    }];
}

- (void)getSubscriptionStatusForEventNotificationsWithCompletionHandler:(void(^)(BOOL isSubscribed))completionHandler {
    CKFetchSubscriptionsOperation *fetchAllSubscriptions = CKFetchSubscriptionsOperation.fetchAllSubscriptionsOperation;
    fetchAllSubscriptions.fetchSubscriptionCompletionBlock = ^(NSDictionary<NSString *,CKSubscription *> * _Nullable subscriptionsBySubscriptionID, NSError * _Nullable operationError) {
        BOOL newEventSubscriptionExists = subscriptionsBySubscriptionID[newEventSubscriptionIDv1] != nil;
        completionHandler(newEventSubscriptionExists);
    };
    
    [self.database addOperation:fetchAllSubscriptions];
}

- (void)createNewEventSubscription {
    CKNotificationInfo *note = [[CKNotificationInfo alloc] init];
    note.shouldSendContentAvailable = true;
    
    NSPredicate *aslwaysTrue = [NSPredicate predicateWithValue:true];
    CKQuerySubscription *sub = [[CKQuerySubscription alloc]
        initWithRecordType:@"Event"
                 predicate:aslwaysTrue
                   options:CKQuerySubscriptionOptionsFiresOnRecordCreation];
    sub.notificationInfo = note;
    
    CKModifySubscriptionsOperation *addNewEventsSub = [[CKModifySubscriptionsOperation alloc] initWithSubscriptionsToSave:@[sub] subscriptionIDsToDelete:nil];
    
    [self.database addOperation:addNewEventsSub];
}

@end

