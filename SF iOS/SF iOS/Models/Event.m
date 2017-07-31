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
    EventType type = [(NSNumber *)[record objectForKey:@"eventType"] integerValue];
    NSDate *date = [record objectForKey:@"eventDate"];
    
    return [self initWithEventType:type date:date location:location];
}

- (instancetype)initWithEventType:(EventType)type date:(NSDate *)date location:(Location *)location {
    if (self = [super init]) {
        self.type = type;
        self.date = date;
        self.location = location;
    }
    
    return self;
}

@end
