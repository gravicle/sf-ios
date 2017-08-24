//
//  RemindersScheduler.m
//  SF iOS
//
//  Created by Amit Jain on 8/20/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

@import UserNotifications;
#import "RemindersScheduler.h"
#import "NSDate+Utilities.h"
#import "NotificationHandler.h"
#import "NSError+Constructor.h"
#import "AsyncBlockOperation.h"

@interface RemindersScheduler ()

@property (nonatomic) NSOperationQueue *schedulerSerialQueue;

@end

@implementation RemindersScheduler

- (instancetype)init {
    if (self = [super init]) {
        self.schedulerSerialQueue = [[NSOperationQueue alloc] init];
        self.schedulerSerialQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)scheduleReminderForEvent:(Event *)event withCompletionHandler:(RemindersSchedulerCompletionHandler)callCompletionHandler {
    if (event.date.isInThePast) {
        callCompletionHandler([NSError appErrorWithDescription:@"Event is in the past %@", event]);
        return;
    }
    
    __weak typeof(self) welf = self;
    AsyncBlockOperation *scheduleOperation = [AsyncBlockOperation asyncBlockOperationWithBlock:^(dispatch_block_t  _Nonnull blockCompletionHandler) {
        void (^completionHandler)(NSError *_Nullable) = ^void(NSError *error) {
            callCompletionHandler(error);
            blockCompletionHandler();
        };
        
        [welf getScheduledStatusOfNotificationWithID:event.identifier withCompletionHandler:^(BOOL hasBeenScheduled) {
            if (hasBeenScheduled) {
                completionHandler([NSError appErrorWithDescription:@"Reminder already scheduled"]);
                return;
            }
            
            [welf getDeliveredStatusOfNotificationWithID:event.identifier withCompletionHandler:^(BOOL hasBeenDelevered) {
                if (hasBeenDelevered) {
                    completionHandler([NSError appErrorWithDescription:@"Reminder already delivered"]);
                    return;
                }
                
                [welf scheduleLocalNotificationForEvent:event withCompletionHandler:completionHandler];
            }];
        }];
    }];
    
    [self.schedulerSerialQueue addOperation:scheduleOperation];
}

- (void)scheduleLocalNotificationForEvent:(Event *)event withCompletionHandler:(RemindersSchedulerCompletionHandler)completionHandler {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    // SF ☕️
    content.title = [NSString stringWithFormat:@"SF %@", event.typeDescription];
    
    // Join fellow iOS developers tomorrow 8:30AM for ☕️ at Haus Coffee on 8061 Valencia St.
    NSString *day = event.date.relativeDayRepresentation;
    NSString *time = [event.date stringWithFormat:@"h:mma"];
    NSString *date = [NSString stringWithFormat:@"%@ %@", day, time];
    NSString *location = [NSString stringWithFormat:@"%@ on %@", event.location.name, event.location.streetAddress];
    content.body = [NSString stringWithFormat:@"Join fellow iOS developers %@ for %@ at %@.", date, event.typeDescription, location];
    
    content.userInfo = [NotificationHandler userInfoDictionaryWithEvent:event];

    NSDateComponents *reminderDate = [self reminderDateForEventWithDate:event.date];
    UNNotificationRequest *noteRequest = [UNNotificationRequest
        requestWithIdentifier:event.identifier
                      content:content
                      trigger:[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:reminderDate repeats:false]];

    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:noteRequest withCompletionHandler:completionHandler];
}

- (void)getScheduledStatusOfNotificationWithID:(NSString *)notificationID withCompletionHandler:(void(^)(BOOL hasBeenScheduled))completionHandler {
    [UNUserNotificationCenter.currentNotificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            if ([request.identifier isEqualToString:notificationID]) {
                completionHandler(true);
                return;
            }
        }
        
        completionHandler(false);
    }];
}

- (void)getDeliveredStatusOfNotificationWithID:(NSString *)notificationID withCompletionHandler:(void(^)(BOOL hasBeenDelevered))completionHandler {
    [UNUserNotificationCenter.currentNotificationCenter getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        for (UNNotification *note in notifications) {
            if ([note.request.identifier isEqualToString:notificationID]) {
                completionHandler(true);
                return;
            }
        }
        
        completionHandler(false);
    }];
}

/// 6pm the eve before, if past, now
- (NSDateComponents *)reminderDateForEventWithDate:(NSDate *)eventDate {
    NSCalendarUnit components = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *eventDateComponents = [NSCalendar.currentCalendar components:components fromDate:eventDate];
    NSDateComponents *reminderDateComponents = [eventDateComponents copy];
    reminderDateComponents.day -= 1;
    reminderDateComponents.hour = 18;
    reminderDateComponents.minute = 0;
    
    if ([NSCalendar.currentCalendar dateFromComponents:reminderDateComponents].isInThePast) {
        return [NSCalendar.currentCalendar components:components fromDate:[NSDate new]];
    } else {
        return eventDateComponents;
    }
}

@end
