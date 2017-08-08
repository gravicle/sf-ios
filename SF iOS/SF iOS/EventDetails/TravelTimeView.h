//
//  TravelTimeView.h
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelTime.h"
#import "DirectionsRequestHandler.h"
#import "TravelTime+Arrival.h"

NS_ASSUME_NONNULL_BEGIN
@interface TravelTimeView : UIControl

- (instancetype)initWithTravelTime:(TravelTime *)travelTime arrival:(Arrival)arrival directionsRequestHandler:(DirectionsRequestHandler)directionsRequestHandler NS_DESIGNATED_INITIALIZER;

@end
NS_ASSUME_NONNULL_END
