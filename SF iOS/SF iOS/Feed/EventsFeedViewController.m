//
//  EventsFeedViewController.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventsFeedViewController.h"
#import "FeedItemCell.h"
#import "FeedItem.h"
#import "MapSnapshotter.h"
#import "UserLocation.h"
#import "EventDetailsViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface EventsFeedViewController ()

@property (nonatomic) EventDataSource *dataSource;
@property (nullable, nonatomic) UserLocation *userLocationService;
@property (nonatomic) MapSnapshotter *snapshotter;

@end
NS_ASSUME_NONNULL_END

@implementation EventsFeedViewController

- (instancetype)initWithDataSource:(EventDataSource *)dataSource {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.dataSource = dataSource;
        dataSource.delegate = self;
        self.userLocationService = [UserLocation new];
        self.snapshotter = [[MapSnapshotter alloc] initWithUserLocationService:self.userLocationService];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    NSAssert(false, @"Use -initWithDataSource");
    self = [self initWithDataSource:[EventDataSource new]];
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(false, @"Use -initWithDataSource");
    self = [self initWithDataSource:[EventDataSource new]];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"Use -initWithDataSource");
    self = [self initWithDataSource:[EventDataSource new]];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:self.feedItemCellClass forCellReuseIdentifier:NSStringFromClass(self.feedItemCellClass)];
    self.tableView.rowHeight = self.cellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self.dataSource action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.dataSource refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestLocationPermission];
}

//MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.numberOfEvents;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.feedItemCellClass) forIndexPath:indexPath];
    if (!cell) {
        NSAssert(false, @"cell couldn't be dequeued");
    }
    
    FeedItem *item = [[FeedItem alloc] initWithEvent:[self.dataSource eventAtIndex:indexPath.row]];
    [cell configureWithFeedItem:item snapshotter:self.snapshotter];
    
    return cell;
}

- (Class)feedItemCellClass {
    return [FeedItemCell class];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(FeedItemCell *)cell layoutMap];
}

//MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [self.dataSource eventAtIndex:indexPath.row];
    EventDetailsViewController *detailsViewController = [[EventDetailsViewController alloc] initWithEvent:event];
    [self presentViewController:detailsViewController animated:true completion:nil];
}

//MARK: - EventDataSourceDelegate

- (void)willUpdateDataSource:(EventDataSource *)datasource {
    [self.refreshControl beginRefreshing];
}

- (void)didUpdateDataSource:(EventDataSource *)datasource {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)dataSource:(EventDataSource *)datasource failedToUpdateWithError:(NSError *)error {
    [self.refreshControl endRefreshing];
    
    NSLog(@"Error fetching events: %@", error);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Fetching Events" message:@"There was an error fetching events. Please try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:true completion:nil];
}

//MARK: - Location Permission

- (void)requestLocationPermission {
    [self.userLocationService requestLocationPermission];
}

//MARK: - Cell Dimensions

static CGFloat const eventCellAspectRatio = 1.352;
//static CGFloat const eventCellMapAspectRatio = 1.02;

- (CGFloat)cellHeight{
    return [UIScreen mainScreen].bounds.size.width * eventCellAspectRatio;
}

@end
