//
//  MapSnapshotter.h
//  SF iOS
//
//  Created by Amit Jain on 8/1/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLocation.h"
@import CoreLocation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@interface MapSnapshotter : NSObject

- (instancetype)initWithUserLocationService:(UserLocation *)userLocationService;

typedef void(^MapSnapshotCompletionHandler)(UIImage * _Nullable image, NSError * _Nullable error);
- (void)snapshotOfsize:(CGSize)size showingDestinationLocation:(CLLocation *)location annotationImage:(UIImage *)annotationImage withCompletionHandler:(MapSnapshotCompletionHandler)completionHandler;

@end
NS_ASSUME_NONNULL_END
