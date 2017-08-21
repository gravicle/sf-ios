//
//  ImageStore.m
//  SF iOS
//
//  Created by Amit Jain on 8/14/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "ImageStore.h"
#import "UIApplication+Metadata.h"

@interface ImageStore ()

@property (nonatomic) NSCache *cache;

@end

@implementation ImageStore

- (instancetype)init {
    if (self = [super init]) {
        self.cache = [[NSCache alloc] init];
        self.cache.countLimit = 20;
        self.cache.name = [NSString stringWithFormat:@"%@.image-cache", [UIApplication sharedApplication].bundleIdentifier];
    }
    
    return self;
}

- (void)storeImage:(UIImage *)image forKey:(id)key {
    [self.cache setObject:image forKey:key];
}

- (UIImage *)imageForKey:(id)key {
    return [self.cache objectForKey:key];
}

@end
