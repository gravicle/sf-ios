//
//  Location.h
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudKitDerivedRecord.h"
@import CoreLocation;
@import CloudKit;

NS_ASSUME_NONNULL_BEGIN
@interface Location : CloudKitDerivedRecord

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *streetAddress;
@property (nonatomic) CLLocation *location;
@property (nullable, nonatomic) NSURL *imageFileURL;

@end
NS_ASSUME_NONNULL_END
