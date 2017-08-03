//
//  NSNotification+ApplicationEventNotifications.h
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSNotification (ApplicationEventNotifications)

@property (class, nonatomic, readonly) NSNotificationName applicationBecameActiveNotification;

@end
NS_ASSUME_NONNULL_END
