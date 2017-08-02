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
    self.time = [self timeStringFromDate:event.date];
    self.title = event.location.name;
    self.subtitle = event.location.streetAddress;
    self.shouldShowDirections = [self directionsAreRelevantForEventWithDate:event.date];
    self.coverImageURL = nil;
    self.location = event.location.location;
    
    switch (event.type) {
        case EventTypeSFCoffee:
            self.annotationImage = [UIImage imageNamed:@"coffee-location-icon"];
            break;
        default:
            break;
    }
    
    return self;
}

//MARK: - Time Representation

- (NSString *)timeStringFromDate:(NSDate *)date {
    NSString *relativeDate = date.relativeDayRepresentation;
    if (relativeDate) {
        return relativeDate;
    } else if (date.isThisYear) {
        return [self stringFromDate:date withformat:@"MMM d"];
    } else {
        return [self stringFromDate:date withformat:@"MMM d, yyyy"];
    }
}

- (NSString *)stringFromDate:(NSDate *)date withformat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

- (BOOL)directionsAreRelevantForEventWithDate:(NSDate *)date {
    BOOL dateIsIsFuture = [date compare:[NSDate new]] == NSOrderedDescending;
    if (date.isToday || dateIsIsFuture) {
        return true;
    }
    return false;
}

@end
