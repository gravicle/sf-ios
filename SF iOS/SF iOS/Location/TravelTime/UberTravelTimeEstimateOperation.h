//
//  UberTravelTimeEstimateOperation.h
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "HTTPRequestAsyncOperation.h"
#import "TravelTime.h"
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN
@interface UberTravelTimeEstimateOperation : HTTPRequestAsyncOperation

typedef void(^UberTravelTimeEstimateCompletion)(TravelTime *_Nullable travelTime, NSError *_Nullable error);

- (instancetype)initWithStartLocation:(CLLocation *)startLocation endLocation:(CLLocation *)endLocation completionHandler:(UberTravelTimeEstimateCompletion)completionHandler;

@end
NS_ASSUME_NONNULL_END
