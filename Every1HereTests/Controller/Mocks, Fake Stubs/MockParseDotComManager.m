//
//  MockParseDotComManager.m
//  Anseo
//
//  Created by Ger O'Sullivan on 3/5/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MockParseDotComManager.h"

@implementation MockParseDotComManager 

@synthesize memberDelegate;
@synthesize eventDelegate;

- (NSInteger)pastEventFailureErrorCode {
    return eventFailureErrorCode;
}

- (NSInteger)memberFailureErrorCode {
    return memberFailureErrorCode;
}

- (void)fetchingMembersFailedWithError:(NSError *)error {
    memberFailureErrorCode = [error code];
}

- (void)fetchingEventsFailedWithError:(NSError *)error {
    eventFailureErrorCode = [error code];
}

- (void)receivedMembersJSON:(NSString *)objectNotation {
    membersString = objectNotation;
}

- (void)receivedEventsJSON:(NSString *)objectNotation {
    eventsString = objectNotation;
}

- (NSString *)membersString {
    return membersString;
}

- (NSString *)eventsString {
    return eventsString;
}

- (BOOL)didFetchMembers {
    return wasAskedToFetchMembers;
}

- (BOOL)didFetchEvents {
    return wasAskedToFetchEvents;
}

- (void)fetchMembersForEvent:(Event *)event {
    wasAskedToFetchMembers = YES;
}

- (void)fetchMembersForGroup:(Group *)group {
    wasAskedToFetchMembers = YES;
}

- (void)fetchEventsForGroup:(Group *)group {
    wasAskedToFetchEvents = YES;
}

@end
