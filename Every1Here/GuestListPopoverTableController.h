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

@class Event;
@class GuestListViewController;
@class MeetupDotComManager;
@class TwitterDotComManager;
@class AnseoObjectConfiguration;
@class GuestSelectedCell;


@interface GuestListPopoverTableController : UITableViewController <GuestManagerDelegate>

//@property (weak, nonatomic) id <GuestManagerDelegate> guestDelegate;
@property (weak) IBOutlet GuestSelectedCell *guestCell;
@property (strong) MeetupDotComManager *meetupDotComMgr;
@property (strong) TwitterDotComManager *twitterDotComMgr;
@property (strong) AnseoObjectConfiguration *objectConfiguration;

@property(nonatomic,assign) GuestListViewController *delegate;
@property (nonatomic, readwrite) SocialNetworkType slType;
@property(nonatomic, strong) Event *event;
//@property(nonatomic, strong) NSMutableDictionary *guestListFullDict;
//@property(nonatomic, strong) NSMutableDictionary *guestListAttendeeDict;

@property(nonatomic, strong) NSMutableArray *guestFullListForSlType;
@property(nonatomic, strong) NSMutableArray *guestAttendeeListForSlType;


@end
