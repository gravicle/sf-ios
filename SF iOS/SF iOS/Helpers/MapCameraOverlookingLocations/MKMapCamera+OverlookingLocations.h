//
//  MKMapCamera+OverlookingLocations.h
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface MKMapCamera (OverlookingLocations)

+ (MKMapCamera *)cameraOverlookingLocation1:(CLLocation *)location1 location2:(CLLocation *)location2 withPadding:(double)padding;

@end
NS_ASSUME_NONNULL_END
