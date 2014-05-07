//
//  UpcomingEventsViewController.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventListViewController.h"

#import "E1HObjectConfiguration.h"
#import "EventListTableDataSource.h"
#import "MemberListViewController.h"
#import "MemberListTableDataSource.h"
#import "ParseDotComManager.h"
#import "EventMemberGuestTabBarController.h"
#import "E1HAppDelegate.h"
#import "CommonUtilities.h"

#import <objc/runtime.h>

//static NSString *eventCellReuseIdentifier = @"eventCell";

@interface EventListViewController ()

- (void)userDidSelectEventNotification: (NSNotification *)note;
@end

@implementation EventListViewController
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
	// Do any additional setup after loading the view.

    UIImageView * background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white-iphone-4-wallpaper.jpg"]];
    self.tableView.backgroundView = background;
    
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
    
    [CommonUtilities showProgressHUD:self.view];
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(userDidSelectEventNotification:)
     name: EventListTableDidSelectEventNotification
     object: nil];
    
    E1HAppDelegate *appDelegate = (E1HAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSNumber *orgId = [appDelegate parseDotComAccountOrgId];
    
    if (!self.eventStatus) {
        self.eventStatus = appDelegate.parseDotComAccountEventStatusOnLaunch;
    }
    
    if ([self.dataSource isKindOfClass: [EventListTableDataSource class]]) {
        [self fetchEventContentForOrgId:orgId withStatus:self.eventStatus];

        //        [(EventListTableDataSource *)self.dataSource setAvatarStore: [objectConfiguration avatarStore]];
    }
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter]
     removeObserver: self name: EventListTableDidSelectEventNotification object: nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"MemberGuest"])
	{
        // Assume self.view is the table view
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSLog(@"On Row : %ld", (long)path.row);
        
        EventMemberGuestTabBarController *tabBarController = (EventMemberGuestTabBarController *)segue.destinationViewController;
        
        UINavigationController *navViewController = [tabBarController viewControllers][0];
        MemberListViewController *memberViewController = [navViewController viewControllers][0];
        MemberListTableDataSource *membersDataSource = [[MemberListTableDataSource alloc] init];
        Event *selectedEvent = (Event *)sender;
        tabBarController.selectedEvent = selectedEvent;
        membersDataSource.event = selectedEvent;
        memberViewController.dataSource = membersDataSource;
        memberViewController.objectConfiguration = self.objectConfiguration;
        
	}
}

- (void) fetchEventContentForOrgId:(NSNumber *)orgId withStatus:(NSString *)status {

    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.eventDelegate = self;

    [self.parseDotComMgr fetchEventsForOrgId:orgId withStatus:status];
}



- (void)userDidSelectPastEvents {
    EventListViewController *nextViewController = [[EventListViewController alloc] init];
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
    [CommonUtilities hideProgressHUD:self.view];
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


NSString *eventCellReuseIdentifier = @"eventCell";
