//
//  DemoTableControllerViewController.h
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuestCommunicatorDelegate.h"
#import "GuestManagerDelegate.h"
#import "ParseDotComManagerDelegate.h"

@class Event;
@class GuestListViewController;
@class MeetupDotComManager;
@class ParseDotComManager;
@class TwitterDotComManager;
@class E1HObjectConfiguration;
@class GuestSelectedCell;


@interface GuestListPopoverTableController : UITableViewController <GuestManagerDelegate>

//@property (weak, nonatomic) id <GuestManagerDelegate> guestDelegate;
@property (weak) IBOutlet GuestSelectedCell *guestCell;
@property (strong) MeetupDotComManager *meetupDotComMgr;
@property (strong) ParseDotComManager *parseDotComMgr;
@property (strong) TwitterDotComManager *twitterDotComMgr;
@property (strong) E1HObjectConfiguration *objectConfiguration;

@property(nonatomic,assign) GuestListViewController *delegate;
@property (nonatomic, readwrite) SocialNetworkType slType;
@property(nonatomic, strong) Event *selectedEvent;

@property(nonatomic, strong) NSMutableArray *guestFullListForSlType;
@property(nonatomic, strong) NSMutableArray *guestAttendeeListForSlType;


@end
