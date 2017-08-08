//
//  FeedItem.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "FeedItem.h"
#import "NSDate+Utilities.h"
#import "NSAttributedString+Kerning.h"

@implementation FeedItem

- (instancetype)initWithEvent:(Event *)event {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.dateString = [self dateStringFromDate:event.date];
    self.title = event.location.name;
    self.isUpcoming = [self directionsAreRelevantForEventWithDate:event.date];
    self.coverImageFileURL = event.location.imageFileURL;
    self.location = event.location.location;
    self.annotationImage = event.annotationImage;
    
    NSString *location = event.location.streetAddress;
    NSString *time;
    
    if ([[NSDate new] isBetweenEarlierDate:event.date laterDate:event.endDate]) {
        time = @"Now";
    } else {
        time = [NSDate timeslotStringFromStartDate:event.date duration:event.duration];
    }
    
    NSString *subtite = [NSString stringWithFormat:@"%@, %@", location, time];
    self.subtitle = [NSAttributedString kernedStringFromString:[subtite uppercaseString]];
    
    return self;
}

//MARK: - Time Representation

- (NSString *)dateStringFromDate:(NSDate *)date {
    NSString *relativeDate = date.relativeDayRepresentation;
    if (relativeDate) {
        return relativeDate;
    } else if (date.isThisYear) {
        return [date stringWithformat:@"MMM d"];
    } else {
        return [date stringWithformat:@"MMM d, yyyy"];
    }
}

- (BOOL)directionsAreRelevantForEventWithDate:(NSDate *)date {
    if (date.isToday || date.isInFuture) {
        return true;
    }
    return false;
}

@end
