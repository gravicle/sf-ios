//
//  LyftTravelTimeEstimateOperation.h
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "HTTPRequestAsyncOperation.h"
#import "TravelTimeCalculationCompletion.h"
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN
@interface LyftTravelTimeEstimateOperation : HTTPRequestAsyncOperation

- (instancetype)initWithSourceLocation:(CLLocation *)sourceLocation destinationLocation:(CLLocation *)destinationLocation completionHandler:(TravelTimeCalculationCompletion)completionHandler;

@end
NS_ASSUME_NONNULL_END
