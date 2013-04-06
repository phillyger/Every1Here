//
//  MemberListViewController.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/21/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventListViewController.h"
#import "AnseoObjectConfiguration.h"
#import "MemberManagerDelegate.h"
#import "EventManagerDelegate.h"

@class ParseDotComManager;

@interface MemberListViewController : EventListViewController <MemberManagerDelegate, ParseDotComManagerDelegate>

@property (strong) ParseDotComManager *parseDotComMgr;

@end

//extern NSString *EventListTableDidSelectEventNotification;
