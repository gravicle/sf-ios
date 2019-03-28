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

+ (void)fetchImageFromURL:(NSURL *)fileURL onQueue:(nullable NSOperationQueue *)queue withCompletionHandler:(ImageDownloadCompletionHandler)completionHandler {

    if (!queue) {
        queue = [NSOperationQueue new];
    }

    [queue addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        UIImage *image = nil;
        if (data) {
            image = [UIImage imageWithData:data];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler(image, nil);
        }];
    }];
}

@end
