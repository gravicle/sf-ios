//
//  Location.m
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "Location.h"

@implementation Location

+ (NSString *)recordName {
    return @"Location";
}

- (instancetype)initWithRecord:(CKRecord *)record {
    NSString* name = record[@"name"];
    NSString* streetAddress = record[@"streetAddress"];
    CLLocation *location = record[@"location"];
    CKAsset *imageAsset = record[@"image"];
    
    return [self initWithName:name streetAddress:streetAddress location:location imageFileURL:imageAsset.fileURL];
}

- (instancetype)initWithName:(NSString *)name streetAddress:(NSString *)streetAddress location:(CLLocation *)location imageFileURL:(NSURL *)imageURL{
    if (self = [super init]) {
        self.name = name;
        self.streetAddress = streetAddress;
        self.location = location;
        self.imageFileURL = imageURL;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return false;
    }
    Location *location = (Location *)object;
    return (self.location.coordinate.latitude == location.location.coordinate.latitude) &&
           (self.location.coordinate.longitude == location.location.coordinate.longitude) &&
           [self.streetAddress isEqual:location.streetAddress] &&
           [self.name isEqual:location.name];
}

@end
