//
//  UserBuilderTests.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "UserBuilderTests.h"
#import "MemberBuilder.h"
#import "MemberRole.h"
#import "GuestBuilder.h"
#import "GuestRole.h"
#import "User.h"
#import "SocialNetworkUtilities.h"


static NSString *parseDotComUserJSONString = @"{"
@"\"results\": ["
@"{"
@"\"firstName\":\"Ger\","
@"\"lastName\":\"O'Sullivan\","
@"}"
@"]"
@"}";



static NSString *meetupDotComUserJSONString = @"{"
@"\"results\": ["
@"{"
@"\"name\":\"Ger O'Sullivan\","
@"\"photo\": {"
@"\"photo_link\": \"http://photos2.meetupstatic.com/photos/member/8/c/2/a/member_81575882.jpeg\","
@"\"thumb_link\": \"http://photos4.meetupstatic.com/photos/member/8/c/2/a/thumb_81575882.jpeg\","
@"\"photo_id\": 81575882"
@"},"
@"}"
@"]"
@"}";


@implementation UserBuilderTests
{
    NSDictionary *dictIsNotJSON;
    NSDictionary *dictNoJSON;
    NSDictionary *dictWithEmptyArray;
    NSDictionary *dictJSONParseDotComMember;
    NSDictionary *dictJSONMeetupDotComMember;
    NSData *jsonDataString;
    NSString *jsonString;
    SocialNetworkType slType;
}



//static NSString *stringIsNotJSON = @"Not JSON";
//static NSString *noUsersJSONString = @"{ \"noresults\": true }";
//static NSString *emptyUsersArray = @"{ \"results\": [{}] }";

