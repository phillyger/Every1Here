//
//  PastEventsViewController.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "PastEventListViewController.h"

#import "E1HObjectConfiguration.h"
#import "EventListTableDataSource.h"
#import "MemberListViewController.h"
#import "MemberListTableDataSource.h"
#import "ParseDotComManager.h"
#import "EventMemberGuestTabBarController.h"
#import "E1HAppDelegate.h"

#import <objc/runtime.h>

@interface PastEventListViewController ()

- (void)userDidSelectEventNotification: (NSNotification *)note;

@end

@implementation PastEventListViewController
@synthesize tableView;
@synthesize dataSource;
@synthesize objectConfiguration;
@synthesize eventStatus;

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

    self.objectConfiguration = [[E1HObjectConfiguration alloc] init];
    EventListTableDataSource *eventDataSource = [[EventListTableDataSource alloc] init];
    self.dataSource = eventDataSource;
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    
    UINib *eventCellNib = [UINib nibWithNibName:@"EventCell" bundle:nil];
    [self.tableView registerNib:eventCellNib
         forCellReuseIdentifier:eventCellReuseIdentifier];
    
    objc_property_t tableViewProperty = class_getProperty([dataSource class], "tableView");
    if (tableViewProperty) {
        [dataSource setValue: tableView forKey: @"tableView"];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    E1HAppDelegate *appDelegate = (E1HAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSNumber *orgId = [appDelegate parseDotComAccountOrgId];
    
    
    if ([self.dataSource isKindOfClass: [EventListTableDataSource class]]) {
        [self fetchEventContentForOrgId:orgId withStatus:self.eventStatus];
        //        [(EventListTableDataSource *)self.dataSource setAvatarStore: [objectConfiguration avatarStore]];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchEventContentForOrgId:(NSNumber *)orgId withStatus:(NSString *)status {
       
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.eventDelegate = self;
    
    [self.parseDotComMgr fetchEventsForOrgId:orgId withStatus:status];
}



- (void)userDidSelectPastEvents {
    PastEventListViewController *nextViewController = [[PastEventListViewController alloc] init];
    EventListTableDataSource *eventDataSource = [[EventListTableDataSource alloc] init];
    self.dataSource = eventDataSource;
    nextViewController.objectConfiguration = self.objectConfiguration;
    [[self navigationController] pushViewController: nextViewController animated: YES];
}

#pragma mark - EventManagerDelegate

- (void)didReceiveEvents:(NSArray *)events {
    if ([self.dataSource isKindOfClass: [EventListTableDataSource class]]) {
        if ([events count] > 1) {
            [(EventListTableDataSource *)dataSource setEvents:[(EventListTableDataSource *)dataSource sortEventArray:events]];
        } else {
            [(EventListTableDataSource *)dataSource setEvents:events];
        }
    }
    
    [(EventListTableDataSource *)dataSource buildEventDict];
    
    [tableView reloadData];
}

- (void)retrievingEventsFailedWithError:(NSError *)error {
    
}




#pragma mark - Notification handling

- (void)userDidSelectEventNotification:(NSNotification *)note {
    Event *selectedEvent = (Event *)[note object];
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.eventDelegate = self;
    
    
    [self performSegueWithIdentifier:@"MemberGuest" sender:selectedEvent];
    
}




@end
