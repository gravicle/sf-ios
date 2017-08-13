//
//  FeedItemTests.m
//  SF iOSTests
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Event.h"
#import "FeedItem.h"
#import "Location.h"

@interface FeedItemTests : XCTestCase

@property (nonatomic) Event *event;

@end

@implementation FeedItemTests

- (void)setUp {
    [super setUp];
    
    CKRecord *locRecord = [[CKRecord alloc] initWithRecordType:Location.recordName];
    Location *location = [[Location alloc] initWithRecord:locRecord];
    location.name = @"Test Event";
    location.streetAddress = @"600 Post St.";
    location.location = [[CLLocation alloc] initWithLatitude:37.7564388 longitude:-122.4213833];
    
    CKRecord *eventRecord = [[CKRecord alloc] initWithRecordType:Event.recordName];
    self.event = [[Event alloc] initWithRecord:eventRecord location:location];
    self.event.type = EventTypeSFCoffee;
    self.event.date = [NSDate new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEventInTomorrow {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitDay value:1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    XCTAssertTrue([item.dateString isEqualToString:@"Tomorrow"]);
    XCTAssertTrue(item.isActive);
}

- (void)testEventInToday {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitHour value:1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    XCTAssertTrue([item.dateString isEqualToString:@"Today"]);
    XCTAssertTrue(item.isActive);
}

- (void)testEventInPastButStillInToday {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitHour value:-1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    XCTAssertTrue([item.dateString isEqualToString:@"Today"]);
    XCTAssertTrue(item.isActive);
}

- (void)testEventInYesterday {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    XCTAssertTrue([item.dateString isEqualToString:@"Yesterday"]);
    XCTAssertEqual(item.isActive, false);
}

- (void)testEventInLastMonth {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM d";
    NSString *expctedTime = [formatter stringFromDate:eventDate];
    
    XCTAssertTrue([item.dateString isEqualToString:expctedTime]);
    XCTAssertFalse(item.isActive);
}

- (NSDate *)dateByAddingUnit:(NSCalendarUnit)calendarUnit value:(NSInteger)value toDate:(NSDate *)date {
    return [[NSCalendar currentCalendar] dateByAddingUnit:calendarUnit value:value toDate:date options:0];
}

@end
