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

@interface FeedItemTests : XCTestCase

@property (nonatomic) Event *event;

@end

@implementation FeedItemTests

- (void)setUp {
    [super setUp];
    
    Location *location = [[Location alloc] initWithName:@"Test Event" streetAddress:@"600 Post St." location: [[CLLocation alloc] initWithLatitude:37.7564388 longitude:-122.4213833]];
    self.event = [[Event alloc]
                  initWithEventType:EventTypeSFCoffee
                  date: [NSDate new]
                  location: location];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEventInTomorrow {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitDay value:1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    XCTAssertTrue([item.time isEqualToString:@"Tomorrow"]);
    XCTAssertTrue(item.shouldShowDirections);
}

- (void)testEventInToday {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitHour value:1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    XCTAssertTrue([item.time isEqualToString:@"Today"]);
    XCTAssertTrue(item.shouldShowDirections);
}

- (void)testEventInPastButStillInToday {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitHour value:-1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    XCTAssertTrue([item.time isEqualToString:@"Today"]);
    XCTAssertTrue(item.shouldShowDirections);
}

- (void)testEventInYesterday {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    XCTAssertTrue([item.time isEqualToString:@"Yesterday"]);
    XCTAssertEqual(item.shouldShowDirections, false);
}

- (void)testEventInLastMonth {
    NSDate *eventDate = [self dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:[NSDate new]];
    self.event.date = eventDate;
    FeedItem *item = [[FeedItem alloc] initWithEvent:self.event];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM d";
    NSString *expctedTime = [formatter stringFromDate:eventDate];
    
    XCTAssertTrue([item.time isEqualToString:expctedTime]);
    XCTAssertFalse(item.shouldShowDirections);
}

- (NSDate *)dateByAddingUnit:(NSCalendarUnit)calendarUnit value:(NSInteger)value toDate:(NSDate *)date {
    return [[NSCalendar currentCalendar] dateByAddingUnit:calendarUnit value:value toDate:date options:0];
}

@end
