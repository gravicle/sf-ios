//
//  FeedItemCell.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"
#import "MapSnapshotter.h"
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN
@interface FeedItemCell : UITableViewCell

@property (readonly, assign, nonatomic) CGRect contentFrame;

- (void)configureWithFeedItem:(FeedItem *)item snapshotter:(MapSnapshotter *)snapshotter;

/**
 For capturing snapshots of correct size, they need to be taken after all the layout work
 has been completed and the view hierarchy has settled.
 This method should be called from `tableView:willDisplayCell:`.
 */
- (void)layoutMap;

@end
NS_ASSUME_NONNULL_END
