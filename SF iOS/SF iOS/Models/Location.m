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
    NSString* name = [record objectForKey:@"name"];
    NSString* streetAddress = [record objectForKey:@"streetAddress"];
    CLLocation *location = [record objectForKey:@"location"];
    
    return [self initWithName:name streetAddress:streetAddress location:location];
}

- (instancetype)initWithName:(NSString *)name streetAddress:(NSString *)streetAddress location:(CLLocation *)location {
    if (self = [super init]) {
        self.name = name;
        self.streetAddress = streetAddress;
        self.location = location;
    }
    
    return self;
}

@end
