//
//  EventDataSourceTests.m
//  SF iOSTests
//
//  Created by Amit Jain on 7/30/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EventDataSource.h"
@import CloudKit;

@interface EventDataSourceTests : XCTestCase

@property (nonatomic) CKDatabase *database;

@end

@implementation EventDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.database = [CKContainer defaultContainer].publicCloudDatabase;
}


/**
 This test will start failing as soon as more events are added. Figure out a better way to test CloudKit!
 The limitation is that w/o mocking the only way to test is with live records in the dev enviornment.
 */
//- (void)testFetchingCoffeeEvents {
//    XCTestExpectation *exp = [self expectationWithDescription:@"Wait for events"];
//    
//    EventDataSource *dataSource = [[EventDataSource alloc] initWithEventType:EventTypeSFCoffee database:self.database];
//    [dataSource fetchPreviousEventsWithCompletionHandler:^(BOOL didUpdate, NSError * _Nullable error) {
//        if (error) {
//            XCTAssertFalse(didUpdate);
//            XCTFail(@"Error fetching events: %@", error);
//        } else {
//            XCTAssertTrue(didUpdate);
//            XCTAssertEqual(dataSource.numberOfEvents, 2);
//        }
//        
//        [exp fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:2.0 handler:nil];
//}

@end
