//
//  UIStackView+ConvenienceInitializer.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIStackView (ConvenienceInitializer)

- (nonnull instancetype)initWithArrangedSubviews:(nullable NSArray<__kindof UIView *> *)views
                                            axis:(UILayoutConstraintAxis)axis
                                    distribution:(UIStackViewDistribution)distribution
                                       alignment:(UIStackViewAlignment)alignment
                                         spacing:(CGFloat)spacing
                                         margins:(UIEdgeInsets)margins;

- (void)removeAllArrangedSubviews;

@end
NS_ASSUME_NONNULL_END
