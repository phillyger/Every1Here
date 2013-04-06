//
//  EventCreationWorkflowTests.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventCreationWorkflowTests.h"
#import "ParseDotComManager.h"
#import "ParseDotComManagerDelegate.h"
#import "ParseDotComCommunicatorDelegate.h"
#import "MockParseDotComCommunicator.h"
#import "MockParseDotComManagerDelegate.h"
#import "Event.h"
#import "FakeEventBuilder.h"
#import "User.h"
#import "Group.h"

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

static NSString *stringIsNotJSON = @"Not JSON";
static NSString *noEventsJSONString = @"{ \"noresults\": true }";
static NSString *emptyEventsArray = @"{ \"results\": [] }";


@implementation EventCreationWorkflowTests
{
@private
    ParseDotComManager *pdcMgr;
    MockParseDotComManagerDelegate *delegate;
    MockParseDotComCommunicator *communicator;
    Event *event;
    FakeEventBuilder *eventBuilder;
    Venue *venue;
    Group *group;
    User *user;
    NSError *underlyingError;
    NSArray *eventArray;
    
    
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
    eventBuilder = [[FakeEventBuilder alloc] init];
    eventBuilder.arrayToReturn = nil;
    pdcMgr.eventBuilder = eventBuilder;
    group = [[Group alloc] initWithName:@"Panorama Toastmasters" urlName:@"Panorama-Toastmasters"];
    
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
    
}

- (void)tearDown {
    pdcMgr = nil;
    eventBuilder = nil;
    event = nil;
    group = nil;
    venue = nil;
    eventArray = nil;
    underlyingError = nil;
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

- (void)testAskingForEventsMeansRequestingData {
    [pdcMgr fetchPastEventsForGroup:group];
    STAssertTrue([communicator wasAskedToFetchPastEvents], @"The communicator should need to fetch member data.");
    
}

- (void)testDelegateNotifiedOfFailureToGetAnswers {
    [pdcMgr fetchingEventsFailedWithError:underlyingError];
    STAssertEqualObjects([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], underlyingError, @"Delegate should be notified of failure to communicate");
}

- (void)testAnswerResponsePassedToAnswerBuilder {
    [pdcMgr receivedEventsJSON:dictFakeJSON];
    STAssertEqualObjects([eventBuilder JSON],dictFakeJSON, @"Manager must pass response to builder to get events constructed");
}

@end
