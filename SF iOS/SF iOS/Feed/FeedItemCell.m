//
//  FeedItemCell.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "FeedItemCell.h"
#import "UIStackView+ConvenienceInitializer.h"
#import "UIColor+SFiOSColors.h"

@interface FeedItemCell ()

@property (nonatomic) UIStackView *containerStack;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subtitleLabel;
@property (nonatomic) UIView *representationView;

@end

@implementation FeedItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithFeedItem:(FeedItem *)item {
    self.timeLabel.text = item.time;
    self.titleLabel.text = item.title;
    self.subtitleLabel.attributedText = [self subtitleAttributedStringFromString:item.subtitle];
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self setupContainerStack];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.timeLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.containerStack addArrangedSubview:self.timeLabel];
    
    [self setupDetailsStack];
}

- (void)setupContainerStack {
    self.containerStack = [[UIStackView alloc] initWithArrangedSubviews:nil
                                                                   axis:UILayoutConstraintAxisVertical
                                                           distribution:UIStackViewDistributionFill
                                                              alignment:UIStackViewAlignmentFill
                                                                spacing:13
                                                                margins:UIEdgeInsetsMake(0, 20, 40, 20)];
    [self.contentView addSubview:self.containerStack];
    [self.containerStack setTranslatesAutoresizingMaskIntoConstraints:false];
    [[self.containerStack.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor] setActive:true];
    [[self.containerStack.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor] setActive:true];
    [[self.containerStack.topAnchor constraintEqualToAnchor:self.contentView.topAnchor] setActive:true];
    [[self.containerStack.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor] setActive:true];
}

- (void)setupDetailsStack {
    CGFloat cornerRadius = 15;
    
    self.representationView = [UIView new];
    self.representationView.backgroundColor = [UIColor lightGrayColor];
    self.representationView.translatesAutoresizingMaskIntoConstraints = false;
    self.representationView.layer.cornerRadius = cornerRadius;
    self.representationView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.representationView.clipsToBounds = true;
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    self.subtitleLabel.textColor = [UIColor abbey];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    UIStackView *titleStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.subtitleLabel, self.titleLabel]
                                                                       axis:UILayoutConstraintAxisVertical
                                                               distribution:UIStackViewDistributionEqualSpacing
                                                                  alignment:UIStackViewAlignmentLeading
                                                                    spacing:6
                                                                    margins:UIEdgeInsetsMake(19, 19, 19, 19)];
    
    UIStackView *detailsStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.representationView, titleStack]
                                                                 axis:UILayoutConstraintAxisVertical
                                                         distribution:UIStackViewDistributionFill
                                                            alignment:UIStackViewAlignmentFill
                                                              spacing:0
                                                              margins:UIEdgeInsetsZero];
    detailsStack.translatesAutoresizingMaskIntoConstraints = false;
    
    UIView *detailsStackContainer = [UIView new];
    detailsStackContainer.backgroundColor = [UIColor whiteColor];
    detailsStackContainer.layer.cornerRadius = 15;
    detailsStackContainer.layer.shadowOpacity = 0.22;
    detailsStackContainer.layer.shadowRadius = 14;
    detailsStackContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    detailsStackContainer.layer.shadowOffset = CGSizeMake(0, 12);
    detailsStackContainer.clipsToBounds = false;
    detailsStackContainer.translatesAutoresizingMaskIntoConstraints = false;
    [detailsStackContainer addSubview:detailsStack];
    [detailsStack.leftAnchor constraintEqualToAnchor:detailsStackContainer.leftAnchor].active = true;
    [detailsStack.rightAnchor constraintEqualToAnchor:detailsStackContainer.rightAnchor].active = true;
    [detailsStack.topAnchor constraintEqualToAnchor:detailsStackContainer.topAnchor].active = true;
    [detailsStack.bottomAnchor constraintEqualToAnchor:detailsStackContainer.bottomAnchor].active = true;
    
    [self.containerStack addArrangedSubview:detailsStackContainer];
}

- (NSAttributedString *)subtitleAttributedStringFromString:(NSString *)string {
    NSDictionary<NSAttributedStringKey, id> *kerning = @{NSKernAttributeName : @(0.82)};
    return [[NSAttributedString alloc] initWithString:string attributes:kerning];
}

@end

