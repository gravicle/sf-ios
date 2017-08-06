//
//  MapView.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "MapView.h"
#import "MKMapCamera+OverlookingLocations.h"

static NSString * const destAnnotationIdentifier = @"destinationAnnotationidentifier";

@interface MapView ()

@property (nonatomic) MKMapView *mapView;
@property (nullable, nonatomic) MKPointAnnotation *destinationAnnotation;
@property (nullable, nonatomic) UIImage *annotationImage;
@property (nullable, nonatomic) CLLocation *destination;
@property (nullable, nonatomic) CLLocation *userLocation;

@end

@implementation MapView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        [self setup];
    }
    return self;
}

- (void)setDestinationToLocation:(CLLocation *)destination withAnnotationImage:(UIImage *)annotationImage {
    self.destination = destination;
    self.annotationImage = annotationImage;
    
    [self updateDestinationAnnotation];
}

- (void)setup {
    self.mapView = [MKMapView new];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeMutedStandard;
    self.mapView.showsTraffic = true;
    self.mapView.showsUserLocation = true;
    [self.mapView registerClass:[MKAnnotationView class] forAnnotationViewWithReuseIdentifier:destAnnotationIdentifier];
    
    self.mapView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.mapView];
    [self.mapView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = true;
    [self.mapView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = true;
    [self.mapView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [self.mapView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    
    [self setCameraOnSanFrancisco];
}

//MARK: - Annotations

- (void)updateDestinationAnnotation {
    [self.mapView removeAnnotation:self.destinationAnnotation];
    self.destinationAnnotation = [MKPointAnnotation new];
    self.destinationAnnotation.coordinate = self.destination.coordinate;
    [self.mapView addAnnotation:self.destinationAnnotation];
    
    [self setCameraOverlookingDestinationAndUserLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *dest = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:destAnnotationIdentifier forAnnotation:annotation];
    if (!dest) {
        dest = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:destAnnotationIdentifier];
        dest.canShowCallout = false;
    } else {
        dest.annotation = annotation;
    }
    dest.image = self.annotationImage;
    return dest;
}

//MARK: - UserLocation

- (void)setUserLocation:(CLLocation *)userLocation {
    if ([self location:userLocation isSameAsLocation:_userLocation]) {
        return;
    }
    
    _userLocation = userLocation;
    if (self.userLocationObserver) {
        self.userLocationObserver(userLocation);
    }
    
    if (!userLocation) {
        [self setCameraOnDestination];
    } else {
        [self setCameraOverlookingDestinationAndUserLocation];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.userLocation = userLocation.location;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"Failed to locate user in MapView: %@", error);
    self.userLocation = nil;
}

//MARK: - Camera

- (void)setCameraOverlookingDestinationAndUserLocation {
    if (!self.userLocation) {
        [self setCameraOnDestination];
        return;
    } else if (!self.destination) {
        return;
    }

    MKMapCamera *camera = [MKMapCamera cameraOverlookingLocation1:self.userLocation location2:self.destination];
    [self.mapView setCamera:camera animated:true];
}

- (void)setCameraOnDestination {
    if (!self.destination) {
        return;
    }
    
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:self.destination.coordinate fromDistance:6000 pitch:0 heading:0];
    [self.mapView setCamera:camera animated:true];
}

- (void)setCameraOnSanFrancisco {
    CLLocationCoordinate2D sanFrancisco = CLLocationCoordinate2DMake(37.749576, -122.442606);
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:sanFrancisco fromDistance:10000 pitch:0 heading:0];
    [self.mapView setCamera:camera animated:false];
}

//MARK: - Location Comparison

- (BOOL)location:(CLLocation *)lhs isSameAsLocation:(CLLocation *)rhs {
    return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude;
}

@end
