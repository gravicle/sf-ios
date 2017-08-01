//
//  CurrentLocation.m
//  SF iOS
//
//  Created by Amit Jain on 8/1/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "UserLocation.h"
#import "NSError+Constructor.h"

NS_ASSUME_NONNULL_BEGIN
@interface UserLocation ()

@property (nonatomic) CLLocationManager *locationManager;
@property (nullable, nonatomic) UserLocationRequestCompletionHandler requestCompletionHandler;
@property (nullable, nonatomic) CLLocation *lastKnownLocation;
@property (nullable, nonatomic) NSTimer *cacheExpirationTimer;

@end
NS_ASSUME_NONNULL_END

static NSTimeInterval const cacheExpirationduration = 10.0; //10s

@implementation UserLocation

- (instancetype)init {
    if (self = [super init]) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
    }
    return self;
}

- (BOOL)canRequestUserLocation {
    BOOL locationServicesEnabled = [CLLocationManager locationServicesEnabled];
    
    CLAuthorizationStatus permission = [CLLocationManager authorizationStatus];
    BOOL locationCanBeAccessed = permission == kCLAuthorizationStatusAuthorizedWhenInUse || permission == kCLAuthorizationStatusAuthorizedAlways;
    
    return locationServicesEnabled && locationCanBeAccessed;
}

- (BOOL)canRequestLocationPermission {
    BOOL locationServicesEnabled = [CLLocationManager locationServicesEnabled];
    
    CLAuthorizationStatus permission = [CLLocationManager authorizationStatus];
    BOOL permissionHasBeenDenied = permission == kCLAuthorizationStatusDenied ||permission == kCLAuthorizationStatusRestricted;
    BOOL permissionHasNotBeenDenied = !permissionHasBeenDenied;
    
    return locationServicesEnabled && permissionHasNotBeenDenied;
}

- (void)requestLocationPermission {
    if (self.canRequestLocationPermission) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

-(void)requestWithCompletionHandler:(UserLocationRequestCompletionHandler)completionHandler {
    if (self.lastKnownLocation) {
        completionHandler(self.lastKnownLocation, nil);
        return;
    }
    
    self.requestCompletionHandler = completionHandler;
    [self.locationManager requestLocation];
}

- (void)startCacheExpirationTimer {
    __weak typeof(self) welf = self;
    self.cacheExpirationTimer = [NSTimer scheduledTimerWithTimeInterval:cacheExpirationduration repeats:false block:^(NSTimer * _Nonnull timer) {
        welf.lastKnownLocation = nil;
    }];
}

- (void)cancelCacheExpirationTimer {
    if (!self.cacheExpirationTimer) {
        return;
    }
    [self.cacheExpirationTimer invalidate];
    self.cacheExpirationTimer = nil;
}

//MARK: - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self cancelCacheExpirationTimer];
    
    if (locations.count == 0) {
        self.requestCompletionHandler(nil, [NSError appErrorWithDescription:@"Locations array came in empty."]);
        return;
    }
    
    self.lastKnownLocation = locations.firstObject;
    self.requestCompletionHandler(self.lastKnownLocation, nil);
    [self startCacheExpirationTimer];
    self.requestCompletionHandler = nil;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.requestCompletionHandler(nil, error);
    self.requestCompletionHandler = nil;
}

@end
