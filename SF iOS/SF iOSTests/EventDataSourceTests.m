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

@property (nonatomic) EventDataSource *dataSource;
@property (nonatomic) CKDatabase *database;

@end

@implementation EventDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.database = [CKContainer defaultContainer].publicCloudDatabase;
    self.dataSource = [[EventDataSource alloc] initWithDatabase:self.database];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/**
 This test will start failing as soon as more events are added. Figure out a better way to test CloudKit!
 */
- (void)testFetchingEvents {
    XCTestExpectation *exp = [self expectationWithDescription:@"Wait for events"];
    
    [self.dataSource fetchPreviousEventsWithCompletionHander:^(NSArray<Event *> * _Nullable events, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Error fetching events: %@", error);
        } else {
            XCTAssertEqual(events.count, 2);
        }
        
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

@end
