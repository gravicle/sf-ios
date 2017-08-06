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
@property (nonatomic) TransportType transportType;
@property (nonatomic, copy) DirectionsRequestHandler directionsRequestHandler;

@end

@implementation TravelTimeView

- (instancetype)initWithTravelTime:(TravelTime *)travelTime directionsRequestHandler:(DirectionsRequestHandler)directionsRequestHandler {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setup];
        self.iconView.image = travelTime.icon;
        self.timeLabel.text = travelTime.travelTimeEstimateString;
        self.transportType = travelTime.transportType;
        self.directionsRequestHandler = directionsRequestHandler;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(false, @"Use initWithTravelTime:");
    return [self initWithTravelTime:[TravelTime new] directionsRequestHandler:^(TransportType transportType) {}];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"Use initWithTravelTime:");
    return [self initWithTravelTime:[TravelTime new] directionsRequestHandler:^(TransportType transportType) {}];
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

//MARK: - Touch Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setAsHighlighted:true];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setAsHighlighted:false];
    if (self.directionsRequestHandler) {
        self.directionsRequestHandler(self.transportType);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setAsHighlighted:false];
}

- (void)setAsHighlighted:(BOOL)highlighted {
    CGAffineTransform transform = highlighted ? CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2) : CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = transform;
    }];
}

@end
