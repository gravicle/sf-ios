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

// Support multiple requests backed by a single location manager
@property (nullable, nonatomic) NSMutableArray<UserLocationRequestCompletionHandler> *requestCompletionHandlers;

@end
NS_ASSUME_NONNULL_END

@implementation UserLocation

- (instancetype)init {
    if (self = [super init]) {
        self.requestCompletionHandlers = [NSMutableArray new];
        self.locationManager = [CLLocationManager new];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
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
    if (!self.canRequestUserLocation) {
        completionHandler(nil, [NSError appErrorWithDescription:@"Access to location has not been granted."]);
        return;
    }
    
    [self.requestCompletionHandlers addObject:completionHandler];
    [self.locationManager requestLocation];
}

//MARK: - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count == 0) {
        [self callCompletionHandlersWithLocation:nil error:[NSError appErrorWithDescription:@"Locations array came in empty."]];
        return;
    }
    
    [self callCompletionHandlersWithLocation:locations.firstObject error:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self callCompletionHandlersWithLocation:nil error:error];
}

// MARK - Completion Handlers

- (void)callCompletionHandlersWithLocation:(nullable CLLocation *)location error:(nullable NSError *)error {
    for (UserLocationRequestCompletionHandler handler in self.requestCompletionHandlers) {
        handler(location, error);
    }
    [self.requestCompletionHandlers removeAllObjects];
}

@end
