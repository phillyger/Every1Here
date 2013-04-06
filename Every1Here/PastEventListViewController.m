//
//  PastEventsViewController.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "PastEventListViewController.h"
#import "ParseDotComManager.h"
#import "AnseoObjectConfiguration.h"
#import "EventListTableDataSource.h"
#import <objc/runtime.h>
/* Temp */
#import "Event.h"
#import "Group.h"
#import "Venue.h"
#import "Address.h"

@interface PastEventListViewController ()

- (void) fetchEventContents;
- (void)userDidSelectEventNotification: (NSNotification *)note;

@end

@implementation PastEventListViewController
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
//    self.objectConfiguration = [[AnseoObjectConfiguration alloc] init];
    //  pastEventViewController.objectConfiguration = [[AnseoObjectConfiguration alloc] init];
  
//    self.objectConfiguration = [[AnseoObjectConfiguration alloc] init];
//    EventListTableDataSource *eventDataSource = [[EventListTableDataSource alloc] init];
//    self.dataSource = eventDataSource;
//    self.tableView.delegate = self.dataSource;
//    self.tableView.dataSource = self.dataSource;
//    
//    UINib *eventCellNib = [UINib nibWithNibName:@"EventCell" bundle:nil];
//    [self.tableView registerNib:eventCellNib
//         forCellReuseIdentifier:eventCellReuseIdentifier];
//    
//    
//    objc_property_t tableViewProperty = class_getProperty([dataSource class], "tableView");
//    if (tableViewProperty) {
//        [dataSource setValue: tableView forKey: @"tableView"];
//    }
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchEventContents
{
    //Past Events
        self.parseDotComMgr = [objectConfiguration parseDotComManager];
        self.parseDotComMgr.eventDelegate = self;
        //        NSString *groupName = @"Panorama Toastmasters";
        //        [self.parseDotComMgr fetchPastEventsForGroupName:groupName];
        [self didReceiveEvents:[self events]];
  
}

- (void)userDidSelectEventNotification:(NSNotification *)note {
    [self performSegueWithIdentifier:@"Attendance" sender:note];
}

- (void)didReceiveEvents:(NSArray *)events {
    if ([self.dataSource isKindOfClass: [EventListTableDataSource class]]) {
        [(EventListTableDataSource *)dataSource setEvents:[(EventListTableDataSource *)dataSource sortEventArray:events]];
        ;
    }
    [tableView reloadData];
}


- (NSArray *)events {
    NSString *names[] = { @"Event 1", @"Event 2", @"Event 3", @"Event 4", @"Event 5" };
    
    NSMutableArray *eventList = [NSMutableArray array];
    Group *group = [[Group alloc] initWithName:@"Panorama Toastmasters"];
    Address *address = [[Address alloc] initWithAddress:@"123 Main St" city:@"Philadelphia" state:@"PA" zip:@"19146" country:@"US" lat:@0 lon:@0];
    Venue *venue = [[Venue alloc] initWithName:@"The Watermark" address:address];
    for (NSInteger i = 0; i < 5; i++) {
        Event *thisEvent = [[Event alloc] init];
        thisEvent.name = names[i];
        thisEvent.group = group;
        thisEvent.venue = venue;
        thisEvent.startDateTime = [NSDate date];
        [eventList addObject: thisEvent];
    }
    return [eventList copy];
}

#pragma mark - Event Delegate
- (void)retrievingEventsFailedWithError:(NSError *)error {
    
}



@end
