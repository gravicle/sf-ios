//
//  MapSnapshotter.m
//  SF iOS
//
//  Created by Amit Jain on 8/1/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "MapSnapshotter.h"
#import "MKMapCamera+OverlookingLocations.h"
@import MapKit;

@interface MapSnapshotter ()

@property (nullable, nonatomic) UserLocation *locationService;

@end

@implementation MapSnapshotter

- (instancetype)initWithUserLocationService:(UserLocation *)userLocationService {
    if (self = [super init]) {
        self.locationService = userLocationService;
    }
    return self;
}

- (void)snapshotOfsize:(CGSize)size showingDestinationLocation:(CLLocation *)location annotationImage:(UIImage *)annotationImage withCompletionHandler:(MapSnapshotCompletionHandler)completionHandler {
    MKMapSnapshotOptions *options = [MKMapSnapshotOptions new];
    if (@available(iOS 11.0, *)) {
        options.mapType = MKMapTypeMutedStandard;
    } else {
        options.mapType = MKMapTypeStandard;
    }
    options.scale = UIScreen.mainScreen.scale;
    options.size = size;
    options.showsPointsOfInterest = false;
    options.region = [self mapRegionCenteredAroundLocation:location];
    
    if (self.locationService.canRequestUserLocation) {
        __weak typeof(self) welf = self;
        [self.locationService requestWithCompletionHandler:^(CLLocation * _Nullable currentLocation, NSError * _Nullable error) {
            if (!currentLocation) {
                NSLog(@"User location could not be determined: %@", error);
                [welf takeSnapshotWithOptions:options sourceLocation:nil destinationLocation:location destinationAnnotationImage:annotationImage completionHandler:completionHandler];
                return;
            }
            
            options.camera = [MKMapCamera cameraOverlookingLocation1:currentLocation location2:location withPadding:0.3];
            [welf takeSnapshotWithOptions:options sourceLocation:currentLocation destinationLocation:location destinationAnnotationImage:annotationImage completionHandler:completionHandler];
        }];
    } else {
        [self takeSnapshotWithOptions:options sourceLocation:nil destinationLocation:location destinationAnnotationImage:annotationImage completionHandler:completionHandler];
    }
}

- (void)takeSnapshotWithOptions:(MKMapSnapshotOptions *)options
                 sourceLocation:(nullable CLLocation *)sourceLocation
            destinationLocation:(nonnull CLLocation *)destinationLocation
     destinationAnnotationImage:(nonnull UIImage *)destinationAnnotationImage
              completionHandler:(MapSnapshotCompletionHandler)completionHandler {
    MKMapSnapshotter *snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    __weak typeof(self) welf = self;
    [snapShotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completionHandler(nil, error);
                return;
            }
            
            UIImage *renderedImage = [welf imageFromRenderingSourceLocation:sourceLocation
                                                        destinationLocation:destinationLocation
                                                 destinationAnnotationImage:destinationAnnotationImage
                                                                 onSnapshot:snapshot];
            completionHandler(renderedImage, nil);
        });
    }];
}

//MARK: - Map Rendering

- (MKCoordinateRegion)mapRegionCenteredAroundLocation:(nonnull CLLocation *)location {
    return MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.2, 0.2));
}

- (nonnull UIImage *)imageFromRenderingSourceLocation:(nullable CLLocation *)sourceLocation destinationLocation:(nonnull CLLocation *)destinationLocation destinationAnnotationImage:(UIImage *)destinationAnnotationImage onSnapshot:(MKMapSnapshot *)snapshot {
    UIImage *image = snapshot.image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
    [image drawAtPoint:CGPointZero]; // draw map
    
    [self addAnnotationWithImage:destinationAnnotationImage toSnapshot:snapshot atLocation:destinationLocation];
    if (sourceLocation) {
        [self addAnnotationWithImage:[UIImage imageNamed:@"user-location-icon"] toSnapshot:snapshot atLocation:sourceLocation];
    }
    
    UIImage *annotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return annotatedImage;
}

// https://stackoverflow.com/a/42773351/2671390
- (void)addAnnotationWithImage:(nullable UIImage *)image toSnapshot:(nonnull MKMapSnapshot *)snapshot atLocation:(nonnull CLLocation *)location {
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    annotationView.image = image;
    
    CGPoint annotationPosition = [snapshot pointForCoordinate:coordinate];
    CGPoint pinCenterOffset = annotationView.centerOffset;
    annotationPosition.x -= annotationView.bounds.size.width / 2;
    annotationPosition.y -= annotationView.bounds.size.height / 2;
    annotationPosition.x += pinCenterOffset.x;
    annotationPosition.y += pinCenterOffset.y;
    [annotationView.image drawAtPoint:annotationPosition];
}

@end

