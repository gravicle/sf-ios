//
//  TravelTime.h
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface TravelTime : NSObject

@property (nonatomic, assign) MKDirectionsTransportType transportationType;
@property (nonatomic, assign) NSTimeInterval travelTime;
@property (nonatomic, readonly) NSString *travelTimeEstimateString;

- (instancetype)initWithTransportType:(MKDirectionsTransportType)transportType travelTime:(NSTimeInterval)travelTime;

@end
