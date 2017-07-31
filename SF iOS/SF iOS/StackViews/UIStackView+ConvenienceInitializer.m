//
//  UIStackView+ConvenienceInitializer.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "UIStackView+ConvenienceInitializer.h"

@implementation UIStackView (ConvenienceInitializer)

- (instancetype)initWithArrangedSubviews:(NSArray<__kindof UIView *> *)views
                                    axis:(UILayoutConstraintAxis)axis
                            distribution:(UIStackViewDistribution)distribution
                               alignment:(UIStackViewAlignment)alignment
                                 spacing:(CGFloat)spacing
                                 margins:(UIEdgeInsets)margins {
    self = [self initWithArrangedSubviews:views ? views : [NSArray new]];
    if (!self) {
        return nil;
    }
    
    self.axis = axis;
    self.distribution = distribution;
    self.alignment = alignment;
    self.spacing = spacing;
    self.layoutMargins = margins;
    
    return self;
}

@end