- (void)setUp {
    
    jsonDataString = [parseDotComUserJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    if (!jsonDataString) {
        NSLog(@"NSJSONSerialization failed %@", error);
    }
    
    dictJSONParseDotComMember = [NSJSONSerialization JSONObjectWithData:jsonDataString options:kNilOptions error:&error];
    

    jsonDataString = [meetupDotComUserJSONString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonDataString) {
        NSLog(@"NSJSONSerialization failed %@", error);
    }
    dictJSONMeetupDotComMember = [NSJSONSerialization JSONObjectWithData:jsonDataString options:kNilOptions error:&error];
    
    dictIsNotJSON = @{@"Not JSON" : @"results",};
    dictNoJSON = @{@"Not JSON" : @"results",};
    dictWithEmptyArray = @{@"[]" : @"results",};
    
    memberBuilder = [[MemberBuilder alloc] init];
    userMember = [[memberBuilder membersFromJSON:dictJSONParseDotComMember error:NULL] objectAtIndex:0];
    
    slType = Meetup;
    guestBuilder = [[GuestBuilder alloc] init];
    userGuest = [[guestBuilder usersFromJSON:dictJSONMeetupDotComMember socialNetworkType:slType error:NULL] objectAtIndex:0];
}

- (void)tearDown {
    memberBuilder = nil;
    userMember = nil;
    userGuest = nil;
    dictIsNotJSON = nil;
    dictNoJSON = nil;
    jsonDataString = nil;
    dictJSONMeetupDotComMember = nil;
    dictJSONParseDotComMember = nil;
    dictWithEmptyArray = nil;
}


- (void)testThatMembersNilIsNotAnAcceptableParameter {
    STAssertThrows([memberBuilder membersFromJSON: nil error: NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testNilMembersReturnedWhenStringIsNotJSON {
    STAssertNil([memberBuilder membersFromJSON: dictIsNotJSON error: NULL], @"This parameter should not be parsable");
}

- (void)testErrorSetWhenMembersStringIsNotJSON {
    NSError *error = nil;
    [memberBuilder membersFromJSON: dictIsNotJSON error: &error];
    STAssertNotNil(error, @"An error occurred, we should be told");
}


- (void)testPassingMembersNullErrorDoesNotCauseCrash {
    STAssertNoThrow([memberBuilder membersFromJSON: dictIsNotJSON error: NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testRealJSONWithoutMembersArrayIsError {
    STAssertNil([memberBuilder membersFromJSON: dictNoJSON error: NULL], @"No members to parse in this JSON");
}

- (void)testRealJSONWithoutMembersReturnsMissingDataError {
    NSError *error = nil;
    [memberBuilder membersFromJSON: dictNoJSON error: &error];
    STAssertEquals([error code], MemberBuilderMissingDataError, @"This case should not be an invalid JSON error");
}

- (void)testJSONWithOneMemberReturnsOneMemberObject {
    NSError *error = nil;
    NSArray *members = [memberBuilder membersFromJSON: dictJSONParseDotComMember error: &error];
    STAssertEquals([members count], (NSUInteger)1, @"The builder should have created a Member");
}

- (void)testMemberCreatedFromJSONHasPropertiesPresentedInJSON {
    STAssertEqualObjects(userMember.firstName, @"Ger", @"The first name should match the data we sent");
    STAssertEqualObjects(userMember.lastName, @"O'Sullivan", @"The last name should match the data we sent");
    STAssertEqualObjects(userMember.displayName, @"Ger O'Sullivan", @"The display name should match the data we sent");
    
    STAssertTrue([[userMember getRole:@"MemberRole"] isMemberOfClass:NSClassFromString(@"MemberRole")], @"The user member role should be of type 'MemberRole'");
    
    STAssertFalse([[userMember getRole:@"MemberRole"] isMemberOfClass:NSClassFromString(@"GuestRole")], @"The user member role should not be of type 'GuestRole'");
}


- (void)testMemberCreatedFromEmptyObjectIsStillValidObject {
    NSArray *members = [memberBuilder membersFromJSON: dictWithEmptyArray error: NULL];
    STAssertEquals([members count], (NSUInteger)0, @"MemberBuilder must handle partial input");
}


/******** Guest Test Units ***************/


- (void)testThatGuestsNilIsNotAnAcceptableParameter {
    STAssertThrows([guestBuilder usersFromJSON:nil socialNetworkType:slType error: NULL], @"Lack of data should have been handled elsewhere");
}

- (void)testGuestsNilReturnedWhenStringIsNotJSON {
    STAssertNil([guestBuilder usersFromJSON:dictIsNotJSON socialNetworkType:slType error: NULL], @"This parameter should not be parsable");
}

- (void)testErrorSetWhenGuestsStringIsNotJSON {
    NSError *error = nil;
    [guestBuilder usersFromJSON: dictIsNotJSON socialNetworkType:slType error: &error];
    STAssertNotNil(error, @"An error occurred, we should be told");
}


- (void)testPassingGuestsNullErrorDoesNotCauseCrash {
    STAssertNoThrow([guestBuilder usersFromJSON: dictIsNotJSON socialNetworkType:slType error: NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testRealJSONWithoutGuestsArrayIsError {
    STAssertNil([guestBuilder usersFromJSON:dictNoJSON socialNetworkType:slType error:NULL], @"No guests to parse in this JSON");
}

- (void)testRealJSONWithoutGuestsReturnsMissingDataError {
    NSError *error = nil;
    [guestBuilder usersFromJSON:dictNoJSON socialNetworkType:slType error:&error];
    STAssertEquals([error code], MemberBuilderMissingDataError, @"This case should not be an invalid JSON error");
}

- (void)testJSONWithOneGuestReturnsOneGuestObject {
    NSError *error = nil;
    NSArray *members = [guestBuilder usersFromJSON:dictJSONMeetupDotComMember socialNetworkType:slType error:&error];
    STAssertEquals([members count], (NSUInteger)1, @"The builder should have created a guest.");
}

- (void)testGuestCreatedFromJSONHasPropertiesPresentedInJSON {
    STAssertEqualObjects(userGuest.displayName, @"Ger O'Sullivan", @"The display name should match the data we sent");
    
    STAssertTrue([[userGuest getRole:@"GuestRole"] isMemberOfClass:NSClassFromString(@"GuestRole")], @"The user guest role should be of type 'GuestRole'");
    
    STAssertFalse([[userGuest getRole:@"GuestRole"] isMemberOfClass:NSClassFromString(@"MemberRole")], @"The user guest role should not be of type 'GuestRole'");
}

- (void)testGuestCreatedFromEmptyObjectIsStillValidObject {
    NSArray *guests = [guestBuilder usersFromJSON: dictWithEmptyArray socialNetworkType:slType error: NULL];
    STAssertEquals([guests count], (NSUInteger)0, @"guestBuilder must handle partial input");
}

@end
