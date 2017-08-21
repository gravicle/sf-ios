//
//  NotificationHandler.h
//  SF iOS
//
//  Created by Amit Jain on 8/20/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN
@interface NotificationHandler : NSObject

+ (NSDictionary<NSString *, id> *)userInfoDictionaryWithEvent:(Event *)event;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDatabase:(CKDatabase *)database;

- (void)registerForReceivingNotifications;
- (void)subscribeToEventNotifications;

typedef void(^NotificationHandlerCompletion)(NSError *_Nullable error);
- (void)processNotification:(NSDictionary *)notificationPayload withCompletionHandler:(NotificationHandlerCompletion)completionHandler;

@end
NS_ASSUME_NONNULL_END
