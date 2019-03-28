//
//  VenueFetchOperation.m
//  SF iOS
//
//  Created by Roderic Campbell on 3/27/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import "VenueFetchOperation.h"

@implementation VenueFetchOperation
- (instancetype)initWithVenueID:(NSString *)venueID completionHandler:(VenueCompletion)completionHandler {
    NSString *endpoint = @"https://api.foursquare.com/v2/venues/";
    endpoint = [endpoint stringByAppendingString:venueID];
    endpoint = [endpoint stringByAppendingString:@"?client_id=OKMDH0JUFBASD2OGF5JFTRMR3BNA25UMPHDK0IULTH2B455B&client_secret=XY50ZJURLMHLRHYJ0ZMTFSEKWU1CBLPGXBW2SADYFBTW5EYB&v=20190324"];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]];

    request.HTTPMethod = @"GET";
    [request addValue:@"en_US" forHTTPHeaderField:@"Accept-Language"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    return [super initWithRequest:request completionHandler:^(NSDictionary * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !json) {
            completionHandler(nil, error);
        } else {
            completionHandler(json, nil);
        }
    }];


}
@end
