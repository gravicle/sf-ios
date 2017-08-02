//
//  MapSnapshotter.m
//  SF iOS
//
//  Created by Amit Jain on 8/1/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "MapSnapshotter.h"
@import MapKit;

@interface MapSnapshotter ()

@property (nullable, nonatomic) UserLocation *locationService;
@property (nonnull, nonatomic) dispatch_queue_t snapshotQueue;

@end

@implementation MapSnapshotter

- (instancetype)initWithUserLocationService:(UserLocation *)userLocationService {
    if (self = [super init]) {
        self.locationService = userLocationService;
        // High priority as snapshots are needed for UI rendering.
        self.snapshotQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    }
    return self;
}

- (void)snapshotOfsize:(CGSize)size showingDestinationLocation:(CLLocation *)location withCompletionHandler:(MapSnapshotCompletionHandler)completionHandler {
    MKMapSnapshotOptions *options = [MKMapSnapshotOptions new];
    options.mapType = MKMapTypeMutedStandard;
    options.scale = UIScreen.mainScreen.scale;
    options.size = size;
    options.showsPointsOfInterest = false;
    options.region = [self mapRegionCenteredAroundLocation:location];
    
    if (self.locationService.canRequestUserLocation) {
        __weak typeof(self) welf = self;
        [self.locationService requestWithCompletionHandler:^(CLLocation * _Nullable currentLocation, NSError * _Nullable error) {
            if (!currentLocation) {
                NSLog(@"User location could not be determined: %@", error);
                [welf takeSnapshotWithOptions:options sourceLocation:nil destinationLocation:location completionHandler:completionHandler];
                return;
            }
            
            options.camera = [welf cameraFromSourceLocation:currentLocation destinationLocation:location canvasSize:size];
            [welf takeSnapshotWithOptions:options sourceLocation:currentLocation destinationLocation:location completionHandler:completionHandler];
        }];
    } else {
        [self takeSnapshotWithOptions:options sourceLocation:nil destinationLocation:location completionHandler:completionHandler];
    }
}

- (void)takeSnapshotWithOptions:(MKMapSnapshotOptions *)options
                 sourceLocation:(nullable CLLocation *)sourceLocation
            destinationLocation:(nonnull CLLocation *)destinationLocation
              completionHandler:(MapSnapshotCompletionHandler)completionHandler {
    MKMapSnapshotter *snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    __weak typeof(self) welf = self;
    [snapShotter startWithQueue:self.snapshotQueue completionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completionHandler(nil, error);
                return;
            }
            
            UIImage *renderedImage = [welf imageFromRenderingSourceLocation:sourceLocation destinationLocation:destinationLocation onSnapshot:snapshot];
            completionHandler(renderedImage, nil);
        });
    }];
}

//MARK: - Map Rendering

- (MKCoordinateRegion)mapRegionCenteredAroundLocation:(nonnull CLLocation *)location {
    return MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.2, 0.2));
}

// https://stackoverflow.com/a/21034410/2671390
static double const mapApertureInRadians = (30 * M_PI) / 180;

- (MKMapCamera *)cameraFromSourceLocation:(CLLocation *)sourceLocation destinationLocation:(CLLocation *)destinationLocation canvasSize:(CGSize)canvasSize {
    CLLocationCoordinate2D sourceCoordinate = sourceLocation.coordinate;
    CLLocationCoordinate2D destCoordinate = destinationLocation.coordinate;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((sourceCoordinate.latitude + destCoordinate.latitude) / 2, (sourceCoordinate.longitude + destCoordinate.longitude) / 2);
    
    double span = [sourceLocation distanceFromLocation:destinationLocation] / 2;
    double altitude = span / tan(mapApertureInRadians / 2);
    double altitudeAdjustedForPadding = altitude + (altitude * 0.15);
    
    return [MKMapCamera cameraLookingAtCenterCoordinate:centerCoordinate fromDistance:altitudeAdjustedForPadding pitch:0 heading:0];
}

- (nonnull UIImage *)imageFromRenderingSourceLocation:(nullable CLLocation *)sourceLocation destinationLocation:(nonnull CLLocation *)destinationLocation onSnapshot:(MKMapSnapshot *)snapshot {
    UIImage *image = snapshot.image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
    [image drawAtPoint:CGPointZero]; // draw map
    
    [self addAnnotationWithImage:[UIImage imageNamed:@"coffee-location-icon"] toSnapshot:snapshot atLocation:destinationLocation];
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

