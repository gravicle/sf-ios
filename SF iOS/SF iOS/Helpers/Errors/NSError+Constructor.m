//
//  NSError+Constructor.m
//  SF iOS
//
//  Created by Amit Jain on 7/30/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "NSError+Constructor.h"

@implementation NSError (Constructor)

+ (nonnull NSError *)appErrorWithDescription:(nonnull NSString *)description {
    return [NSError appErrorWithDescription:description errorCode:0];
}

+ (NSError *)appErrorWithDescription:(NSString *)description errorCode:(NSInteger)code {
    return [[NSError alloc] initWithDomain:[NSBundle mainBundle].bundleIdentifier
                                      code:code
                                  userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(description, nil)}];
}

@end
