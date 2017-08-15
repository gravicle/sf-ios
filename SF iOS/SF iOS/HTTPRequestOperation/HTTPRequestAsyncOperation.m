//
//  HTTPRequestAsyncOperation.m
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "HTTPRequestAsyncOperation.h"

@interface HTTPRequestAsyncOperation ()

@property (nonatomic) NSURLSessionDataTask *task;

@end

@implementation HTTPRequestAsyncOperation

- (instancetype)initWithRequest:(NSURLRequest *)request completionHandler:(HTTPRequestCompletionHandler)completionHandler {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    __weak typeof(self) welf = self;
    self.task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (self.isCancelled) { return; }
        
        if (!error && data) {
            NSError *jsonParsingError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            if (!jsonParsingError && json) {
                completionHandler(json, response, nil);
            } else {
                completionHandler(nil, response, jsonParsingError);
            }
        } else {
            completionHandler(nil, response, error);
        }
        
        [welf finish];
    }];
    
    return self;
}

- (void)start {
    [super start];
    [self.task resume];
}

- (void)cancel {
    [self.task cancel];
    [super cancel];
}

@end
