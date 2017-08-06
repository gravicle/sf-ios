//
//  TravelTimesView.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimesView.h"
#import "TravelTimeCell.h"

typedef NS_ENUM(NSUInteger, TravelTimeType) {
    TravelTimeTypeRegular = 0,
    TravelTimeTypeRideSharing = 1
};

@interface TravelTimesView ()

@property (nonatomic) NSDictionary<NSNumber *, NSArray<TravelTime *> *> *travelTimes;

@end

@implementation TravelTimesView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]]) {
        self.travelTimes = [NSDictionary new];
        self.dataSource = self;
        [self setup];
    }
    return self;
}

- (void)showTravelTimes:(NSArray<TravelTime *> *)travelTimes {
    self.travelTimes = [self travelTimesFromArray:travelTimes];
    [self reloadData];
    [self.collectionViewLayout invalidateLayout];
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = false;
    
    [self registerClass:self.cellClass forCellWithReuseIdentifier:NSStringFromClass(self.cellClass)];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 16;
    layout.minimumInteritemSpacing = 16;
    layout.estimatedItemSize = CGSizeMake(92, 36);
}

- (Class)cellClass {
    return [TravelTimeCell class];
}

//MARK: - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.travelTimes.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.travelTimes.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TravelTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    if (!cell) {
        cell = [TravelTimeCell new];
    }
    
    TravelTime *time = self.travelTimes[@(indexPath.section)][indexPath.row];
    [cell configureWithTravelTime:time];
    return cell;
}

// MARK: -

- (NSDictionary *)travelTimesFromArray:(NSArray<TravelTime *> *)array {
    NSMutableArray *regular = [NSMutableArray new];
    NSMutableArray *ridesharing = [NSMutableArray new];
    
    for (TravelTime *time in array) {
        switch (time.transportType) {
            case TransportTypeUber:
                [ridesharing addObject: time];
                break;
            case TransportTypeLyft:
                [ridesharing addObject: time];
                break;
            case TransportTypeWalking:
                [regular addObject: time];
                break;
            case TransportTypeAutomobile:
                [regular addObject: time];
                break;
            case TransportTypeTransit:
                [regular addObject: time];
                break;
            default:
                break;
        }
    }
    
    return @{@(TravelTimeTypeRegular) : regular, @(TravelTimeTypeRideSharing) : ridesharing};
}

@end
