//
//  RemindersSchedulerTests.m
//  SF iOSTests
//
//  Created by Amit Jain on 8/23/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RemindersScheduler.h"

@interface RemindersScheduler (Tests)

+ (NSDateComponents *)reminderDateForEventWithDate:(NSDate *)eventDate;

@end

@interface RemindersSchedulerTests : XCTestCase

@end

@implementation RemindersSchedulerTests

- (void)testThatReminderIsSetForTheEveningBefore {
    NSDateComponents *aWeekHence = [NSCalendar.currentCalendar
                                    components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                    fromDate:[NSDate new]];
    aWeekHence.day += 7;
    aWeekHence.hour = 8;
    aWeekHence.minute = 30;
    
    NSDate *eventDate = [NSCalendar.currentCalendar dateFromComponents:aWeekHence];
    
    NSDate *exepectedReminder = [eventDate dateByAddingTimeInterval:-14.5 * 60 * 60];
    NSDate *reminderDate = [RemindersScheduler reminderDateForEventWithDate:eventDate].date;
    
    XCTAssertTrue([reminderDate compare:exepectedReminder] == NSOrderedSame);
}

- (void)testThatReminderIsSetForNowWhenTheEventIsImpending {
    NSDateComponents *anHourFromNow = [NSCalendar.currentCalendar
                                    components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                    fromDate:[NSDate new]];
    anHourFromNow.hour += 1;
    
    NSDate *eventDate = [NSCalendar.currentCalendar dateFromComponents:anHourFromNow];
    
    NSDate *exepectedReminder = [NSDate new];
    NSDate *reminderDate = [RemindersScheduler reminderDateForEventWithDate:eventDate].date;
    
    XCTAssertTrue([reminderDate compare:exepectedReminder] == NSOrderedSame);
}

@end
