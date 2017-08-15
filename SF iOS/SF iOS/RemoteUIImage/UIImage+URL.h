//
//  UIImage+URL.h
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIImage (URL)

typedef void(^ImageDownloadCompletionHandler)(UIImage *_Nullable image, NSError *_Nullable error);

+ (void)fetchImageFromFileURL:(NSURL *)fileURL onQueue:(nullable NSOperationQueue *)queue withCompletionHandler:(ImageDownloadCompletionHandler)completionHandler;

@end
NS_ASSUME_NONNULL_END
