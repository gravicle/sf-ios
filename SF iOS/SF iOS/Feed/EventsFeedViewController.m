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
#import "UIViewController+StatusBarBackground.h"

NS_ASSUME_NONNULL_BEGIN
@interface EventsFeedViewController ()

@property (nonatomic) EventDataSource *dataSource;
@property (nullable, nonatomic) UserLocation *userLocationService;
@property (nonatomic) MapSnapshotter *snapshotter;
@property (nonatomic) UITableView *tableView;
@property (nonatomic, assign) BOOL firstLoad;

@end
NS_ASSUME_NONNULL_END

@implementation EventsFeedViewController

- (instancetype)initWithDataSource:(EventDataSource *)dataSource {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.dataSource = dataSource;
        dataSource.delegate = self;
        self.userLocationService = [UserLocation new];
        self.snapshotter = [[MapSnapshotter alloc] initWithUserLocationService:self.userLocationService];
        self.firstLoad = true;
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
    
    [self addStatusBarBlurBackground];
    
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
        [self refresh];
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

//MARK: - First Load

- (void)refresh {
    if (!self.firstLoad) {
        [self.tableView reloadData];
        return;
    }
    
    [self animateFirstLoad];
    self.firstLoad = false;
}

- (void)animateFirstLoad {
    [self.tableView reloadData];
    
    NSTimeInterval stagger = 0.2;
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, [UIScreen mainScreen].bounds.size.height);
        cell.alpha = 0.25;
        
        [UIView
         animateWithDuration:0.65
         delay:(stagger * idx)
         usingSpringWithDamping:0.775
         initialSpringVelocity:0
         options:0
         animations:^{
             cell.alpha = 1;
             cell.transform = CGAffineTransformIdentity;
         }
         completion:nil];
    }];
}

@end
