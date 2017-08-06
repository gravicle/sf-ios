//
//  DirectionsRequest.m
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "DirectionsRequest.h"
#import "SecretsStore.h"
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
            [self requestLyftRideToLocation:destination];
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
    SecretsStore *store = [[SecretsStore alloc] init];
    NSString *clientID = store.uberClientID;
    NSString *escapedName = [name stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    // https://stackoverflow.com/questions/26049950/uber-deeplinking-on-ios
    NSString *query = [NSString stringWithFormat:@"?client_id=%@&action=setPickup&pickup=my_location&dropoff[latitude]=%f&dropoff[longitude]=%f&dropoff[nickname]=%@", clientID, destination.coordinate.latitude, destination.coordinate.longitude, escapedName];
    
    [self requestRideWithURLScheme:@"uber://" httpHost:@"https://m.uber.com/ul/" queryFragment:query];
}

+ (void)requestLyftRideToLocation:(CLLocation *)destination {
    SecretsStore *store = [[SecretsStore alloc] init];
    NSString *clientID = store.lyftClientID;
    
    NSString *query = [NSString stringWithFormat:@"?id=lyft&partner=%@&destination[latitude]=%f&destination[longitude]=%f", clientID, destination.coordinate.latitude, destination.coordinate.longitude];
    
    [self requestRideWithURLScheme:@"lyft://ridetype" httpHost:@"https://www.lyft.com/ride" queryFragment:query];
}

+ (void)requestRideWithURLScheme:(NSString *)urlScheme httpHost:(NSString *)httpHost queryFragment:(NSString *)query {
    NSString *path;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlScheme]]) {
        path = [NSString stringWithFormat:@"%@%@", urlScheme, query];
    } else {
        path = [NSString stringWithFormat:@"%@%@", httpHost, query];
    }
    
    NSURL *url = [NSURL URLWithString:path];
    NSAssert(url != nil, @"Failed to construct URL from path: %@", path);
    
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end

