//
//  EventDetailsViewController.h
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "UserLocation.h"

NS_ASSUME_NONNULL_BEGIN
@interface EventDetailsViewController : UIViewController

- (instancetype)initWithEvent:(Event *)event NS_DESIGNATED_INITIALIZER;

@end
NS_ASSUME_NONNULL_END
