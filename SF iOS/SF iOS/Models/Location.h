//
//  Location.h
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import CloudKit;

NS_ASSUME_NONNULL_BEGIN
@interface Location : NSObject

@property (class, nonatomic, readonly) NSString* recordName;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *streetAddress;
@property (nonatomic) CLLocation *location;

- (instancetype)initWithRecord:(CKRecord *)record;
- (instancetype)initWithName: (NSString *)name streetAddress: (NSString *)streetAddress location: (CLLocation *)location;

@end
NS_ASSUME_NONNULL_END
