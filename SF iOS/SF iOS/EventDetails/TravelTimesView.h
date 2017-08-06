//
//  TravelTimesView.h
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelTime.h"
#import "DirectionsRequestHandler.h"

NS_ASSUME_NONNULL_BEGIN
@interface TravelTimesView : UIStackView

- (instancetype)initWithDirectionsRequestHandler:(DirectionsRequestHandler)directionsRequestHandler NS_DESIGNATED_INITIALIZER;

- (void)configureWithTravelTimes:(NSArray<TravelTime *> *)travelTimes;

@end
NS_ASSUME_NONNULL_END
