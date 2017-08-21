//
//  RemindersScheduler.h
//  SF iOS
//
//  Created by Amit Jain on 8/20/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface RemindersScheduler : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (void)scheduleReminderForEvent:(Event *)event;

@end
