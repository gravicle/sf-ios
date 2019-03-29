//
//  Location.h
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN
@interface Location : NSObject

@property (nonatomic) NSString *streetAddress;
@property (nonatomic) CLLocation *location;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
NS_ASSUME_NONNULL_END
