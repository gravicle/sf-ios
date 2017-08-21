//
//  RemindersScheduler.h
//  SF iOS
//
//  Created by Amit Jain on 8/20/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN
@interface RemindersScheduler : NSObject

- (instancetype)init NS_UNAVAILABLE;

typedef void(^RemindersSchedulerCompletionHandler)(NSError *_Nullable error);
+ (void)scheduleReminderForEvent:(Event *)event withCompletionHandler:(RemindersSchedulerCompletionHandler)completionHandler;

@end
NS_ASSUME_NONNULL_END
