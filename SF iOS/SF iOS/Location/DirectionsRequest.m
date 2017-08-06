//
//  DirectionsRequest.m
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "DirectionsRequest.h"
@import MapKit;

@implementation DirectionsRequest

+ (void)requestDirectionsToLocation:(CLLocation *)destination withName:(NSString *)name usingTransportType:(TransportType)transportType {
    switch (transportType) {
        case TransportTypeTransit:
            [self requestDirectionsToLocation:destination withName:name usingMode:MKLaunchOptionsDirectionsModeTransit];
            break;
            
        case TransportTypeAutomobile:
            [self requestDirectionsToLocation:destination withName:name usingMode:MKLaunchOptionsDirectionsModeDriving];
            break;
            
        case TransportTypeWalking:
            [self requestDirectionsToLocation:destination withName:name usingMode:MKLaunchOptionsDirectionsModeWalking];
            break;
            
        case TransportTypeUber:
            [self requestUberRideToLocation:destination withName:name];
            break;
            
        case TransportTypeLyft:
            [self requestLyftRideToLocation:destination withName:name];
            break;
            
        default:
            break;
    }
}

+ (void)requestDirectionsToLocation:(CLLocation *)destination withName:(NSString *)name usingMode:(NSString *)mode {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destination.coordinate];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = name;
    [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey : mode}];
}

+ (void)requestUberRideToLocation:(CLLocation *)destination withName:(NSString *)name {
    
}

+ (void)requestLyftRideToLocation:(CLLocation *)destination withName:(NSString *)name {
    
}

@end

