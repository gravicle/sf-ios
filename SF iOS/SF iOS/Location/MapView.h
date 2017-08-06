//
//  MapView.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;

NS_ASSUME_NONNULL_BEGIN
@interface MapView : UIView <MKMapViewDelegate>

typedef void(^UserLocationObserverBlock)(CLLocation *_Nullable userLocation);
- (instancetype)initWithUserLocationObserver:(nullable UserLocationObserverBlock)userLocationObserver NS_DESIGNATED_INITIALIZER;

- (void)setDestinationToLocation:(CLLocation *)destination withAnnotationImage:(UIImage *)annotationImage;

@end
NS_ASSUME_NONNULL_END
