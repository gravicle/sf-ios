//
//  FeedItem.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@interface FeedItem : NSObject

@property (nonatomic) NSString *dateString;
@property (nonatomic) NSString *title;
@property (nonatomic) NSAttributedString *subtitle;
@property (nonatomic) UIImage *annotationImage;
@property (readonly, assign, nonatomic) BOOL isActive;
@property (nullable, nonatomic) NSURL *coverImageFileURL;

- (instancetype)initWithEvent:(Event *)event;

@end
NS_ASSUME_NONNULL_END
