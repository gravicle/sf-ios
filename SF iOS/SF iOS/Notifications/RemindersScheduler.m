//
//  RemindersScheduler.m
//  SF iOS
//
//  Created by Amit Jain on 8/20/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

@import UserNotifications;
#import "RemindersScheduler.h"
#import "EventFetcher.h"
#import "NSDate+Utilities.h"
#import "NotificationHandler.h"
#import "NSError+Constructor.h"

@implementation RemindersScheduler

+ (void)scheduleReminderForEvent:(Event *)event withCompletionHandler:(RemindersSchedulerCompletionHandler)completionHandler {
    if (event.date.isInThePast) {
        completionHandler([NSError appErrorWithDescription:@"Event is in the past %@", event]);
        return;
    }
    
    [self getScheduledStatusOfNotificationWithID:event.identifier withCompletionHandler:^(BOOL hasBeenScheduled) {
        if (hasBeenScheduled) {
            completionHandler(nil);
            return;
        }
        
        [self getDeliveredStatusOfNotificationWithID:event.identifier withCompletionHandler:^(BOOL hasBeenDelevered) {
            if (hasBeenScheduled) {
                completionHandler(nil);
                return;
            }
            
            [self scheduleLocalNotificationForEvent:event withCompletionHandler:completionHandler];
        }];
    }];
}

+ (void)scheduleLocalNotificationForEvent:(Event *)event withCompletionHandler:(RemindersSchedulerCompletionHandler)completionHandler {
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
    
    UNNotificationRequest *request = [UNNotificationRequest
                                      requestWithIdentifier:event.identifier
                                      content:content
                                      trigger:[self triggerForEventWithDate:event.date]];
    
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:completionHandler];
}

+ (void)getScheduledStatusOfNotificationWithID:(NSString *)notificationID withCompletionHandler:(void(^)(BOOL hasBeenScheduled))completionHandler {
    [UNUserNotificationCenter.currentNotificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for (UNNotificationRequest *request in requests) {
            if (request.identifier == notificationID) {
                completionHandler(true);
                return;
            }
        }
        
        completionHandler(false);
    }];
}

+ (void)getDeliveredStatusOfNotificationWithID:(NSString *)notificationID withCompletionHandler:(void(^)(BOOL hasBeenDelevered))completionHandler {
    [UNUserNotificationCenter.currentNotificationCenter getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        for (UNNotification *note in notifications) {
            if (note.request.identifier == notificationID) {
                completionHandler(true);
                return;
            }
        }
        
        completionHandler(false);
    }];
}

/// 6pm the eve before, if past, now
+ (UNNotificationTrigger *)triggerForEventWithDate:(NSDate *)eventDate {
    NSDateComponents *eventDateComponents = [NSCalendar.currentCalendar
                                             components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                             fromDate:eventDate];
    
    NSDateComponents *reminderDateComponents = [eventDateComponents copy];
    reminderDateComponents.day -= 1;
    reminderDateComponents.hour = 18;
    reminderDateComponents.minute = 0;
    
    if ([NSCalendar.currentCalendar dateFromComponents:reminderDateComponents].isInThePast) {
        return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:false];
    }
    
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:reminderDateComponents repeats:false];
}

@end
