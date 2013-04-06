//
//  UpcomingEventsViewController.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "UpcomingEventListViewController.h"
#import "AnseoObjectConfiguration.h"
#import "EventListTableDataSource.h"
#import "MemberListViewController.h"
#import "MemberListTableDataSource.h"
#import "MeetupDotComManager.h"
#import "ParseDotComManager.h"
#import "EventMemberGuestTabBarController.h"
#import <objc/runtime.h>

//static NSString *eventCellReuseIdentifier = @"eventCell";

@interface UpcomingEventListViewController ()
- (void) fetchEventContents;
- (void)userDidSelectEventNotification: (NSNotification *)note;

@end

@implementation UpcomingEventListViewController
@synthesize meetupDotComMgr;
@synthesize parseDotComMgr;
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
	// Do any additional setup after loading the view.
    
    self.objectConfiguration = [[AnseoObjectConfiguration alloc] init];
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

    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(userDidSelectEventNotification:)
     name: EventListTableDidSelectEventNotification
     object: nil];

    
    if ([self.dataSource isKindOfClass: [EventListTableDataSource class]]) {
        [self fetchEventContents];
//        [(EventListTableDataSource *)self.dataSource setAvatarStore: [objectConfiguration avatarStore]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
        NSLog(@"On Row : %d", path.row);
        
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

- (void) fetchEventContents {
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.eventDelegate = self;
    NSString *groupUrlName = @"Panorama Toastmasters";
    [self.parseDotComMgr fetchEventsForGroupName:groupUrlName status:@"upcoming"];
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

//- (void)didInsertNewEvent:(Event *)selectedEvent {
//    NSLog(@"Success!! New event has been added to PARSE.");
//    [self performSegueWithIdentifier:@"MemberGuest" sender:selectedEvent];
//
//}



#pragma mark - Notification handling

- (void)userDidSelectEventNotification:(NSNotification *)note {
    Event *selectedEvent = (Event *)[note object];
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.eventDelegate = self;
    

    [self performSegueWithIdentifier:@"MemberGuest" sender:selectedEvent];       

}





@end
