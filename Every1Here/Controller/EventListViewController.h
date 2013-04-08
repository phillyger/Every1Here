//
//  Every1HereViewController.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/3/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseDotComManagerDelegate.h"
#import "MeetupDotComManagerDelegate.h"
#import "EventManagerDelegate.h"

@class E1HObjectConfiguration;

@class EventTableDelegate;
@class EventListTableDataSource;

@interface EventListViewController : UIViewController <EventManagerDelegate>

@property (weak) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;
@property (strong) E1HObjectConfiguration *objectConfiguration;


@end

extern NSString *eventCellReuseIdentifier;