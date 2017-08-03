//
//  Event.m
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "Event.h"
@import CloudKit;

@implementation Event

+ (NSString *)recordName {
    return @"Event";
}

- (instancetype)initWithRecord:(CKRecord *)record location:(Location *)location {
    EventType type = [(NSNumber *)record[@"eventType"] integerValue];
    NSDate *date = record[@"eventDate"];
    NSTimeInterval duration = [(NSNumber *)record[@"duration"] doubleValue];
    
    return [self initWithEventType:type date:date duration: duration location:location];
}

- (instancetype)initWithEventType:(EventType)type date:(NSDate *)date duration:(NSTimeInterval)duration location:(Location *)location {
    if (self = [super init]) {
        self.type = type;
        self.date = date;
        self.duration = duration;
        self.location = location;
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

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return false;
    }
    Event *event = (Event *)object;
    return (self.type == event.type) && [self.date isEqual:event.date] && [self.location isEqual:event.location];
}

@end
