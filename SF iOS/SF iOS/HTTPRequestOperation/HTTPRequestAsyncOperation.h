//
//  HTTPRequestAsyncOperation.h
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "AsyncOperation.h"

NS_ASSUME_NONNULL_BEGIN
@interface HTTPRequestAsyncOperation : AsyncOperation

typedef NSDictionary<NSString *, id> JSON;

typedef void(^HTTPRequestCompletionHandler)(JSON * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error);

- (instancetype)initWithRequest:(NSURLRequest *)request completionHandler:(HTTPRequestCompletionHandler)completionHandler;

@end
NS_ASSUME_NONNULL_END
