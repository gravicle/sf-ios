
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
#import "TravelTimesView.h"
@import MapKit;

NS_ASSUME_NONNULL_BEGIN
@interface EventDetailsViewController ()

@property (nonatomic) Event *event;
@property (nonatomic) MapView *mapView;
@property (nonatomic) UIStackView *containerStack;
@property (nonatomic) TravelTimeService *travelTimeService;
@property (nonatomic) TravelTimesView *travelTimesView;
@property (nonatomic) NSLayoutConstraint *travelTimesViewHeightConstraint;

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
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.event.location.name;
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor blackColor];
    
    UILabel *subtitleLabel = [UILabel new];
    subtitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    subtitleLabel.textColor = [UIColor abbey];
    NSString *timeLabelText;
    if (self.event.date.isInFuture && self.event.date.isToday) {
        timeLabelText = self.event.date.abbreviatedTimeintervalFromNow;
    } else {
        timeLabelText = [NSDate timeslotStringFromStartDate:self.event.date duration:self.event.duration];
    }
    NSString *subtitle = [@[self.event.location.streetAddress, timeLabelText] componentsJoinedByString:@", "];
    subtitleLabel.attributedText = [NSAttributedString kernedStringFromString:subtitle];
    
    UIStackView *titleStack = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, subtitleLabel]
                                                                       axis:UILayoutConstraintAxisVertical
                                                               distribution:UIStackViewDistributionEqualSpacing
                                                                  alignment:UIStackViewAlignmentFill
                                                                    spacing:9
                                                                    margins:UIEdgeInsetsMake(18, 21, 0, 21)];
    [titleStack setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    self.mapView = [MapView new];
    [self.mapView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    __weak typeof(self) welf = self;
    self.mapView.userLocationObserver = ^(CLLocation * _Nullable userLocation) {
        [welf updateTravelTimesWithUserLocation:userLocation];
    };
    
    self.travelTimesView = [TravelTimesView new];
    self.travelTimesViewHeightConstraint = [self.travelTimesView.heightAnchor constraintEqualToConstant:0];
    self.travelTimesViewHeightConstraint.active = true;
    UIStackView *travelTimeStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.travelTimesView]
                                                                            axis:UILayoutConstraintAxisVertical
                                                                    distribution:UIStackViewDistributionFill
                                                                       alignment:UIStackViewAlignmentFill
                                                                         spacing:0
                                                                         margins:UIEdgeInsetsMake(32, 21, 21, 21)];
    
    self.containerStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.mapView, titleStack, travelTimeStack]
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
    
    __weak typeof(self) welf = self;
    [self.travelTimeService calculateTravelTimesFromLocation:userLocation toLocation:self.event.location.location withCompletionHandler:^(NSArray<TravelTime *> * _Nonnull travelTimes) {
        if (travelTimes.count > 0) {
            [welf.travelTimesView showTravelTimes:travelTimes];
            [welf showTravelTimesView];
        }
    }];
}

// ---

- (void)showTravelTimesView {
    self.travelTimesViewHeightConstraint.constant = 36;
    [UIView animateWithDuration:0.3 animations:^{
        [self.containerStack layoutIfNeeded];
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}



@end
