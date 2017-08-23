//
//  EventDataSOurce.m
//  SF iOS
//
//  Created by Amit Jain on 7/29/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventDataSource.h"
#import "Event.h"
#import "NSDate+Utilities.h"
#import "NSError+Constructor.h"
#import "EventFetcher.h"
#import "RemindersScheduler.h"

@interface EventDataSource ()

@property (nonatomic) CKDatabase *database;
@property (nonatomic, assign) EventType eventType;
@property (nonatomic) NSMutableArray<Event *> *events;

@end

@implementation EventDataSource

- (instancetype)initWithEventType:(EventType)eventType database:(CKDatabase *)database {
    if (self = [super init]) {
        self.eventType = eventType;
        self.database = database;
        self.events = [NSMutableArray new];
    }
    return self;
}

- (void)refresh {
    [self.updateStatusDelegate willUpdateDataSource:self];
    
    __weak typeof(self) welf = self;
    [EventFetcher
     fetchLatestEventsOfType:self.eventType
     fromDatabase:self.database
     withCompletionHandler:^(NSArray<Event *> * _Nullable events, NSError * _Nullable error) {
         [NSOperationQueue.mainQueue addOperationWithBlock:^{
             if (error) {
                 [welf.updateStatusDelegate didUpdateDataSource:welf withNewData:false error:error];
                 return;
             }
             
             BOOL didUpdateEvents = [welf reconcileNewEvents:events];
             [welf.updateStatusDelegate didUpdateDataSource:welf withNewData:didUpdateEvents error:nil];
             [welf scheduleRemindersForUpcomingEvents];
         }];
     }];
}

- (Event *)eventAtIndex:(NSUInteger)index {
    return self.events[index];
}

- (NSUInteger)numberOfEvents {
    return self.events.count;
}


- (NSUInteger)indexOfCurrentEvent {
    // index of the first future event
    for (Event *event in self.events.reverseObjectEnumerator) {
        // Basing on end-date allows ongoing event to show up first
        if (event.isActive) {
            return [self.events indexOfObjectIdenticalTo:event];
        }
    }
    
    return NSNotFound;
}

// MARK: - Bookeeping

- (BOOL)reconcileNewEvents:(NSArray<Event *> *)newEvents {
    BOOL updatedEvents = false;
    NSMutableArray *newUniqueEvents = [NSMutableArray new];
    for (Event *event in newEvents) {
        NSUInteger index = [self.events indexOfObject:event];
        if (index == NSNotFound) {
            [newUniqueEvents addObject:event];
        } else {
            Event *exsistingEvent = self.events[index];
            if ([event hasBeenModifiedSinceRecord:exsistingEvent]) {
                updatedEvents = true;
                [self.events replaceObjectAtIndex:index withObject:event];
            }
        }
    }
    
    if (newUniqueEvents.count > 0) {
        updatedEvents = true;
        [self.events addObjectsFromArray:newUniqueEvents];
    }
    
    if (updatedEvents) {
        [self.events sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [[(Event *)obj2 date] compare:[(Event *)obj1 date]];
        }];
    }
    
    return updatedEvents;
}

// MARK: - Reminders

- (void)scheduleRemindersForUpcomingEvents {
    for (Event *event in self.events) {
        if (event.date.isInThePast) {
            return;
        }
        
        [RemindersScheduler scheduleReminderForEvent:event withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error scheduling reminder for %@\n%@", event, error.localizedDescription);
            }
        }];
    }
}

@end
