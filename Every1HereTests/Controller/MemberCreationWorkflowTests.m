//
//  MemberCreationTests.m
//  E1H
//
//  Created by Ger O'Sullivan on 1/30/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberCreationWorkflowTests.h"
#import "ParseDotComManager.h"
#import "ParseDotComManagerDelegate.h"
#import "ParseDotComCommunicatorDelegate.h"
#import "MockParseDotComCommunicator.h"
#import "MockParseDotComManagerDelegate.h"
#import "Event.h"
#import "EventBuilder.h"
#import "FakeMemberBuilder.h"
#import "User.h"


static NSString *eventJSONString = @"{"
@"\"results\": ["
@"{"
@"\"status\": \"upcoming\","
@"\"visibility\": \"public\","
@"\"maybe_rsvp_count\": 0,"
@"\"venue\": {"
@"\"id\": 5358342,"
@"\"zip\": \"19102\","
@"\"lon\": -75.167343,"
@"\"repinned\": false,"
@"\"name\": \"The Watermark at Logan Square\","
@"\"state\": \"PA\","
@"\"address_1\": \"2 Franklin Town Boulevard\","
@"\"lat\": 39.956944,"
@"\"city\": \"Philadelphia\","
@"\"country\": \"us\""
@"},"
@"\"id\": \"drpkmcyrdbjb\","
@"\"utc_offset\": -18000000,"
@"\"duration\": 5400000,"
@"\"time\": 1360197000000,"
@"\"waitlist_count\": 0,"
@"\"updated\": 1355513111000,"
@"\"created\": 1327544938000,"
@"\"yes_rsvp_count\": 4,"
@"\"event_url\": \"http://www.meetup.com/Panorama-Toastmasters/events/97480122/\","
@"\"description\": \"<p>All members and guests welcome. We meet on the 4th floor just sign in at the front desk. For more info: <a href='http://panoramatoastmasters.org/'>panoramatoastmasters.org</a></p>\","
@"\"name\": \"Regular Meeting (1st Wed of Month)\","
@"\"headcount\": 0,"
@"\"group\": {"
@"\"id\": 3169852,"
@"\"group_lat\": 39.959999084472656,"
@"\"name\": \"Panorama Toastmasters\","
@"\"group_lon\": -75.19999694824219,"
@"\"join_mode\": \"open\","
@"\"urlname\": \"Panorama-Toastmasters\","
@"\"who\": \"Toastmasters\""
@"}"
@"}"
@"],"
@"\"meta\": {"
@"\"lon\": \"\","
@"\"count\": 1,"
@"\"signed_url\": \"http://api.meetup.com/2/events?status=upcoming&order=time&group_urlname=Panorama-Toastmasters&desc=false&offset=0&format=json&page=1&fields=&sig_id=36557242&sig=5d658339b4daa542d427d7736166d70d740e479b\","
@"\"link\": \"https://api.meetup.com/2/events\","
@"\"next\": \"https://api.meetup.com/2/events?key=c45e311a1b4f526d623c5b2f732e3&status=upcoming&order=time&group_urlname=Panorama-Toastmasters&desc=false&offset=1&format=json&page=1&fields=&sign=true\","
@"\"total_count\": 24,"
@"\"url\": \"https://api.meetup.com/2/events?key=c45e311a1b4f526d623c5b2f732e3&status=upcoming&order=time&group_urlname=Panorama-Toastmasters&desc=false&offset=0&format=json&page=1&fields=&sign=true\","
@"\"id\": \"\","
@"\"title\": \"Meetup Events v2\","
@"\"updated\": 1355513111000,"
@"\"description\": \"Access Meetup events using a group, member, or event id. Events in private groups are available only to authenticated members of those groups. To search events by topic or location, see [Open Events](/meetup_api/docs/2/open_events).\","
@"\"method\": \"Events\","
@"\"lat\": \"\""
@"}"
@"}";



//static NSString *stringIsNotJSON = @"Not JSON";
//static NSString *noEventsJSONString = @"{ \"noresults\": true }";
//static NSString *emptyEventsArray = @"{ \"results\": [{}] }";


@implementation MemberCreationWorkflowTests
{
@private
    ParseDotComManager *pdcMgr;
    MockParseDotComManagerDelegate *delegate;
    MockParseDotComCommunicator *communicator;
    EventBuilder *eventBuilder;
    FakeMemberBuilder *memberBuilder;
    Event *event;
   // EventBuilder *eventBuilder;
    Venue *venue;
    Group *group;
    User *user;
    NSError *underlyingError;
    NSArray *membersArray;
    NSArray *eventsArray;
    
    NSDictionary *dictIsNotJSON;
    NSDictionary *dictNoJSON;
    NSDictionary *dictFakeJSON;

    NSDictionary *dictWithEmptyArray;
    NSDictionary *dictJSONEvent;
    NSData *jsonDataString;
    NSString *jsonString;
}


