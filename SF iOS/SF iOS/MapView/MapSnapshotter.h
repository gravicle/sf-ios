//
//  MapSnapshotter.h
//  SF iOS
//
//  Created by Amit Jain on 8/1/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@interface MapSnapshotter : NSObject

- (instancetype)initWithLocationManager:
    (nullable CLLocationManager *)locationManager;
- (void)snapshotOfsize:(CGSize)size showingDestinationLocation:(CLLocation *)location withCompletionHandler:(void (^)(UIImage * _Nullable image, NSError * _Nullable error))completionHandler;

@end
NS_ASSUME_NONNULL_END
