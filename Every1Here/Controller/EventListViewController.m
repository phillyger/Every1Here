//
//  Every1HereViewController.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/3/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventListViewController.h"
#import "EventListTableDataSource.h"
#import "MemberListTableDataSource.h"
#import "E1HObjectConfiguration.h"
#import "ParseDotComManager.h"
#import "MeetupDotComManager.h"
#import "EventCell.h"
#import "HMSegmentedControl.h"
#import <objc/runtime.h>



@interface EventListViewController ()

@end

@implementation EventListViewController
@synthesize tableView;
@synthesize dataSource;
@synthesize objectConfiguration;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"Tab Bar Item Title: %@", self.tabBarItem.title);

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    

//    if ([self.dataSource isKindOfClass: [MemberListTableDataSource class]]) {
//        ((MemberListTableDataSource *)dataSource).notificationCenter = [NSNotificationCenter defaultCenter];
//    }
//    [[NSNotificationCenter defaultCenter]
//     addObserver: self
//     selector: @selector(userDidSelectMemberNotification:)
//     name: MemberListDidSelectMemberNotification
//     object: nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Upcoming", @"Past"]];
    [segmentedControl setFrame:CGRectMake(10, 10, 300, 44)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter]
     removeObserver: self name: EventListTableDidSelectEventNotification object: nil];
//    [[NSNotificationCenter defaultCenter]
//     removeObserver: self name: MemberListDidSelectMemberNotification object: nil];
}


#pragma mark - Event Manager Delegate
- (void)didReceiveEvents: (NSArray *)events{}
- (void)retrievingEventsFailedWithError: (NSError *)error{}
   

@end

NSString *eventCellReuseIdentifier = @"eventCell";
