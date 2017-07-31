//
//  EventsFeedViewController.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventsFeedViewController : UIViewController

- (instancetype)initWithEventType:(EventType)eventType NS_DESIGNATED_INITIALIZER;

@end
