//
//  NSDate+Utilities.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

- (BOOL)isYesterday {
    return [[NSCalendar currentCalendar] isDateInYesterday:self];
}

- (BOOL)isToday {
    return [[NSCalendar currentCalendar] isDateInToday:self];
}

- (BOOL)isTomorrow {
    return [[NSCalendar currentCalendar] isDateInTomorrow:self];
}

-(NSString *)relativeDayRepresentation {
    if (self.isYesterday) {
        return @"Yesterday";
    } else if (self.isToday) {
        return @"Today";
    } else if (self.isTomorrow) {
        return @"Tomorrow";
    } else {
        return nil;
    }
}

- (BOOL)isThisYear {
    NSInteger dateYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self];
    NSInteger currentYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate new]];
    return  dateYear == currentYear;
}

- (BOOL)isInFuture {
    return [self compare:[NSDate new]] == NSOrderedDescending;
}

- (NSString *)abbreviatedTimeintervalFromNow {
    NSTimeInterval difference = [self timeIntervalSinceNow];
    return [NSDate abbreviatedTimeIntervalForTimeInterval:difference];
}

+ (NSString *)abbreviatedTimeIntervalForTimeInterval:(NSTimeInterval)timeInterval {
    NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
    
    if (timeInterval > 86400) {
        formatter.allowedUnits = NSCalendarUnitDay | NSCalendarUnitHour;
    } else {
        formatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute;
    }
    
    return [formatter stringFromTimeInterval:timeInterval];
}

+ (NSString *)timeslotStringFromStartDate:(NSDate *)startDate duration:(NSTimeInterval)duration {
    NSDate *endDate = [startDate dateByAddingTimeInterval:duration];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL startDateIsInAM = [calendar component:NSCalendarUnitHour fromDate:startDate] < 12;
    BOOL endDateIsInAM = [calendar component:NSCalendarUnitHour fromDate:endDate] < 12;
    BOOL shouldShowPeriodInStartDate = (startDateIsInAM != endDateIsInAM); // show period when start and end are in different periods
    
    NSString *timeFormat = @"h:mm";
    NSString *timeFormatWithPeriod = @"h:mma";
    NSString *startTime = [startDate stringWithformat:shouldShowPeriodInStartDate ? timeFormatWithPeriod : timeFormat];
    NSString *endTime = [endDate stringWithformat:timeFormatWithPeriod];
    
    return [@[startTime, endTime] componentsJoinedByString:@" - "];
}

- (NSString *)stringWithformat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (BOOL)isLaterThanDate:(NSDate *)date {
    return [self compare:date] == NSOrderedDescending;
}

@end
