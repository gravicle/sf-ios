//
//  VenueFetchOperation.h
//  SF iOS
//
//  Created by Roderic Campbell on 3/27/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenueCompletion.h"
#import "HTTPRequestAsyncOperation.h"
NS_ASSUME_NONNULL_BEGIN

@interface VenueFetchOperation : HTTPRequestAsyncOperation
- (instancetype)initWithVenueID:(NSString *)venueID completionHandler:(VenueCompletion)completionHandler;

@end

NS_ASSUME_NONNULL_END
