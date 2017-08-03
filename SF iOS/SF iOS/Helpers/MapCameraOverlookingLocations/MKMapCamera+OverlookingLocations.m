//
//  MKMapCamera+OverlookingLocations.m
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "MKMapCamera+OverlookingLocations.h"

@implementation MKMapCamera (OverlookingLocations)

// https://stackoverflow.com/a/21034410/2671390
static double const mapApertureInRadians = (30 * M_PI) / 180;

+ (MKMapCamera *)cameraOverlookingLocation1:(CLLocation *)location1 location2:(CLLocation *)location2 {
    CLLocationCoordinate2D coordinate1 = location1.coordinate;
    CLLocationCoordinate2D coordinate2 = location2.coordinate;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((coordinate1.latitude + coordinate2.latitude) / 2, (coordinate1.longitude + coordinate2.longitude) / 2);
    
    double span = [location1 distanceFromLocation:location2] / 2;
    double altitude = span / tan(mapApertureInRadians / 2);
    double altitudeAdjustedForPadding = altitude + (altitude * 0.15);
    
    return [MKMapCamera cameraLookingAtCenterCoordinate:centerCoordinate fromDistance:altitudeAdjustedForPadding pitch:0 heading:0];
}

@end
