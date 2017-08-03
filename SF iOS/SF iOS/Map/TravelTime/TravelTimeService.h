//
//  TravelTimeService.h
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TravelTime.h"

NS_ASSUME_NONNULL_BEGIN
@interface TravelTimeService : NSObject

typedef void(^TravelTimeCompletionHandler)(NSArray<TravelTime *> *travelTimes);
- (void)calculateTravelTimesFromLocation:(CLLocation *)sourceLocation toLocation:(CLLocation *)destinationLocation withCompletionHandler:(TravelTimeCompletionHandler)completionHandler;

@end
NS_ASSUME_NONNULL_END