- (void)setUp {
    pdcMgr = [[ParseDotComManager alloc] init];
    delegate = [[MockParseDotComManagerDelegate alloc] init];
    pdcMgr.eventDelegate = delegate;
    pdcMgr.memberDelegate = delegate;
    communicator = [[MockParseDotComCommunicator alloc] init];
    pdcMgr.communicator = communicator;
    underlyingError = [NSError errorWithDomain: @"Test domain" code: 0 userInfo: nil];
    eventBuilder = [[EventBuilder alloc] init];
    
    memberBuilder = [[FakeMemberBuilder alloc] init];
    memberBuilder.arrayToReturn = nil;
    pdcMgr.memberBuilder = memberBuilder;
    user = [[User alloc] initWithDisplayName:@"Ger O'Sullivan" avatarLocation:nil slType:NONE];
    [user addRole:@"MemberRole"];
    membersArray = [NSArray arrayWithObject:user];
    
    
    group = event.group;
    venue = event.venue;
    
    jsonDataString = [eventJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    if (!jsonDataString) {
        NSLog(@"NSJSONSerialization failed %@", error);
    }
    
    dictIsNotJSON = @{@"Not JSON" : @"results",};
    dictNoJSON = @{@"Not JSON" : @"results",};
    dictFakeJSON = @{@"Fake JSON" : @"results",};
    
    dictWithEmptyArray = @{@"[]" : @"results",};
    dictJSONEvent = [NSJSONSerialization JSONObjectWithData:jsonDataString options:kNilOptions error:&error];
    event = [[eventBuilder eventsFromJSON:dictJSONEvent error:NULL] objectAtIndex:0];
    
}

- (void)tearDown {
    pdcMgr = nil;
    eventBuilder = nil;
    event = nil;
    group = nil;
    venue = nil;
    membersArray = nil;
    eventsArray = nil;
    underlyingError = nil;
    memberBuilder = nil;
    user = nil;
    communicator = nil;
    delegate = nil;
    
    
    dictIsNotJSON = nil;
    dictNoJSON = nil;
    jsonDataString = nil;
    dictJSONEvent = nil;
    dictWithEmptyArray = nil;
    dictFakeJSON = nil;

}

- (void)testNonConformingObjectCannotBeEventDelegate {
    STAssertThrows(pdcMgr.eventDelegate = (id <EventManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as doesn't conform to the delegate protocol.");
}

//- (void)testNonConformingObjectCannotBeMemberDelegate {
//    STAssertThrows(pdcMgr.memberDelegate = (id <MemberManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as doesn't conform to the delegate protocol.");
//}

- (void)testConformingObjectCanBeEventDelegate {
    id <EventManagerDelegate, MemberManagerDelegate> _delegate = [[MockParseDotComManagerDelegate alloc] init];
    STAssertNoThrow(pdcMgr.eventDelegate = _delegate, @"object conforming to the event delegate protocol should be used as the delegate.");
}


- (void)testConformingObjectCanBeMemberDelegate {
    id <EventManagerDelegate, MemberManagerDelegate> _delegate = [[MockParseDotComManagerDelegate alloc] init];
    STAssertNoThrow(pdcMgr.memberDelegate = _delegate, @"object conforming to the member delegate protocol should be used as the delegate.");
}

- (void)testManagerAcceptsNilAsEventDelegate {
    STAssertNoThrow(pdcMgr.eventDelegate = nil, @"It should be acceptable to use nil as the object's delegate.");
}

- (void)testManagerAcceptsNilAsMemberDelegate {
    STAssertNoThrow(pdcMgr.memberDelegate = nil, @"It should be acceptable to use nil as the object's delegate.");
}

//- (void)testAskingForMembersMeansRequestingData {
//    [pdcMgr fetchMembersForEvent:event];
//    STAssertTrue([communicator wasAskedToFetchMembers], @"The communicator should need to fetch member data.");
//
//}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator {
    [pdcMgr fetchingMembersFailedWithError: underlyingError];
    STAssertFalse(underlyingError == [delegate fetchError], @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError {
    [pdcMgr fetchingMembersFailedWithError: underlyingError];
    STAssertEqualObjects([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], underlyingError, @"The underlying error should be available to client code");
}

- (void)testMembersJSONIsPassedToMemberBuilder {
    [pdcMgr receivedMembersJSON: dictFakeJSON];
    STAssertEqualObjects(memberBuilder.JSON, dictFakeJSON, @"Downloaded JSON is sent to the builder");
}

- (void)testDelegateNotifiedOfErrorWhenMemberBuilderFails {
    memberBuilder.errorToSet = underlyingError;
    [pdcMgr receivedMembersJSON: dictFakeJSON];
    STAssertNotNil([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], @"The delegate should have found out about the error");
}

- (void)testDelegateNotToldAboutErrorWhenQuestionsReceived {
    memberBuilder.arrayToReturn = membersArray;
    [pdcMgr receivedMembersJSON: dictFakeJSON];
    STAssertNil([delegate fetchError], @"No error should be received on success");
}

- (void)testDelegateReceivesTheQuestionsDiscoveredByManager {
    memberBuilder.arrayToReturn = membersArray;
    [pdcMgr receivedMembersJSON: dictFakeJSON];
    STAssertEqualObjects([delegate fetchedMembers], membersArray, @"The manager should have sent its members to the delegate");
}

- (void)testEmptyArrayIsPassedToDelegate {
    memberBuilder.arrayToReturn = [NSArray array];
    [pdcMgr receivedMembersJSON: dictFakeJSON];
    STAssertEqualObjects([delegate fetchedMembers], [NSArray array], @"Returning an empty array is not an error");
}

- (void)testDelegateNotifiedOfFailureToFetchQuestion {
    [pdcMgr fetchingMembersFailedWithError: underlyingError];
    STAssertNotNil([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], @"Delegate should have found out about this error");
}

@end
