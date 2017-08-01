//
//  MapView.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "MapView.h"
@import MapKit;

@interface MapView ()

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) MKPointAnnotation *destinationAnnotation;

@end

@implementation MapView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setDestinationToLocation:(CLLocation *)destination {
    self.destinationAnnotation.coordinate = destination.coordinate;
}

- (void)setShowsUserLocation:(BOOL)showsUserLocation {
    self.mapView.showsUserLocation = showsUserLocation;
}

- (void)setup {
    self.mapView = [MKMapView new];
    self.mapView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.mapView];
    [self.mapView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
    [self.mapView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
    [self.mapView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    
    self.destinationAnnotation = [MKPointAnnotation new];
    [self.mapView addAnnotation:self.destinationAnnotation];
}

@end
