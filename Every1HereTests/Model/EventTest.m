//
//  EventTest.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/16/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventTest.h"
#import "Event.h"
#import "Group.h"
#import "Venue.h"
#import "Address.h"
#import "User.h"

@implementation EventTest
{
    Event *event;
    Group *group;
    Venue *venue;
    Address *address;

}

- (void)setUp
{
    /* Event setup */
    event = [[Event alloc] init];
    event.time = 1360197000000;
    event.duration = @5400000;
    event.utc_offset = @-18000000;
    event.eventId = @"drpkmcyrdbjb";
    event.status = @"upcoming";
    event.name = @"Regular Meeting (3rd Wednesday of Month)";
    event.maybe_rsvp_count = @0;
    event.yes_rsvp_count = @4;
    event.headcount = @0;
    
    NSTimeInterval timeIntervalStart = (event.time + [event.utc_offset doubleValue])/1000; // convert millisecs to seconds;
    NSTimeInterval timeIntervalEnd = (event.time + [event.utc_offset doubleValue] + [event.duration doubleValue])/1000;  // convert millisecs to seconds;

    event.startDateTime = [NSDate dateWithTimeIntervalSince1970:timeIntervalStart];
    event.endDateTime =  [NSDate dateWithTimeIntervalSince1970:timeIntervalEnd];
    
    
    /* Group setup */
    group = [[Group alloc] init];
    group.name = @"Panorama Toastmasters";
    group.groupId = @7654321;
    group.urlName = @"Panorama+Toastmasters";

    
    /* Venue setup */
    venue = [[Venue alloc] init];
    venue.venueId = @987654;
    venue.name = @"The Watermark at Logan Square";
    
    address = [[Address alloc] init];
    
    address.address1 = @"2 Franklin Town Boulevard";
    address.city = @"Philadelphia";
    address.state = @"PA";
    address.zip = @"19102";
    address.country = @"us";
    address.lat = @39.956944;
    address.lon = @-75.167343;
    
    venue.address = address;
    
    event.venue = venue;
    event.group = group;
    
    
}

- (void)tearDown
{
    event = nil;
    group = nil;
    venue = nil;
    address = nil;
}

- (void)testThatEventExists
{
    STAssertNotNil(event,@"should be able to create a Event instance");
}

- (void)testThatEventCanBeNamed
{

    STAssertEqualObjects(event.name, @"Regular Meeting (3rd Wednesday of Month)",
                         @"the Event should have the name I gave it");
}

- (void)testThatEventHasStatus
{
    STAssertEqualObjects(event.status, @"upcoming", @"Events need to have a status.");
}


- (void)testForAListOfMembers
{
    STAssertTrue([[event allMembers] isKindOfClass:
                  [NSArray class]],
                 @"Events should provide a list of all members");
}

- (void)testForAListOfGuests
{
    STAssertTrue([[event allGuests] isKindOfClass:
                  [NSArray class]],
                 @"Events should provide a list of all guests");
}

- (void)testEventHasATime
{
    NSTimeInterval timeInterval = 1360197000000;
    STAssertEquals(event.time, timeInterval, @"Events need to have a time.");
}

- (void)testEventHasAStatus
{
    STAssertEquals(event.status, @"upcoming", @"Events need to have a status.");
}

- (void)testEventHasADuration
{
    STAssertEqualObjects(event.duration, @5400000, @"Events need to have a duration.");
}

- (void)testEventHasAUTCOffset
{
    STAssertEqualObjects(event.utc_offset, @-18000000, @"Events need to have a utc_offet.");
}

- (void)testEventHasAYesRSVPCount
{
    STAssertEqualObjects(event.yes_rsvp_count, @4, @"Events need to have a yes_rsvp_count.");
}

- (void)testEventHasAMaybeRSVPCount
{
    STAssertEqualObjects(event.maybe_rsvp_count, @0, @"Events need to have a maybe_rsvp_count.");
}

- (void)testEventHasAHeadCount
{
    STAssertEqualObjects(event.headcount, @0, @"Events need to have a headcount.");
}

- (void)testEventHasAStartDate {
    NSTimeInterval timeIntervalStart = (event.time + [event.utc_offset doubleValue])/1000; // convert millisecs to seconds;
    STAssertEqualObjects(event.startDateTime, [NSDate dateWithTimeIntervalSince1970:timeIntervalStart], @"Event needs to provide its start date");
}

- (void)testEventHasAEndDate {
        NSTimeInterval timeIntervalEnd = (event.time + [event.utc_offset doubleValue] + [event.duration doubleValue])/1000;  // convert millisecs to seconds;
    STAssertEqualObjects(event.endDateTime, [NSDate dateWithTimeIntervalSince1970:timeIntervalEnd], @"Event needs to provide its end date");
}


- (void)testEventStartDateTimeIsGreaterThanEndDateTime {
}


//- (void)testMembersAreOrderedLastNameAlphabetically {
//    
//    User *memberA = nil;
//    User *memberB = nil;
//    NSArray *members = nil;
//    
//    memberA = [[User alloc] initWithFirstName:@"Ger" lastName:@"O'Sullivan" avatarLocation:nil objectId:nil userId:nil eventId:nil slType:NONE];
//    memberB = [[User alloc] initWithFirstName:@"Harry" lastName:@"Albert" avatarLocation:nil objectId:nil userId:nil eventId:nil slType:NONE];
//    
//    [memberA addRole:@"MemberRole"];
//    [memberB addRole:@"MemberRole"];
//    
//    [event addMember:memberA];
//    [event addMember:memberB];
//    memberA = nil;
//    memberB = nil;
//    
//    members = [event allMembers];
//    User *listedFirst = members[0];
//    User *listedSecond = members[1];
//    
//    STAssertTrue([listedFirst.lastName compare: listedSecond.lastName options:NSCaseInsensitiveSearch] < 0, @"The listed first should appear first.");
//}
//

@end
