//
//  TravelTimeView.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimeView.h"
#import "UIColor+SFiOSColors.h"
#import "UIStackView+ConvenienceInitializer.h"

@interface TravelTimeView ()

@property (nonatomic) UIImageView *iconView;
@property (nonatomic) UILabel *timeLabel;

@end

@implementation TravelTimeView

- (instancetype)initWithTravelTime:(TravelTime *)travelTime {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setup];
        self.iconView.image = travelTime.icon;
        self.timeLabel.text = travelTime.travelTimeEstimateString;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(false, @"Use initWithTravelTime:");
    return [self initWithTravelTime:[TravelTime new]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"Use initWithTravelTime:");
    return [self initWithTravelTime:[TravelTime new]];
}

- (void)setup {
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.clipsToBounds = false;
    backgroundView.layer.cornerRadius = 8;
    backgroundView.layer.shadowColor = [UIColor nobel].CGColor;
    backgroundView.layer.shadowOpacity = 0.5;
    backgroundView.layer.shadowOffset = CGSizeMake(0, 2);
    backgroundView.layer.shadowRadius = 10;
    backgroundView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:backgroundView];
    self.clipsToBounds = false;
    [backgroundView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
    [backgroundView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
    [backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.timeLabel.textColor = [UIColor atlantis];
    self.timeLabel.numberOfLines = 1;
    
    self.iconView = [UIImageView new];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.iconView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    UIStackView *contentStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.iconView, self.timeLabel]
                                                                         axis:UILayoutConstraintAxisHorizontal
                                                                 distribution:UIStackViewDistributionFill
                                                                    alignment:UIStackViewAlignmentFill
                                                                      spacing:10
                                                                      margins:UIEdgeInsetsMake(10, 10, 10, 10)];
    contentStack.translatesAutoresizingMaskIntoConstraints = false;
    [contentStack setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:contentStack];
    [contentStack.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
    [contentStack.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
    [contentStack.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [contentStack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    [contentStack.heightAnchor constraintEqualToConstant:36].active = true;
}

@end
