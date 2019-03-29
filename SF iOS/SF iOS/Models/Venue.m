//
//  Venue.m
//  SF iOS
//
//  Created by Roderic Campbell on 3/29/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import "Venue.h"
#import "Location.h"

@implementation Venue
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.venueURL = [[NSURL alloc] initWithString:dict[@"url"]];
        self.location = [[Location alloc] initWithDictionary:dict[@"location"]];
    }
    return self;
}

@end
