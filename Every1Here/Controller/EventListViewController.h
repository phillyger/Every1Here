//
//  AnseoViewController.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/3/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseDotComManagerDelegate.h"
#import "MeetupDotComManagerDelegate.h"
#import "EventManagerDelegate.h"

@class AnseoObjectConfiguration;

@class EventTableDelegate;
@class EventListTableDataSource;

@interface EventListViewController : UIViewController <EventManagerDelegate>

@property (weak) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;
@property (strong) AnseoObjectConfiguration *objectConfiguration;


@end

extern NSString *eventCellReuseIdentifier;