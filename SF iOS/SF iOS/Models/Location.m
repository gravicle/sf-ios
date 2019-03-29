//
//  Location.m
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.streetAddress = dict[@"formatted_address"];
        self.name = dict[@"name"];
        CLLocationDegrees latitude = [dict[@"latitude"] doubleValue];
        CLLocationDegrees longitude = [dict[@"longitude"] doubleValue];
        self.location = [[CLLocation alloc] initWithLatitude:latitude
                                                   longitude:longitude];
    }
    return self;
}

@end
