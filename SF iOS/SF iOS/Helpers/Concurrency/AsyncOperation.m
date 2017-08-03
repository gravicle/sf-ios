//
//  AsyncOperation.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "AsyncOperation.h"

@interface AsyncOperation () {
    BOOL _finished;
    BOOL _executing;
}

@property (nonatomic, copy) AsyncBlock block;

@end


@implementation AsyncOperation

+ (instancetype)asyncBlockOperationWithBlock:(AsyncBlock)block {
    return [[AsyncOperation alloc] initWithAsyncBlock:block];
}

- (instancetype)initWithAsyncBlock:(AsyncBlock)block {
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (void)start {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    self.block(^{
        [self willChangeValueForKey:@"isExecuting"];
        _executing = NO;
        [self didChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    });
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isAsynchronous {
    return YES;
}

@end
