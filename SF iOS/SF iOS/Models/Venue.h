//
//  Venue.h
//  SF iOS
//
//  Created by Roderic Campbell on 3/29/19.
//  Copyright © 2019 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;

NS_ASSUME_NONNULL_BEGIN

@interface Venue : NSObject
@property (nonatomic) NSURL *venueURL;
@property (nonatomic) Location *location;
@property (nonatomic) NSString *name;

- (id)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
