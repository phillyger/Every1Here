//
//  EventTableDelegateTests.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/10/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventTableDelegateTests.h"
#import "EventListTableDataSource.h"
#import "Event.h"
#import "Group.h"
#import "Venue.h"
#import "Address.h"

@implementation EventTableDelegateTests {
    NSNotification *receivedNotification;
    EventListTableDataSource *dataSource;
    Event *event;
}

- (void)setUp {
    dataSource = [[EventListTableDataSource alloc] init];
    event = [[Event alloc] init];
    event.group = [[Group alloc] initWithName:@"Panorama Toastmasters"];
    Address *address = [[Address alloc] initWithAddress:@"123 Main St" city:@"Philadelphia" state:@"PA" zip:@"19146" country:@"US" lat:nil lon:nil];
    event.name = @"Regular Meeting (3rd Wednesday of Month)";
    event.venue = [[Venue alloc] initWithName:@"The Watermark" address:address];
    event.status = @"upcoming";
    event.startDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:(1361406600000/1000)];
    event.endDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:((1361406600000 + 5400000)/1000) ];

    [dataSource setEvents: [NSArray arrayWithObject: event]];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didReceiveNotification:) name: EventListTableDidSelectEventNotification object: nil];
}

- (void)tearDown {
    receivedNotification = nil;
    dataSource = nil;
    event = nil;
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)didReceiveNotification: (NSNotification *)note {
    receivedNotification = note;
}

- (void)testDelegatePostsNotificationOnSelectionShowingWhichEventWasSelected {
    NSIndexPath *selection = [NSIndexPath indexPathForRow: 0 inSection: 0];
    [dataSource tableView: nil didSelectRowAtIndexPath: selection];
    STAssertEqualObjects([receivedNotification name], @"EventListTableDidSelectEventNotification", @"The delegate should notify that a event was selected");
    STAssertEqualObjects([receivedNotification object], event, @"The notification should indicate which event was selected");
}

@end
