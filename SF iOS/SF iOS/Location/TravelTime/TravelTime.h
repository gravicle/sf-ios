//
//  TravelTime.h
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

typedef NS_ENUM(NSUInteger, TransportType) {
    TransportTypeTransit,
    TransportTypeWalking,
    TransportTypeAutomobile,
    TransportTypeUber,
    TransportTypeLyft
};

NS_ASSUME_NONNULL_BEGIN
@interface TravelTime : NSObject

@property (nonatomic, assign) TransportType transportType;
@property (nonatomic, assign) NSTimeInterval travelTime;
@property (nonatomic, readonly) NSString *travelTimeEstimateString;
@property (nonatomic) UIImage *icon;

- (instancetype)initWithTransportType:(TransportType)transportType travelTime:(NSTimeInterval)travelTime;
- (instancetype)initWithMKDirectionsTransportType:(MKDirectionsTransportType)mkTransportType travelTime:(NSTimeInterval)travelTime;

@end
NS_ASSUME_NONNULL_END
