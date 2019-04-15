//
//  LyftTravelTimeEstimateOperation.m
//  SF iOS
//
//  Created by Amit Jain on 8/5/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "LyftTravelTimeEstimateOperation.h"
#import "TravelTime.h"
#import "SecretsStore.h"

@implementation LyftTravelTimeEstimateOperation

- (id)initWithSourceLocation:(CLLocation *)sourceLocation destinationLocation:(CLLocation *)destinationLocation completionHandler:(TravelTimeCalculationCompletion)completionHandler {
    CLLocationCoordinate2D start = sourceLocation.coordinate;
    CLLocationCoordinate2D end = destinationLocation.coordinate;
    NSString *path = [NSString stringWithFormat:@"https://api.lyft.com/v1/cost?start_lat=%f&start_lng=%f&end_lat=%f&end_lng=%f", start.latitude, start.longitude, end.latitude, end.longitude];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    request.HTTPMethod = @"GET";
    
    NSString *token = [NSString stringWithFormat:@"Bearer %@", [[SecretsStore alloc] init].lyftServerToken];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    [request addValue:@"en_US" forHTTPHeaderField:@"Accept-Language"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    __weak typeof(self) welf = self;
    return [super initWithRequest:request completionHandler:^(JSON * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !json) {
            completionHandler(nil, error);
        } else {
            TravelTime *travelTime = [welf shortestTravelTimeFromResponseJSON:json];
            completionHandler(travelTime, nil);
        }
    }];
}

- (nullable TravelTime *)shortestTravelTimeFromResponseJSON:(JSON *)json {
    NSMutableArray *estimates = [NSMutableArray arrayWithArray:json[@"cost_estimates"]];
    [estimates sortUsingComparator:^NSComparisonResult(JSON *_Nonnull obj1, JSON *_Nonnull obj2) {
        NSNumber *duration1 = (NSNumber *)obj1[@"estimated_duration_seconds"];
        NSNumber *duration2 = (NSNumber *)obj2[@"estimated_duration_seconds"];
        return [duration1 compare:duration2];
    }];
    
    NSNumber *estimate = estimates.firstObject[@"estimated_duration_seconds"];
    return estimate != nil ? [[TravelTime alloc] initWithTransportType:TransportTypeLyft travelTime:estimate.doubleValue] : nil;
}

@end
