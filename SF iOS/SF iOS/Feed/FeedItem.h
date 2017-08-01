//
//  FeedItem.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN
@interface FeedItem : NSObject

@property (nonatomic) NSString *time;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic, assign) BOOL shouldShowDirections;
@property (nullable, nonatomic) NSURL *coverImageURL;
@property (nonatomic) CLLocation *location;

- (instancetype)initWithEvent:(Event *)event;

@end
NS_ASSUME_NONNULL_END
