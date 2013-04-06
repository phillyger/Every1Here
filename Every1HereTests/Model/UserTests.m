//
//  UserTests.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/27/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "UserTests.h"
#import "User.h"


@implementation UserTests

- (void)setUp {
    member = [[User alloc] initWithFirstName:@"Ger" lastName:@"O'Sullivan" avatarLocation:nil slType:NONE];
    guest = [[User alloc] initWithDisplayName:@"Ger O'Sullivan" avatarLocation:@"http://photos4.meetupstatic.com/photos/member/8/c/2/a/thumb_81575882.jpeg" slType:NONE];
}

- (void)tearDown {
    member = nil;
    guest = nil;
}




/****   Member Tests Begin ****/

- (void)testThatMemberHasTheFirstName {
    STAssertEqualObjects(member.firstName, @"Ger", @"expecting a member to provide their first name.");
}

- (void)testThatMemberHasTheLastName {
    STAssertEqualObjects(member.lastName, @"O'Sullivan", @"expecting a member to provide their last name.");
}

- (void)testThatMemberHasTheRightDisplayName {
    STAssertEqualObjects(member.displayName, @"Ger O'Sullivan", @"expecting a member to provide its display name.");
}

- (void)testNilAvatarUrlReturnedWhenNilLocationPassed {
    STAssertNil(member.avatarURL, @"avatarUrl property is nil when passed a nil location.");
}

/****   End Member Tests ****/

/****   Guest Tests Begin ****/
- (void)testThatGuestHasTheRightDisplayName {
    STAssertEqualObjects(guest.displayName, @"Ger O'Sullivan", @"expecting a guest to provide its display name.");
}

- (void)testThatGuestHasAnAvatarURL {
    NSURL *url = guest.avatarURL;
    STAssertEqualObjects([url absoluteString], @"http://photos4.meetupstatic.com/photos/member/8/c/2/a/thumb_81575882.jpeg", @"The User's avatar should be represented by a URL");
}
/****   End Guest Tests ****/


@end
