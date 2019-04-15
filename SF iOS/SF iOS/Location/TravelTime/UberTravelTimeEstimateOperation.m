//
//  UberTravelTimeEstimateOperation.m
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "UberTravelTimeEstimateOperation.h"
#import "HTTPRequestAsyncOperation.h"
#import "SecretsStore.h"

@implementation UberTravelTimeEstimateOperation

- (instancetype)initWithSourceLocation:(CLLocation *)sourceLocation destinationLocation:(CLLocation *)destinationLocation completionHandler:(TravelTimeCalculationCompletion)completionHandler {
    CLLocationCoordinate2D start = sourceLocation.coordinate;
    CLLocationCoordinate2D end = destinationLocation.coordinate;
    NSString *path = [NSString stringWithFormat:@"https://api.uber.com/v1.2/estimates/price?start_latitude=%f&start_longitude=%f&end_latitude=%f&end_longitude=%f", start.latitude, start.longitude, end.latitude, end.longitude];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = @"GET";
    
    NSString *token = [NSString stringWithFormat:@"Token %@", [[SecretsStore alloc] init].uberServerToken];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    [request addValue:@"en_US" forHTTPHeaderField:@"Accept-Language"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 
    __weak typeof(self) welf = self;
    return [super initWithRequest:request completionHandler:^(NSDictionary * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !json) {
            completionHandler(nil, error);
        } else {
            TravelTime *travelTime = [welf shortestTravelTimeFromResponseJSON:json];
            completionHandler(travelTime, nil);
        }
    }];
}

- (nullable TravelTime *)shortestTravelTimeFromResponseJSON:(nonnull JSON *)json {
    NSMutableArray *estimates = [NSMutableArray arrayWithArray:json[@"prices"]];
    [estimates sortUsingComparator:^NSComparisonResult(JSON *_Nonnull obj1, JSON *_Nonnull obj2) {
        NSNumber *duration1 = (NSNumber *)obj1[@"duration"];
        NSNumber *duration2 = (NSNumber *)obj2[@"duration"];
        return [duration1 compare:duration2];
    }];
    
    NSNumber *estimate = [(JSON *)estimates.firstObject objectForKey:@"duration"];
    return estimate != nil ? [[TravelTime alloc] initWithTransportType:TransportTypeUber travelTime:estimate.doubleValue] : nil;
}

@end
