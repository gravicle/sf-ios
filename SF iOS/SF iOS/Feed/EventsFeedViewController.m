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
@property (nonatomic) UITableView *tableView;

@end
NS_ASSUME_NONNULL_END

@implementation EventsFeedViewController

- (instancetype)initWithDataSource:(EventDataSource *)dataSource {
    if (self = [super initWithNibName:nil bundle:nil]) {
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
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *statusBarBackground = [[UIVisualEffectView alloc] initWithEffect:effect];
    statusBarBackground.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:statusBarBackground];
    [statusBarBackground.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [statusBarBackground.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [statusBarBackground.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    [statusBarBackground.heightAnchor constraintEqualToConstant:20].active = true;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:self.feedItemCellClass forCellReuseIdentifier:NSStringFromClass(self.feedItemCellClass)];
    self.tableView.rowHeight = self.cellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.tableView];
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [self.tableView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = true;
    
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView.refreshControl addTarget:self.dataSource action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self.view bringSubviewToFront:statusBarBackground];
    
    [self.dataSource refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestLocationPermission];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableView.refreshControl endRefreshing];
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
    EventDetailsViewController *detailsViewController = [[EventDetailsViewController alloc] initWithEvent:event userLocationService:self.userLocationService];
    [self presentViewController:detailsViewController animated:true completion:nil];
}

//MARK: - EventDataSourceDelegate

- (void)willUpdateDataSource:(EventDataSource *)datasource {
    [self.tableView.refreshControl beginRefreshing];
}

- (void)didUpdateDataSource:(EventDataSource *)datasource withNewData:(BOOL)hasNewData error:(NSError *)error {
    [self.tableView.refreshControl endRefreshing];
    
    if (hasNewData) {
        [self.tableView reloadData];
    }
    
    if (error) {
        [self handleError:error];
    }
}

//MARK: - Location Permission

- (void)requestLocationPermission {
    [self.userLocationService requestLocationPermission];
}

//MARK: - Cell Dimensions

static CGFloat const eventCellAspectRatio = 1.352;

- (CGFloat)cellHeight{
    return [UIScreen mainScreen].bounds.size.width * eventCellAspectRatio;
}

//MARK: - Error Handling

- (void)handleError:(NSError *)error {
    NSLog(@"Error fetching events: %@", error);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Fetching Events" message:@"There was an error fetching events. Please try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:true completion:nil];
}

@end
