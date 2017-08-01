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

@property (nullable, nonatomic) CLLocationManager *locationManager;
@property (nonnull, nonatomic) dispatch_queue_t snapshotQueue;

@end

@implementation MapSnapshotter

- (instancetype)init {
    if (self = [super init]) {
        [self setupLocationManager];
        
        // High priority as snapshots are needed for UI rendering.
        self.snapshotQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    }
    return self;
}

- (void)snapshotWithDestinationLocation:(CLLocation *)location completionHandler:(void (^)(UIImage * _Nullable, NSError * _Nullable))completionHandler {
    MKMapSnapshotOptions *options = [MKMapSnapshotOptions new];
    options.mapType = MKMapTypeStandard;
    options.region = [self mapRegionCenteredAroundLocation:location];
    
    MKMapSnapshotter *snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    __weak typeof(self) welf = self;
    [snapShotter startWithQueue:self.snapshotQueue completionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }
        
        UIImage *renderedImage = [welf imageFromRenderingSourceLocation:nil destinationLocation:location onSnapshot:snapshot];
        completionHandler(renderedImage, nil);
    }];
}

- (void)setupLocationManager {
    BOOL locationServicesEnabled = [CLLocationManager locationServicesEnabled];
    CLAuthorizationStatus permission = [CLLocationManager authorizationStatus];
    BOOL locationCanBeAccessed =
        permission == kCLAuthorizationStatusNotDetermined ||
        permission == kCLAuthorizationStatusAuthorizedWhenInUse ||
        permission == kCLAuthorizationStatusAuthorizedAlways;
    
    if (locationServicesEnabled || locationCanBeAccessed) {
        self.locationManager = [CLLocationManager new];
    }
}

//MARK: - Map Rendering

- (MKMapRect)mapRectEncompassingSourceLocation:(nonnull CLLocation *)sourceLocation destinationLocation:(nonnull CLLocation *)destinationLocation {
    MKMapPoint sourcePoint = MKMapPointForCoordinate(sourceLocation.coordinate);
    MKMapPoint destinationPoint = MKMapPointForCoordinate(destinationLocation.coordinate);
    return MKMapRectMake(fmin(sourcePoint.x, destinationPoint.x),
                         fmin(sourcePoint.y, destinationPoint.y),
                         fabs(sourcePoint.x - destinationPoint.x),
                         fabs(sourcePoint.y - destinationPoint.y));
}

- (MKCoordinateRegion)mapRegionCenteredAroundLocation:(nonnull CLLocation *)location {
    return MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.2, 0.2));
}

- (nonnull UIImage *)imageFromRenderingSourceLocation:(nullable CLLocation *)sourceLocation destinationLocation:(nonnull CLLocation *)destinationLocation onSnapshot:(MKMapSnapshot *)snapshot {
    return snapshot.image;
}

@end

