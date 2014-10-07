//
//  UpcomingEventsViewController.h
//  E1H
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "BaseViewController.h"
#import "EventManagerDelegate.h"


@class E1HObjectConfiguration;
@class EventTableDelegate;
@class EventListTableDataSource;

@interface EventListViewController : BaseViewController <EventManagerDelegate>

@property (nonatomic, strong) NSString *eventStatus;

- (void) fetchEventContentForOrgId:(NSNumber *)orgId withStatus:(NSString *)status;

@end


extern NSString *eventCellReuseIdentifier;