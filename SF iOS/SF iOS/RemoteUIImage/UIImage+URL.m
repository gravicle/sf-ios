//
//  UIImage+URL.m
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "UIImage+URL.h"
#import "NSError+Constructor.h"

@implementation UIImage (URL)

+ (NSURLSessionDataTask *)imageFromURL:(NSURL *)url withCompletionHandler:(ImageDownloadCompletionHandler)completionHandler {
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!image) {
                NSError *downloadError = error ? error : [NSError appErrorWithDescription:@"Could not download image."];
                completionHandler(nil, downloadError);
            }
            completionHandler(image, nil);
        });
    }];
    [downloadTask resume];
    
    return downloadTask;
}

+ (void)imageFromFileURL:(NSURL *)fileURL withCompletionHandler:(ImageDownloadCompletionHandler)completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        UIImage *image = nil;
        if (data) {
            image = [UIImage imageWithData:data];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(image, nil);
        });
    });
}

@end
