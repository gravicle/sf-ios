//
//  AsyncBlockOperation.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "AsyncBlockOperation.h"

@interface AsyncBlockOperation ()

@property (nonatomic, copy) AsyncBlock block;

@end


@implementation AsyncBlockOperation

+ (instancetype)asyncBlockOperationWithBlock:(AsyncBlock)block {
    return [[AsyncBlockOperation alloc] initWithAsyncBlock:block];
}

- (instancetype)initWithAsyncBlock:(AsyncBlock)block {
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (void)start {
    [super start];
    
    self.block(^{
        [self finish];
    });
}

@end
