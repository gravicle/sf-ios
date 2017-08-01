//
//  MapView.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN
@interface MapView : UIView

@property (nonatomic, assign) BOOL showsUserLocation;
- (void)setDestinationToLocation:(CLLocation *)destination;

@end
NS_ASSUME_NONNULL_END
