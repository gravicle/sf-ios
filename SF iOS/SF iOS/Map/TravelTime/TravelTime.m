//
//  TravelTime.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTime.h"
#import "NSDate+Utilities.h"

@implementation TravelTime

- (instancetype)initWithTransportType:(MKDirectionsTransportType)transportType travelTime:(NSTimeInterval)travelTime {
    if (self = [super init]) {
        self.transportationType = transportType;
        self.travelTime = travelTime;
    }
    return self;
}

- (NSString *)travelTimeEstimateString {
    return [NSDate abbreviatedDurationForTimeInterval:self.travelTime];
}

@end
