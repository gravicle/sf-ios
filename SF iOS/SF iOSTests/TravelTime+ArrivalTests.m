//
//  TravelTime+ArrivalTests.m
//  SF iOSTests
//
//  Created by Amit Jain on 8/8/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TravelTime+Arrival.h"

@interface TravelTime_ArrivalTests : XCTestCase

@property (nonatomic) TravelTime *traveltime;

@end

@implementation TravelTime_ArrivalTests

- (void)setUp {
    [super setUp];
    self.traveltime = [TravelTime new];
    self.traveltime.transportType = TransportTypeTransit;
    self.traveltime.travelTime = 1800; //30min
}

- (void)testArrivalWhenEventisInTheFuture {
    NSDate *startDate = [self dateWithHoursSinceNow:3];
    NSDate *endDate = [self dateWithHoursSinceNow:4];
    
    Arrival arrival = [self.traveltime arrivalToEventWithStartDate:startDate endDate:endDate];
    XCTAssertEqual(arrival, ArrivalOnTime);
}

- (void)testArrivalWhenArrivalDateIsDuringEvent {
    NSDate *startDate = [self dateWithHoursSinceNow:-1];
    NSDate *endDate = [self dateWithHoursSinceNow:1];
    
    Arrival arrival = [self.traveltime arrivalToEventWithStartDate:startDate endDate:endDate];
    XCTAssertEqual(arrival, ArrivalDuringEvent);
}

- (void)testArrivalWhenArrivalDateIsAfterEventEnd {
    NSDate *startDate = [self dateWithHoursSinceNow:-1];
    NSDate *endDate = [self dateWithHoursSinceNow:0.25];
    
    Arrival arrival = [self.traveltime arrivalToEventWithStartDate:startDate endDate:endDate];
    XCTAssertEqual(arrival, ArrivalAfterEvent);
}

- (NSDate *)dateWithHoursSinceNow:(double)numberOfHours {
    return [NSDate dateWithTimeIntervalSinceNow:[self timeIntervalForHours:numberOfHours]];
}

- (NSTimeInterval)timeIntervalForHours:(double)numberOfHours {
    return 3600 * numberOfHours;
}

@end
