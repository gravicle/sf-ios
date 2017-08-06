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
#import "UIImage+URL.h"
#import "NSAttributedString+EventAddress.h"

NS_ASSUME_NONNULL_BEGIN
@interface FeedItemCell ()

@property (nonatomic) UIStackView *containerStack;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subtitleLabel;
@property (nonatomic) UIStackView *itemImageStack;
@property (nonatomic) UIImageView *coverImageView;

typedef void(^MapSnapshotTask)(void);
@property (nullable, nonatomic) MapSnapshotTask takeMapSnapshot;
@property (nullable, weak, nonatomic) NSURLSessionDataTask *imageDownloadTask;

@end
NS_ASSUME_NONNULL_END

@implementation FeedItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

//MARK: - Configuration

- (void)configureWithFeedItem:(FeedItem *)item snapshotter:(MapSnapshotter *)snapshotter {
    self.timeLabel.text = item.dateString;
    self.titleLabel.text = item.title;
    self.subtitleLabel.attributedText = [NSAttributedString kernedStringFromString:item.subtitle];
    if (item.shouldShowDirections) {
        __weak typeof(self) welf = self;
        self.takeMapSnapshot = ^{
            [welf showMapForLocation:item.location annotionImage:item.annotationImage usingSnapshotter:snapshotter withCompletionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error displaying map: %@", error);
                    [welf showImageWithFileURL:item.coverImageFileURL];
                }
            }];
        };
    } else {
        [self showImageWithFileURL:item.coverImageFileURL];
    }
}

- (void)layoutMap {
    if (self.takeMapSnapshot) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        self.takeMapSnapshot();
        self.takeMapSnapshot = nil;
    }
}

- (void)prepareForReuse {
    self.takeMapSnapshot = nil;
    
    [self.imageDownloadTask cancel];
    self.imageDownloadTask = nil;
    self.imageView.image = nil;
    
    [super prepareForReuse];
}

static CGFloat const cornerRadius = 15;

- (void)layoutSubviews {
    [super layoutSubviews];
    if (@available(iOS 11, *)) {}
    else {
        [self roundCoverImageCorners];
    }
}

- (void)showMapForLocation:(nonnull CLLocation *)location annotionImage:(UIImage *)annotationImage usingSnapshotter:(MapSnapshotter *)snapshotter withCompletionHandler:(void(^)(NSError * _Nullable error))completionHandler {
    __weak typeof(self) welf = self;
    [snapshotter snapshotOfsize:welf.itemImageStack.bounds.size showingDestinationLocation:location annotationImage:annotationImage withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error) {
                 completionHandler(error);
                 return;
             }
             [welf setCoverImageToImage:image];
             completionHandler(nil);
         });
    }];
}

- (void)showImageWithFileURL:(NSURL *)url {
    __weak typeof(self) welf = self;
    [UIImage imageFromFileURL:url withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
        [welf setCoverImageToImage:image];
    }];
}

- (void)setCoverImageToImage:(nullable UIImage *)image {
    [UIView transitionWithView:self.coverImageView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.coverImageView.image = image;
                        [self roundCoverImageCorners];
                    }
                    completion:nil];
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
    self.coverImageView = [UIImageView new];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.backgroundColor = [UIColor alabaster];
    
    if (@available(iOS 11.0, *)) {
        self.coverImageView.layer.cornerRadius = cornerRadius;
        self.coverImageView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    
    self.coverImageView.clipsToBounds = true;
    self.coverImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.coverImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    self.itemImageStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.coverImageView]
                                                                   axis:UILayoutConstraintAxisVertical
                                                           distribution:UIStackViewDistributionFill
                                                              alignment:UIStackViewAlignmentFill
                                                                spacing:0
                                                                margins:UIEdgeInsetsZero];
    self.itemImageStack.translatesAutoresizingMaskIntoConstraints = false;
    
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
    [titleStack setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    UIStackView *detailsStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.itemImageStack, titleStack]
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

-
(void)roundCoverImageCorners {
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:self.coverImageView.bounds
                                                      byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                            cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.bounds = self.coverImageView.bounds;
    maskLayer.path = [roundedPath CGPath];
    self.coverImageView.layer.mask = maskLayer;
}

@end

