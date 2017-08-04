//
//  TravelTimesView.m
//  SF iOS
//
//  Created by Amit Jain on 8/3/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "TravelTimesView.h"
#import "TravelTimeCell.h"

@interface TravelTimesView ()

@property (nonatomic) NSArray<TravelTime *> *travelTimes;

@end

@implementation TravelTimesView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]]) {
        self.travelTimes = [NSArray new];
        self.dataSource = self;
        [self setup];
    }
    return self;
}

- (void)showTravelTimes:(NSArray<TravelTime *> *)travelTimes {
    self.travelTimes = travelTimes;
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
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.travelTimes.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TravelTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    if (!cell) {
        cell = [TravelTimeCell new];
    }
    [cell configureWithTravelTime:self.travelTimes[indexPath.row]];
    return cell;
}

@end
