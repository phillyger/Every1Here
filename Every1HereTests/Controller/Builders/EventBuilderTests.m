//
//  EventBuilderTests.m
//  E1H
//
//  Created by Ger O'Sullivan on 1/19/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventBuilderTests.h"
#import "EventBuilder.h"
#import "Event.h"
#import "Group.h"
#import "Venue.h"
#import "Address.h"


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

static NSString *eventEmptyJSONString = @"{\"results\":[]}";

//static NSString *dictIsNotJSON = @"Not JSON";
//static NSString *dictNoJSON = @"{ \"noresults\": true }";
//static NSString *emptyEventsArray = @"{ \"results\": [] }";





@implementation EventBuilderTests
{
    EventBuilder *eventBuilder;
    Event *event;
    Venue *venue;
    Group *group;
   
    NSDictionary *dictIsNotJSON;
    NSDictionary *dictNoJSON;
    NSDictionary *dictWithEmptyArray;
    NSDictionary *dictJSONEvent;
    NSData *jsonDataString;
    NSString *jsonString;

    
    
}

- (void)setUp {
    eventBuilder = [[EventBuilder alloc] init];
    
    jsonDataString = [eventJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    if (!jsonDataString) {
        NSLog(@"NSJSONSerialization failed %@", error);
    }
    
    dictJSONEvent = [NSJSONSerialization JSONObjectWithData:jsonDataString options:kNilOptions error:&error];

    
    event = [[eventBuilder eventsFromJSON:dictJSONEvent error:NULL] objectAtIndex:0];
    
    group = event.group;
    venue = event.venue;
    
    dictIsNotJSON = @{@"Not JSON" : @"results",};
    dictNoJSON = @{@"Not JSON" : @"results",};
    dictWithEmptyArray = @{@"[]" : @"results",};

}

- (void)tearDown {
    eventBuilder = nil;
    event = nil;
    group = nil;
    venue = nil;
    dictIsNotJSON = nil;
    dictNoJSON = nil;
    jsonDataString = nil;
    dictJSONEvent = nil;
    dictWithEmptyArray = nil;
    
}



- (void)testThatNilIsNotAnAcceptableParameter {
    STAssertThrows([eventBuilder eventsFromJSON: nil error: NULL], @"Lack of data should have been handled elsewhere");
}


- (void)testNilReturnedWhenDictIsNotJSON {
    STAssertNil([eventBuilder eventsFromJSON: dictIsNotJSON error: NULL], @"This parameter should not be parsable");
}

- (void)testErrorSetWhenDictIsNotJSON {
    NSError *error = nil;
    [eventBuilder eventsFromJSON:dictIsNotJSON error: &error];
    STAssertNotNil(error, @"An error occurred, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash {
    STAssertNoThrow([eventBuilder eventsFromJSON: dictIsNotJSON error: NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testRealJSONWithoutEventsArrayIsError {
    STAssertNil([eventBuilder eventsFromJSON:dictNoJSON error:NULL], @"No events to parse in this JSON");
}

- (void)testRealJSONWithoutEventsReturnsMissingDataError {
    NSError *error = nil;
    [eventBuilder eventsFromJSON: dictNoJSON error: &error];
    STAssertEquals([error code], EventBuilderMissingDataError, @"This case should not be an invalid JSON error");
}

- (void)testJSONWithOneEventReturnsOneEventObject {
    NSError *error = nil;
    NSArray *events = [eventBuilder eventsFromJSON: dictJSONEvent error: &error];
    STAssertEquals([events count], (NSUInteger)1, @"The builder should have created an event");
}

- (void)testEventCreatedFromJSONHasPropertiesPresentedInJSON {
    STAssertEqualObjects(event.eventId, @"drpkmcyrdbjb", @"The event ID should match the data we sent");
    STAssertEquals([event.startDateTime timeIntervalSince1970], (NSTimeInterval)((1360197000000+(-18000000))/1000), @"The start date of the event should match the data");
    STAssertEquals([event.endDateTime timeIntervalSince1970], (NSTimeInterval)((1360197000000+(-18000000)+5400000)/1000), @"The start date of the event should match the data");
    STAssertEqualObjects(event.name, @"Regular Meeting (1st Wed of Month)", @"Name should match the provided data");
    STAssertEqualObjects(event.status, @"upcoming", @"Status should match the provided data");
 
    
    STAssertEqualObjects(group.name, @"Panorama Toastmasters", @"Group name should indicate Panorama Toastmasters.");
    STAssertEqualObjects(group.urlName, @"Panorama-Toastmasters", @"Group Meetup URL Name should match.");
    STAssertEqualObjects(group.groupId, @3169852, @"Group Meetup ID should match.");
    
        
    
    STAssertEqualObjects(venue.venueId, @5358342, @"Venue Meetup ID should match.");
    STAssertEqualObjects(venue.name, @"The Watermark at Logan Square", @"Venue name should match.");
    STAssertEqualObjects(venue.address.address1, @"2 Franklin Town Boulevard", @"Venue address_1 should match.");
    STAssertEqualObjects(venue.address.city, @"Philadelphia", @"Venue city should match.");
    STAssertEqualObjects(venue.address.state, @"PA", @"Venue state should match.");
    STAssertEqualObjects(venue.address.zip, @"19102", @"Venue zip should match.");
    STAssertEqualObjects(venue.address.country, @"us", @"Venue country should match.");
}

- (void)testEventCreatedFromEmptyObjectIsStillValidObject {
//    jsonDataString = [eventEmptyJSONString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    if (!jsonDataString) {
//        NSLog(@"NSJSONSerialization failed %@", error);
//    }
//    
    NSArray *events = [eventBuilder eventsFromJSON: dictWithEmptyArray error: NULL];
    STAssertEquals([events count], (NSUInteger)0, @"eventBuilder must handle partial input");
}



@end
