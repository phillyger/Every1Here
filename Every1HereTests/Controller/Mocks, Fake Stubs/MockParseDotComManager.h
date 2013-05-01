//
//  MockParseDotComManager.h
//  E1H
//
//  Created by Ger O'Sullivan on 3/5/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberCommunicatorDelegate.h"
#import "EventCommunicatorDelegate.h"

@class Event;
@class Group;

@interface MockParseDotComManager : NSObject <MemberCommunicatorDelegate, EventCommunicatorDelegate> {
    
    NSInteger eventFailureErrorCode;
    NSInteger memberFailureErrorCode;
    NSString *eventsString;
    NSString *membersString;
    BOOL wasAskedToFetchEvents;
    BOOL wasAskedToFetchMembers;
}


- (NSInteger)eventFailureErrorCode;
- (NSInteger)memberFailureErrorCode;

- (NSString *)eventsString;
- (NSString *)membersString;

- (BOOL)didFetchMembers;
- (BOOL)didFetchEvents;
- (void)fetchMembersForEvent: (Event *)event;
- (void)fetchMembersForGroup:(Group *)group;
- (void)fetchEventsForGroup:(Group *)group;

@property (strong) id<MemberCommunicatorDelegate> memberDelegate;
@property (strong) id<EventCommunicatorDelegate> eventDelegate;

@end
