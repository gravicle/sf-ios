//
//  FeedItem.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "FeedItem.h"
#import "NSDate+Utilities.h"

@implementation FeedItem

- (instancetype)initWithEvent:(Event *)event {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.dateString = [self dateStringFromDate:event.date];
    self.title = event.location.name;
    self.subtitle = [@[event.location.streetAddress, [self timeStringFromDate:event.date duration:event.duration]] componentsJoinedByString: @", "];
    self.shouldShowDirections = [self directionsAreRelevantForEventWithDate:event.date];
    self.coverImageFileURL = event.location.imageFileURL;
    self.location = event.location.location;
    self.annotationImage = event.annotationImage;
    
    return self;
}

//MARK: - Time Representation

- (NSString *)dateStringFromDate:(NSDate *)date {
    NSString *relativeDate = date.relativeDayRepresentation;
    if (relativeDate) {
        return relativeDate;
    } else if (date.isThisYear) {
        return [self stringFromDate:date withformat:@"MMM d"];
    } else {
        return [self stringFromDate:date withformat:@"MMM d, yyyy"];
    }
}

- (NSString *)timeStringFromDate:(NSDate *)date duration:(NSTimeInterval)duration {
    NSDate *endDate = [date dateByAddingTimeInterval:duration];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL startDateIsInAM = [calendar component:NSCalendarUnitHour fromDate:date] < 12;
    BOOL endDateIsInAM = [calendar component:NSCalendarUnitHour fromDate:endDate] < 12;
    BOOL shouldShowPeriodInStartDate = (startDateIsInAM != endDateIsInAM); // show period when start and end are in different periods
    
    NSString *timeFormat = @"h:mm";
    NSString *timeFormatWithPeriod = @"h:mma";
    NSString *startTime = [self stringFromDate:date withformat:shouldShowPeriodInStartDate ? timeFormatWithPeriod : timeFormat];
    NSString *endTime = [self stringFromDate:endDate withformat:timeFormatWithPeriod];
    
    return [@[startTime, endTime] componentsJoinedByString:@" - "];
}

- (NSString *)stringFromDate:(NSDate *)date withformat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

- (BOOL)directionsAreRelevantForEventWithDate:(NSDate *)date {
    if (date.isToday || date.isInFuture) {
        return true;
    }
    return false;
}

@end
