//
//  ImageStore.m
//  SF iOS
//
//  Created by Amit Jain on 8/14/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "ImageStore.h"
#import "UIImage+URL.h"
#import "UIApplication+Metadata.h"

@interface ImageStore ()

@property (nonatomic) NSCache *cache;
@property (nonatomic) NSOperationQueue *queue;

@end

@implementation ImageStore

- (instancetype)init {
    if (self = [super init]) {
        self.cache = [[NSCache alloc] init];
        self.cache.countLimit = 20;
        self.cache.name = [NSString stringWithFormat:@"%@.image-cache", [UIApplication sharedApplication].bundleIdentifier];
        
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.name = [NSString stringWithFormat:@"%@.image-store-queue", [UIApplication sharedApplication].bundleIdentifier];
    }
    
    return self;
}

- (void)getImageFromImageFileURL:(NSURL *)fileURL withCompletionHandler:(ImageStoreCompletionHandler)completionHandler {
    NSAssert(fileURL.isFileURL, @"%@ is not a file URL", fileURL);
    
    UIImage *cachedImage = [self imageForKey:fileURL];
    if (cachedImage) {
        completionHandler(cachedImage, ImageSourceCache);
        return;
    }
    
    [UIImage imageFromFileURL:fileURL withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
        completionHandler(image, ImageSourceOrigin);
    }];
}

- (void)getMapImageOfSize:(CGSize)size forDestinationLocation:(CLLocation *)destination annotatedWithImage:(UIImage *)annotationImage {
    
}

- (nullable UIImage *)imageForKey:(id)key {
    return [self.cache objectForKey:key];
}

@end
