//
//  NSNotification+ApplicationEventNotifications.m
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "NSNotification+ApplicationEventNotifications.h"
#import "UIApplication+Metadata.h"
@import UIKit;

@implementation NSNotification (ApplicationEventNotifications)

+ (NSNotificationName)applicationBecameActiveNotification {
    return [NSString stringWithFormat:@"%@.applicationBecameActiveNotification", [UIApplication sharedApplication].bundleIdentifier];
}

@end
