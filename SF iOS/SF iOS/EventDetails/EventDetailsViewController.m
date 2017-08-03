
//
//  EventDetailsViewController.m
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "UIStackView+ConvenienceInitializer.h"
#import "UIColor+SFiOSColors.h"
#import "NSAttributedString+EventAddress.h"
#import "NSDate+Utilities.h"
#import "MapView.h"
#import "TravelTimeService.h"
@import MapKit;

NS_ASSUME_NONNULL_BEGIN
@interface EventDetailsViewController ()

@property (nonatomic) Event *event;
@property (nonatomic) MapView *mapView;
@property (nonatomic) UIStackView *containerStack;
@property (nonatomic) TravelTimeService *travelTimeService;

@end
NS_ASSUME_NONNULL_END

@implementation EventDetailsViewController

- (instancetype)initWithEvent:(Event *)event {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.event = event;
        self.travelTimeService = [TravelTimeService new];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"Use -initWithEvent");
    return [self initWithEvent:[Event new]];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(false, @"Use -initWithEvent");
    return [self initWithEvent:[Event new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = true;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = self.event.location.name;
    nameLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    nameLabel.textColor = [UIColor blackColor];
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    addressLabel.textColor = [UIColor abbey];
    addressLabel.attributedText = [NSAttributedString eventAddressAttributedStringFromAddress:self.event.location.streetAddress];
    
    UIStackView *titleStack = [[UIStackView alloc] initWithArrangedSubviews:@[nameLabel, addressLabel]
                                                                       axis:UILayoutConstraintAxisVertical
                                                               distribution:UIStackViewDistributionEqualSpacing
                                                                  alignment:UIStackViewAlignmentFill
                                                                    spacing:9
                                                                    margins:UIEdgeInsetsZero];
    NSMutableArray *detailViews = [NSMutableArray arrayWithObject:titleStack];
    UILabel *timeRemainingLabel = nil;
    if (self.event.date.isInFuture && self.event.date.isToday) {
        timeRemainingLabel = [UILabel new];
        timeRemainingLabel.text = self.event.date.abbreviatedDurationFromNow;
        timeRemainingLabel.font = [UIFont systemFontOfSize:13];
        timeRemainingLabel.textColor = [UIColor abbey];
        [detailViews addObject:timeRemainingLabel];
    }
    
    UIStackView *detailsStack = [[UIStackView alloc] initWithArrangedSubviews:detailViews
                                                                         axis:UILayoutConstraintAxisVertical
                                                                 distribution:UIStackViewDistributionEqualSpacing
                                                                    alignment:UIStackViewAlignmentFill
                                                                      spacing:12
                                                                      margins:UIEdgeInsetsMake(18, 21, 32, 21)];
    [detailsStack setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    self.mapView = [MapView new];
    [self.mapView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    __weak typeof(self) welf = self;
    self.mapView.userLocationObserver = ^(CLLocation * _Nullable userLocation) {
        [welf updateTravelTimesWithUserLocation:userLocation];
    };
    
    self.containerStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.mapView, detailsStack]
                                                                   axis:UILayoutConstraintAxisVertical
                                                           distribution:UIStackViewDistributionFill
                                                              alignment:UIStackViewAlignmentFill
                                                                spacing:0
                                                                margins:UIEdgeInsetsZero];
    self.containerStack.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:self.containerStack];
    // Extend under status bar
    [self.containerStack.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:-self.statusBarHeight].active = true;
    [self.containerStack.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [self.containerStack.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [self.containerStack.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    
    UIButton *closeButton = [UIButton new];
    [closeButton setImage:[UIImage imageNamed:@"close-button"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    closeButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:closeButton];
    [closeButton.widthAnchor constraintEqualToConstant:28].active = true;
    [closeButton.heightAnchor constraintEqualToConstant:28].active = true;
    [closeButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:40].active = true;
    [closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20].active = true;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *statusBarBackground = [[UIVisualEffectView alloc] initWithEffect:effect];
    statusBarBackground.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:statusBarBackground];
    [statusBarBackground.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [statusBarBackground.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [statusBarBackground.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    [statusBarBackground.heightAnchor constraintEqualToConstant:self.statusBarHeight].active = true;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mapView setDestinationToLocation:self.event.location.location withAnnotationImage:self.event.annotationImage];
}

// MARK: - Travel Times

- (void)updateTravelTimesWithUserLocation:(nullable CLLocation *)userLocation {
    if (!userLocation) {
        return;
    }
    
    [self.travelTimeService calculateTravelTimesFromLocation:userLocation toLocation:self.event.location.location withCompletionHandler:^(NSArray<TravelTime *> * _Nonnull travelTimes) {
        
    }];
}

// ---

- (void)dismiss {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}



@end
