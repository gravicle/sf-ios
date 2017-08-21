//
//  AppDelegate.m
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "AppDelegate.h"
#import "EventDataSource.h"
#import "EventsFeedViewController.h"
#import "NotificationHandler.h"
@import CloudKit;

NS_ASSUME_NONNULL_BEGIN
@interface AppDelegate ()

@property (nonatomic) EventDataSource *dataSource;
@property (nullable, nonatomic) NotificationHandler *notificationHandler;

@end
NS_ASSUME_NONNULL_END

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    self.notificationHandler = [[NotificationHandler alloc] init];
//    [self.notificationHandler registerForReceivingNotifications];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    self.dataSource = [[EventDataSource alloc] initWithEventType:EventTypeSFCoffee database:[[CKContainer defaultContainer] publicCloudDatabase]];
    EventsFeedViewController *feedController = [[EventsFeedViewController alloc] initWithDataSource:self.dataSource];
    
    self.window.rootViewController = feedController;
    
    return true;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self.notificationHandler subscribeToEventNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Application cannot receive remote notifications: %@", error);
    self.notificationHandler = nil;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self.notificationHandler processNotification:userInfo withCompletionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error processing remote notification: %@", error);
        }
        
        completionHandler(success ? UIBackgroundFetchResultNewData : UIBackgroundFetchResultFailed);
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.dataSource refresh];
}


@end
