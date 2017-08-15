//
//  ImageStore.h
//  SF iOS
//
//  Created by Amit Jain on 8/14/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ImageSource) {
    ImageSourceCache,
    ImageSourceOrigin
};

typedef void(^ImageStoreCompletionHandler)(UIImage * _Nullable image, ImageSource source);

@interface ImageStore : NSObject

- (void)getImageFromImageFileURL:(NSURL *)fileURL withCompletionHandler:(ImageStoreCompletionHandler)completionHandler;

- (void)getMapImageOfSize:(CGSize)size forDestinationLocation:(CLLocation *)destination annotatedWithImage:(UIImage *)annotationImage;

@end

NS_ASSUME_NONNULL_END
