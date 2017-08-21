//
//  NSError+Constructor.h
//  SF iOS
//
//  Created by Amit Jain on 7/30/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Constructor)

+ (nonnull NSError *)appErrorWithDescription:(nonnull NSString *)description, ...;
+ (nonnull NSError *)appErrorWithDescription:(nonnull NSString *)description errorCode:(NSInteger)code;

@end
