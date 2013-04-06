//
//  UpcomingEventsViewController.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventListViewController.h"
#import "EventManagerDelegate.h"

@class MeetupDotComManager;
@class ParseDotComManager;

@interface UpcomingEventListViewController : EventListViewController

@property (strong) MeetupDotComManager *meetupDotComMgr;
@property (strong) ParseDotComManager *parseDotComMgr;

@end
