//
//  EventsFeedViewController.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "EventsFeedViewController.h"

@interface EventsFeedViewController ()

@property (nonatomic, assign) EventType eventType;

@end

@implementation EventsFeedViewController

- (instancetype)initWithEventType:(EventType)eventType {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.eventType = eventType;
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(false, @"Use -initWithEventType");
    self = [self initWithEventType:EventTypeSFCoffee];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"Use -initWithEventType");
    self = [self initWithEventType:EventTypeSFCoffee];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
