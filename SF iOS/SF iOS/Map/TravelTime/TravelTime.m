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
        self.transportType = transportType;
        self.travelTime = travelTime;
        
        switch (self.transportType) {
            case MKDirectionsTransportTypeTransit:
                self.icon = [UIImage imageNamed:@"icon-transport-type-transit"];
                break;
                
            case MKDirectionsTransportTypeWalking:
                self.icon = [UIImage imageNamed:@"icon-transport-type-walking"];
                break;
                
            case MKDirectionsTransportTypeAutomobile:
                self.icon = [UIImage imageNamed:@"icon-transport-type-automobile"];
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

- (NSString *)travelTimeEstimateString {
    return [NSDate abbreviatedTimeIntervalForTimeInterval:self.travelTime];
}

@end
