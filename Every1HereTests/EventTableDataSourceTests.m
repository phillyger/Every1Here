//
//  EventTableDataSourceTests.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventTableDataSourceTests.h"
#import "EventListTableDataSource.h"
#import "EventCell.h"
#import "Event.h"
#import "Group.h"
#import "Venue.h"
#import "Address.h"

@implementation EventTableDataSourceTests
{
    EventListTableDataSource *dataSource;
    NSArray *eventsList;
}


- (void)setUp {
    dataSource = [[EventListTableDataSource alloc] init];
    Event *event = [[Event alloc] init];
    event.group = [[Group alloc] initWithName:@"Panorama Toastmasters"];
    Address *address = [[Address alloc] initWithAddress:@"123 Main St" city:@"Philadelphia" state:@"PA" zip:@"19146" country:@"US" lat:nil lon:nil];
    event.name = @"Regular Meeting (3rd Wednesday of Month)";
    event.venue = [[Venue alloc] initWithName:@"The Watermark" address:address];
    event.status = @"upcoming";
    event.startDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:(1361406600000/1000)];
    event.endDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:((1361406600000 + 5400000)/1000) ];
    
    eventsList = [NSArray arrayWithObject:event];
    [dataSource setEvents:eventsList];
}

- (void)tearDown {
    dataSource = nil;
    eventsList = nil;

}

- (void)testEventDataSourceCanReceiveAListOfEvents {

    STAssertNoThrow([dataSource setEvents:eventsList], @"The data source needs a list of events");
}

- (void)testOneTableRowForOneEvent {
    STAssertEquals((NSInteger)[eventsList count], [dataSource tableView: nil numberOfRowsInSection: 0], @"As there's one topic, there should be one row in the table");
}

- (void)testTwoTableRowsForTwoEvents {
    Event *event1 = [[Event alloc] init];
    event1.group = [[Group alloc] initWithName:@"Panorama Toastmasters"];
    Address *address = [[Address alloc] initWithAddress:@"123 Main St" city:@"Philadelphia" state:@"PA" zip:@"19146" country:@"US" lat:nil lon:nil];
    event1.venue = [[Venue alloc] initWithName:@"The Watermark" address:address];
    event1.status = @"upcoming";
    event1.startDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:(1361406600000/1000)];
    event1.endDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:((1361406600000 + 5400000)/1000) ];
    
    Event *event2 = [[Event alloc] init];
    event2.group = [[Group alloc] initWithName:@"Panorama Toastmasters"];
    event2.venue = [[Venue alloc] initWithName:@"The Watermark" address:address];
    event2.status = @"upcoming";
    event2.startDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:(1363822200000/1000)];
    event2.endDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:((1363822200000 + 5400000)/1000) ];
    

    NSArray *twoEventsList = [NSArray arrayWithObjects: event1, event2, nil];
    [dataSource setEvents: twoEventsList];
    STAssertEquals((NSInteger)[twoEventsList count], [dataSource tableView: nil numberOfRowsInSection: 0], @"There should be two rows in the table for two events");
}

- (void)testOneSectionInTheTableView {
    STAssertThrows([dataSource tableView: nil numberOfRowsInSection: 1], @"Data source doesn't allow asking about additional sections");
}

- (void)testDataSourceCellCreationExpectsOneSection {
    NSIndexPath *secondSection = [NSIndexPath indexPathForRow: 0 inSection: 1];
    STAssertThrows([dataSource tableView: nil cellForRowAtIndexPath: secondSection], @"Data source will not prepare cells for unexpected sections");
}

- (void)testDataSourceCellCreationWillNotCreateMoreRowsThanItHasEvents {
    NSIndexPath *afterLastEvent = [NSIndexPath indexPathForRow: [eventsList count] inSection: 0];
    STAssertThrows([dataSource tableView: nil cellForRowAtIndexPath: afterLastEvent], @"Data source will not prepare more cells than there are events.");
}
//
//- (void)testCellCreatedByDataSourceContainsEventNameAsTitleLabel {
//    NSIndexPath *firstEvent = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    EventCell *firstCell = (EventCell *)[dataSource tableView: nil cellForRowAtIndexPath: firstEvent];
//    NSString *cellTitle = firstCell.titleLabel.text;
//    STAssertEqualObjects(@"Regular Meeting (3rd Wednesday of Month)", cellTitle, @"Cell's title should be equal to the event's title");
//}
//
//- (void)testCellCreatedByDataSourceContainsGroupNameAsGroupLabel {
//    NSIndexPath *firstEvent = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    EventCell *firstCell = (EventCell *)[dataSource tableView: nil cellForRowAtIndexPath: firstEvent];
//    NSString *cellGroup = firstCell.groupLabel.text;
//    STAssertEqualObjects(@"Panorama Toastmasters", cellGroup, @"Cell's group name should be equal to the event's group label");
//}
//
//- (void)testCellCreatedByDataSourceContainsDayAsDayLabel {
//    NSIndexPath *firstEvent = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    EventCell *firstCell = (EventCell *)[dataSource tableView: nil cellForRowAtIndexPath: firstEvent];
//    NSString *cellDay = firstCell.dayLabel.text;
//    STAssertEqualObjects(@"WED", cellDay, @"Cell's day should be equal to the event's day");
//}
//
//
//- (void)testCellCreatedByDataSourceContainsMonthAsMonthLabel {
//    NSIndexPath *firstEvent = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    EventCell *firstCell = (EventCell *)[dataSource tableView: nil cellForRowAtIndexPath: firstEvent];
//    NSString *cellMonth = firstCell.monthLabel.text;
//    STAssertEqualObjects(@"FEB", cellMonth, @"Cell's abbreviated month should be equal to the event's abbreviated month");
//}
//
//- (void)testCellCreatedByDataSourceContainsStartTimeAsStartTimeLabel {
//    NSIndexPath *firstEvent = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    EventCell *firstCell = (EventCell *)[dataSource tableView: nil cellForRowAtIndexPath: firstEvent];
//    NSString *cellStartTime = firstCell.starttimeLabel.text;
//    STAssertEqualObjects(@"07:30 PM", cellStartTime, @"Cell's abbreviated month should be equal to the event's abbreviated month");
//}

@end
