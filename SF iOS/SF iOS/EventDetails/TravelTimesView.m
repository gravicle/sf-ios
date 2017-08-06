//
//  TravelTimesView.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimesView.h"
#import "TravelTimeView.h"
#import "UIStackView+ConvenienceInitializer.h"

typedef NS_ENUM(NSUInteger, TravelTimeType) {
    TravelTimeTypeRegular = 0,
    TravelTimeTypeRideSharing = 1
};

@interface TravelTimesView ()

@property (nonatomic) UIStackView *regularStack;
@property (nonatomic) UIStackView *ridesharingStack;
@property (nonatomic) UIActivityIndicatorView *loadingIndicator;

@end

@implementation TravelTimesView

- (instancetype)init {
    self = [super initWithArrangedSubviews:@[]
                                      axis:UILayoutConstraintAxisVertical
                              distribution:UIStackViewDistributionEqualSpacing
                                 alignment:UIStackViewAlignmentLeading
                                   spacing:16
                                   margins:UIEdgeInsetsZero];
    if (!self) {
        return nil;
    }
    
    [self setup];
    return self;
}

- (void)configureWithTravelTimes:(NSArray<TravelTime *> *)travelTimes {
    [self.loadingIndicator stopAnimating];
    
    [self.regularStack removeAllArrangedSubviews];
    [self.ridesharingStack removeAllArrangedSubviews];
    
    NSDictionary *categorizedTravelTimes = [self categorizedTravelTimesFromArray:travelTimes];
    NSArray *regularTimes = categorizedTravelTimes[@(TravelTimeTypeRegular)];
    if (regularTimes) {
        [self populateTravelTimeViewsInStack:self.regularStack withTimes:regularTimes];
    }
    
    NSArray *rideSharingTimes = categorizedTravelTimes[@(TravelTimeTypeRideSharing)];
    if (rideSharingTimes) {
        [self populateTravelTimeViewsInStack:self.ridesharingStack withTimes:rideSharingTimes];
    }
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = false;
    
    self.regularStack = [self timesStackView];
    [self addArrangedSubview:self.regularStack];
    self.ridesharingStack = [self timesStackView];
    [self addArrangedSubview:self.ridesharingStack];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.hidesWhenStopped = true;
    self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.loadingIndicator];
    [self.loadingIndicator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
    [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
    
    [self.loadingIndicator startAnimating];
}

- (void)populateTravelTimeViewsInStack:(nonnull UIStackView *)stack withTimes:(nonnull NSArray *)travelTimes {
    for (TravelTime *time in travelTimes) {
        TravelTimeView *view = [[TravelTimeView alloc] initWithTravelTime:time];
        [stack addArrangedSubview:view];
    }
}

- (UIStackView *)timesStackView {
    return [[UIStackView alloc] initWithArrangedSubviews:@[] axis:UILayoutConstraintAxisHorizontal
                                            distribution:UIStackViewDistributionEqualSpacing
                                               alignment:UIStackViewAlignmentLeading
                                                 spacing:16
                                                 margins:UIEdgeInsetsZero];
}

// MARK: - Travel Time Categorization

- (NSDictionary *)categorizedTravelTimesFromArray:(NSArray<TravelTime *> *)array {
    NSMutableArray *regular = [NSMutableArray new];
    NSMutableArray *ridesharing = [NSMutableArray new];
    
    for (TravelTime *time in array) {
        switch (time.transportType) {
            case TransportTypeUber:
                [ridesharing addObject: time];
                break;
            case TransportTypeLyft:
                [ridesharing addObject: time];
                break;
            case TransportTypeWalking:
                [regular addObject: time];
                break;
            case TransportTypeAutomobile:
                [regular addObject: time];
                break;
            case TransportTypeTransit:
                [regular addObject: time];
                break;
            default:
                break;
        }
    }
    
    return @{@(TravelTimeTypeRegular) : regular, @(TravelTimeTypeRideSharing) : ridesharing};
}

@end
