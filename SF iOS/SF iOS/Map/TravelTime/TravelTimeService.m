//
//  TravelTimeService.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimeService.h"
#import "AsyncOperation.h"
@import MapKit;

@interface TravelTimeService ()

@property (nonatomic) NSOperationQueue *travelTimeCalculationQueue;

@end

@implementation TravelTimeService

- (instancetype)init {
    if (self = [super init]) {
        self.travelTimeCalculationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)calculateTravelTimesFromLocation:(CLLocation *)sourceLocation toLocation:(CLLocation *)destinationLocation withCompletionHandler:(TravelTimeCompletionHandler)completionHandler {
    [self.travelTimeCalculationQueue cancelAllOperations];
    
    __block NSMutableArray<TravelTime *> *travelTimes = [NSMutableArray new];
    
    MKDirectionsRequest *transitRequest = [self requestFromLocation:sourceLocation toLocation:destinationLocation usingTransporationType:MKDirectionsTransportTypeTransit];
    MKDirectionsRequest *walkingRequest = [self requestFromLocation:sourceLocation toLocation:destinationLocation usingTransporationType:MKDirectionsTransportTypeWalking];
    MKDirectionsRequest *drivingRequest = [self requestFromLocation:sourceLocation toLocation:destinationLocation usingTransporationType:MKDirectionsTransportTypeTransit];
    NSArray *requests = @[transitRequest, walkingRequest, drivingRequest];
    
    NSOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(travelTimes);
        });
    }];
    
    for (MKDirectionsRequest *request in requests) {
        AsyncOperation *travelTimeCalculation = [self travelTimeCalculationWithRequest:request completionHandler:^(TravelTime * _Nullable travelTime) {
            if (travelTime){
                [travelTimes addObject:travelTime];
            }
        }];
        [completionOperation addDependency:travelTimeCalculation];
        [self.travelTimeCalculationQueue addOperation:travelTimeCalculation];
    }
    [self.travelTimeCalculationQueue addOperation:completionOperation];
}

- (MKDirectionsRequest *)requestFromLocation:(CLLocation *)sourceLocation toLocation:(CLLocation *)destinationLocation usingTransporationType:(MKDirectionsTransportType)transportationType {
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [[MKMapItem alloc] initWithPlacemark: [[MKPlacemark alloc] initWithCoordinate:sourceLocation.coordinate]];
    request.destination = [[MKMapItem alloc] initWithPlacemark: [[MKPlacemark alloc] initWithCoordinate:destinationLocation.coordinate]];
    request.requestsAlternateRoutes = false;
    request.transportType = MKDirectionsTransportTypeTransit | MKDirectionsTransportTypeWalking | MKDirectionsTransportTypeAutomobile;
    return request;
}

- (AsyncOperation *)travelTimeCalculationWithRequest:(MKDirectionsRequest *)request completionHandler:(void(^)(TravelTime * _Nullable travelTime))resultHandler {
    return [[AsyncOperation alloc] initWithAsyncBlock:^(dispatch_block_t  _Nonnull completionHandler) {
        MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
        [direction calculateETAWithCompletionHandler:^(MKETAResponse * _Nullable response, NSError * _Nullable error) {
            if (!response) {
                NSLog(@"Could not get travel time for request:\n%@\n%@", request, error);
                resultHandler(nil);
                completionHandler();
            }
            TravelTime *result = [[TravelTime alloc] initWithTransportType:request.transportType travelTime:response.expectedTravelTime];
            resultHandler(result);
            completionHandler();
        }];
    }];
}

@end
