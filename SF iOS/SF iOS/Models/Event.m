//
//  Event.m
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "Event.h"
#import "NSDate+Utilities.h"
@import CloudKit;

@implementation Event

- (instancetype)initWithDictionary:(NSDictionary *)record {
    if (self = [super init]) {
        self.type = EventTypeSFCoffee;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSString *startAt = record[@"start_at"];
        self.date = [formatter dateFromString:startAt];
        NSDate *endDate = [formatter dateFromString:record[@"end_at"]];
        self.duration = [endDate timeIntervalSinceDate:self.date];
        self.venueURL = [[NSURL alloc] initWithString:record[@"venue_url"]];

        NSString *imageURLString = record[@"image_url"];
        if (![imageURLString isKindOfClass:[NSNull class]]) {
            self.imageFileURL = [[NSURL alloc] initWithString:imageURLString];
        }
        self.name = record[@"name"];
    }
    
    return self;
}

- (UIImage *)annotationImage {
    switch (self.type) {
        case EventTypeSFCoffee:
            return [UIImage imageNamed:@"coffee-location-icon"];
            break;
        default:
            break;
    }
}

- (NSDate *)endDate {
    return [self.date dateByAddingTimeInterval:self.duration];
}

- (BOOL)isActive {
    return self.endDate.isInFuture;
}

@end
