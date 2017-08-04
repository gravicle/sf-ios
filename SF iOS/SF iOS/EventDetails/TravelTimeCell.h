//
//  TravelTimeCell.h
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelTime.h"

@interface TravelTimeCell : UICollectionViewCell

- (void)configureWithTravelTime:(TravelTime *)travelTime;

@end
