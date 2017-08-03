//
//  AsyncOperation.h
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

// https://stackoverflow.com/a/26895501/2671390

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AsyncBlock)(dispatch_block_t completionHandler);

@interface AsyncOperation : NSOperation

@property (nonatomic, readonly, copy) AsyncBlock block;

+ (instancetype)asyncBlockOperationWithBlock:(AsyncBlock)block;
- (instancetype)initWithAsyncBlock:(AsyncBlock)block;

@end
NS_ASSUME_NONNULL_END
