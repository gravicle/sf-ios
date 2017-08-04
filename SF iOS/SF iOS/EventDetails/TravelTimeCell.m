//
//  TravelTimeCell.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimeCell.h"
#import "UIColor+SFiOSColors.h"
#import "UIStackView+ConvenienceInitializer.h"

@interface TravelTimeCell ()

@property (nonatomic) UIImageView *iconView;
@property (nonatomic) UILabel *timeLabel;

@end

@implementation TravelTimeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)configureWithTravelTime:(TravelTime *)travelTime {
    self.iconView.image = travelTime.icon;
    self.timeLabel.text = travelTime.travelTimeEstimateString;
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
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
    [self.contentView addSubview:backgroundView];
    self.contentView.clipsToBounds = false;
    [backgroundView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = true;
    [backgroundView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = true;
    [backgroundView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = true;
    [backgroundView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = true;
    
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
    [self.contentView addSubview:contentStack];
    [contentStack.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = true;
    [contentStack.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = true;
    [contentStack.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = true;
    [contentStack.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = true;
    [contentStack.heightAnchor constraintEqualToConstant:36].active = true;
}

@end
