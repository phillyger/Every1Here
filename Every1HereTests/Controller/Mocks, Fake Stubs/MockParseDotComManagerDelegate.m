//
//  MockParseDotComManagerDelegate.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MockParseDotComManagerDelegate.h"
#import "Event.h"
#import "User.h"

@implementation MockParseDotComManagerDelegate
@synthesize fetchedMembers;
@synthesize fetchedEvents;
@synthesize fetchError;
@synthesize successEvent;

- (void)retrievingMembersFailedWithError:(NSError *)error {
    self.fetchError = error;
}

- (void)retrievingEventsFailedWithError:(NSError *)error {
    self.fetchError = error;
}

- (void)didReceiveMembers:(NSArray *)members {
    self.fetchedMembers = members;
}

-(void)didReceiveEvents:(NSArray *)events {
    self.fetchedEvents = events;
}

- (void)membersReceivedForEvent:(Event *)event {
    self.successEvent = event;
}


@end
