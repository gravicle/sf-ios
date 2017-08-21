//
//  NotificationHandler.h
//  SF iOS
//
//  Created by Amit Jain on 8/20/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NotificationHandler : NSObject

- (void)registerForReceivingNotifications;
- (void)subscribeToEventNotifications;

typedef void(^NotificationHandlerCompletion)(BOOL success, NSError *_Nullable error);
- (void)processNotification:(NSDictionary *)notificationPayload withCompletionHandler:(NotificationHandlerCompletion)completionHandler;

@end
NS_ASSUME_NONNULL_END
