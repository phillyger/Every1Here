//
//  AnseoObjectConfiguration.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AnseoObjectConfiguration.h"
#import "ParseDotComManager.h"
#import "ParseDotComCommunicator.h"
#import "MeetupDotComManager.h"
#import "MeetupDotComCommunicator.h"
#import "TwitterDotComManager.h"
#import "TwitterDotComCommunicator.h"
#import "EventBuilder.h"
#import "MemberBuilder.h"
#import "GuestBuilder.h"
#import "AvatarStore.h"

@implementation AnseoObjectConfiguration

- (ParseDotComManager *)parseDotComManager {
    ParseDotComManager *parseDotComMgr = [[ParseDotComManager alloc] init];
    parseDotComMgr.communicator = [[ParseDotComCommunicator alloc] init];
    parseDotComMgr.communicator.delegate = parseDotComMgr;
    parseDotComMgr.memberBuilder = [[MemberBuilder alloc] init];
    parseDotComMgr.eventBuilder = [[EventBuilder alloc] init];
    return parseDotComMgr;
}

- (MeetupDotComManager *)meetupDotComManager {
    MeetupDotComManager *meetupDotComMgr = [[MeetupDotComManager alloc] init];
    meetupDotComMgr.communicator = [[MeetupDotComCommunicator alloc] init];
    meetupDotComMgr.communicator.delegate = meetupDotComMgr;    
    meetupDotComMgr.guestBuilder = [[GuestBuilder alloc] init];
    meetupDotComMgr.eventBuilder = [[EventBuilder alloc] init];
    return meetupDotComMgr;
}

- (TwitterDotComManager *)twitterDotComManager {
    TwitterDotComManager *twitterDotComMgr = [[TwitterDotComManager alloc] init];
    twitterDotComMgr.communicator = [[TwitterDotComCommunicator alloc] init];
    twitterDotComMgr.communicator.delegate = twitterDotComMgr;
    twitterDotComMgr.guestBuilder = [[GuestBuilder alloc] init];
    return twitterDotComMgr;
}


- (AvatarStore *)avatarStore {
    static AvatarStore *avatarStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avatarStore = [[AvatarStore alloc] init];
        [avatarStore useNotificationCenter: [NSNotificationCenter defaultCenter]];
    });
    return avatarStore;
}

@end
