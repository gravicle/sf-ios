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

- (void)snapshotWithDestinationLocation:(CLLocation *)location
                      completionHandler:(void(^)(UIImage * _Nullable image, NSError * _Nullable error))completionHandler;

@end
NS_ASSUME_NONNULL_END
