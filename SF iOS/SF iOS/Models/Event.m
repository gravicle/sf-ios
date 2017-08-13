//
//  Event.m
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "Event.h"
#import "NSDate+Utilities.h"
@import CloudKit;

@implementation Event

- (instancetype)initWithRecord:(CKRecord *)record location:(Location *)location {
    if (self = [super initWithRecord:record]) {
        self.type = [(NSNumber *)record[@"eventType"] integerValue];
        self.date = record[@"eventDate"];
        self.duration = [(NSNumber *)record[@"duration"] doubleValue];
        self.location = location;
    }
    
    return self;
}

- (UIImage *)annotationImage {
    switch (self.type) {
        case EventTypeSFCoffee:
            return [UIImage imageNamed:@"coffee-location-icon"];
            break;
        default:
            break;
    }
}

- (NSDate *)endDate {
    return [self.date dateByAddingTimeInterval:self.duration];
}

- (BOOL)isActive {
    return self.endDate.isInFuture;
}

- (BOOL)hasBeenModifiedSinceRecord:(CloudKitDerivedRecord *)cachedRecord {
    BOOL isEventModified = [super hasBeenModifiedSinceRecord:cachedRecord];
    BOOL isLocationModified = [self.location hasBeenModifiedSinceRecord:[(Event *)cachedRecord location]];
    return isEventModified || isLocationModified;
}

@end
