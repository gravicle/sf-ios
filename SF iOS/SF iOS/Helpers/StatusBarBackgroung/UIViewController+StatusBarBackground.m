//
//  UIViewController+StatusBarBackground.m
//  SF iOS
//
//  Created by Amit Jain on 8/8/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "UIViewController+StatusBarBackground.h"

@implementation UIViewController (StatusBarBackground)

- (void)addStatusBarBlurBackground {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *statusBarBackground = [[UIVisualEffectView alloc] initWithEffect:effect];
    statusBarBackground.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:statusBarBackground];
    [statusBarBackground.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [statusBarBackground.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [statusBarBackground.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    [statusBarBackground.heightAnchor constraintEqualToConstant:20].active = true;
}

@end
