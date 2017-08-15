//
//  ImageStore.h
//  SF iOS
//
//  Created by Amit Jain on 8/14/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface ImageStore : NSObject

- (void)storeImage:(UIImage *)image forKey:(id)key;
- (nullable UIImage *)imageForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
