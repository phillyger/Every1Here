//
//  EmptyTableViewDataSource.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventListTableDataSource.h"
#import "EventCell.h"
#import "EventHeader.h"
#import "Event.h"
#import "Group.h"
#import "Venue.h"
#import "CommonUtilities.h"

static NSString *eventCellReuseIdentifier = @"eventCell";

@interface EventListTableDataSource ()

- (Event *)eventForIndexPath: (NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) UINib *eventCellNib;

@end

@implementation EventListTableDataSource
{
    NSArray *events;
}
@synthesize eventCell;
@synthesize sections;
@synthesize sectionHeaderTitleList;


- (void)setEvents:(NSArray *)newEvents {
    events = newEvents;
}

- (NSArray *)sortEventArray:(NSArray *)newEvents {
    NSMutableArray *sortedEvents = (NSMutableArray *)[newEvents sortedArrayUsingComparator: ^(id a, id b) {
        Event *first = ( Event* ) a;
        Event *second = ( Event* ) b;
        return [second.startDateTime compare:first.startDateTime];

    }];
    
    return sortedEvents;
            
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    //-------------------------------------------------------
    // Implemented a unique sorting mechanism for Event Section
    // Titles. Format: #|Title
    // In order to remove the # from displaying we extract the
    // second component separated by the |
    //-------------------------------------------------------
    return [self.sectionHeaderTitleList[section] componentsSeparatedByString: @"|"][1];

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.sectionHeaderTitleList count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NSParameterAssert(section == 0);

    NSArray *eventsOnThisDay = [self.sections objectForKey:self.sectionHeaderTitleList[section]];
    return [eventsOnThisDay count];
    
}


- (Event *)eventForIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionName = sectionHeaderTitleList[indexPath.section];
    Event *event = [sections[sectionName] objectAtIndex:indexPath.row];
    return event;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotification *note = [NSNotification notificationWithName: EventListTableDidSelectEventNotification object: [self eventForIndexPath: indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification: note];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSParameterAssert([indexPath section] == 0);
//    NSParameterAssert([indexPath row] < [events count]);
    static NSDateFormatter *dateFormatter = nil;
    
    UITableViewCell *cell = nil;
    if ([events count]) {
         NSString *sectionName = sectionHeaderTitleList[indexPath.section];
        Event *event = [sections[sectionName] objectAtIndex:indexPath.row];
        eventCell = [aTableView dequeueReusableCellWithIdentifier:eventCellReuseIdentifier forIndexPath:indexPath];

        // START NEW
        if (![eventCell.backgroundView isKindOfClass:[EventCell class]]) {
            eventCell.backgroundView = [[EventCell alloc] init];
        }
        
        if (![eventCell.selectedBackgroundView isKindOfClass:[EventCell class]]) {
            eventCell.selectedBackgroundView = [[EventCell alloc] init];
        }
        // END NEW
        
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [self configureEventCellDateFormatter:dateFormatter];
            
        }

        eventCell.titleLabel.text = [event name];
        Group *thisGroup = (Group *)[event group];
        eventCell.groupLabel.text = thisGroup.name;

        
        NSString *formattedDateString = [dateFormatter stringFromDate:[event startDateTime]];
        NSArray *datetimeArray = [formattedDateString componentsSeparatedByString: @"|"];
        NSArray *dateArray =[datetimeArray[0] componentsSeparatedByString: @"-"];
        
        // Setup the Detail and Text labels with the Event's values
        eventCell.dayLabel.text = [dateArray[0] uppercaseString];
        eventCell.monthLabel.text = [dateArray[1] uppercaseString];
        eventCell.dateLabel.text = dateArray[2];
        eventCell.starttimeLabel.text = datetimeArray[1];
        

        eventCell.textLabel.backgroundColor = [UIColor clearColor]; // NEW
        eventCell.dayLabel.backgroundColor = [UIColor clearColor]; // NEW
        eventCell.monthLabel.backgroundColor = [UIColor clearColor]; // NEW
        eventCell.dateLabel.backgroundColor = [UIColor clearColor]; // NEW
        eventCell.starttimeLabel.backgroundColor = [UIColor clearColor]; // NEWLabel
        eventCell.titleLabel.backgroundColor = [UIColor clearColor]; // NEWLabel
        eventCell.groupLabel.backgroundColor = [UIColor clearColor]; // NEWLabel
        
        cell = eventCell;
        eventCell = nil;

        } else {
            cell = [aTableView dequeueReusableCellWithIdentifier:@"placeholder"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeholder"];
            }
//            cell.textLabel.text = @"There was a problem connecting to the network.";
        }

    return cell;
}


- (void)buildEventDict {
    
    NSArray *sectionHeaderTitleUpcomingArray = @[
                                            
                                            @{@"title":@"Today",
                                              @"index": @0},
                                            @{@"title":@"Tomorrow",
                                              @"index": @1},
                                            @{@"title":@"In Two Days",
                                              @"index": @2},
                                            @{@"title":@"Later This Week",
                                              @"index": @3},
                                            @{@"title":@"Next Week",
                                              @"index": @4},
                                            @{@"title":@"In Two Weeks",
                                              @"index": @5},
                                            @{@"title":@"In Three Weeks",
                                              @"index": @6},
                                            @{@"title":@"Next Month",
                                              @"index": @7},
                                            @{@"title":@"In Two Months",
                                              @"index": @8},
                                            @{@"title":@"In The Future...",
                                              @"index": @9},
         
                                            
                                        ];
                                                       
    NSArray *sectionHeaderTitlePastArray = @[
                                                 
                                             @{@"title":@"Today",
                                               @"index": @0},
                                             @{@"title":@"Yesterday",
                                               @"index": @1},
                                             @{@"title":@"Two Days Ago",
                                               @"index": @2},
                                             @{@"title":@"Earlier This Week",
                                               @"index": @3},
                                             @{@"title":@"Last Week",
                                               @"index": @4},
                                             @{@"title":@"Two Weeks Ago",
                                               @"index": @5},
                                             @{@"title":@"Three Weeks Ago",
                                               @"index": @6},
                                             @{@"title":@"Last Month",
                                               @"index": @7},
                                             @{@"title":@"Two Months Ago",
                                               @"index": @8},
                                             @{@"title":@"In The Past...",
                                               @"index": @9},
                                                 
                                                 ];
    

    
    sectionHeaderTitleList = [[NSMutableArray alloc] init];
    sections = [[NSMutableDictionary alloc] init];
    
    NSDate *dateBeginningOfThisDay = [CommonUtilities dateAtBeginningOfDayForDate:[NSDate date]];

    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Event *event = obj;
        
        
        // TODO: Implement better design approach to hardcoding status in.
        
        NSArray *sectionHeaderTitleArray = [[event status] isEqualToString:@"upcoming"] ? sectionHeaderTitleUpcomingArray : sectionHeaderTitlePastArray;
        
        NSDictionary *sectionHeaderDict = [self categorizeEventStartDate:[event startDateTime]
                                                        usingBaseDate:dateBeginningOfThisDay
                                                            withArray:sectionHeaderTitleArray];
        
        NSString *key = [ NSString stringWithFormat:@"%@|%@", [sectionHeaderDict[@"index"] stringValue], sectionHeaderDict[@"title"] ];
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:key];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            // Use the section header title as dictionary key to later retrieve the event list this day
            [self.sections setObject:eventsOnThisDay forKey:key];
        }
        
        // Add the event to the list for this day
        [eventsOnThisDay addObject:event];
        
    }];
    

    
    NSArray *unsortedSections = [self.sections allKeys];
    
    self.sectionHeaderTitleList = [unsortedSections sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
}];
    

    
}
//
//- (NSString *)categorizeEventStartDate:(NSDate *)eventStartDate usingBaseDate:(NSDate *)baseDate withArray:(NSArray*)sectionHeaderTitles {
//    
//    NSString *thisSectionHeaderTitle = nil;
//    NSInteger daysOffset = [self numberOfDaysBetweenBaseDate:baseDate offsetDate:eventStartDate];
//    
//    // Ensure that we are using the absolute value.
//    switch (ABS(daysOffset)) {
//        case 0:
//            thisSectionHeaderTitle = sectionHeaderTitles[0];
//            break;
//        case 1:
//            thisSectionHeaderTitle = sectionHeaderTitles[1];
//            break;
//        case 2:
//            thisSectionHeaderTitle = sectionHeaderTitles[2];
//            break;
//        case 3 ... 7:
//            thisSectionHeaderTitle = sectionHeaderTitles[3];
//            break;
//        case 8 ... 14:
//            thisSectionHeaderTitle = sectionHeaderTitles[4];
//            break;
//        case 15 ... 25:
//            thisSectionHeaderTitle = sectionHeaderTitles[5];
//            break;
//        case 26 ... 31:
//            thisSectionHeaderTitle = sectionHeaderTitles[6];
//            break;
//        case 32 ... 62:
//            thisSectionHeaderTitle = sectionHeaderTitles[7];
//            break;
//        case 63 ... 93:
//            thisSectionHeaderTitle = sectionHeaderTitles[8];
//            break;
//        default:
//            thisSectionHeaderTitle = sectionHeaderTitles[9];
//            break;
//    }
//    
//    return thisSectionHeaderTitle;
//    
//}


- (NSDictionary *)categorizeEventStartDate:(NSDate *)eventStartDate usingBaseDate:(NSDate *)baseDate withArray:(NSArray*)sectionHeaderTitles {
    
    NSDictionary *thisSectionHeaderTitle = [[NSDictionary alloc] init];
    NSInteger daysOffset = [CommonUtilities numberOfDaysBetweenBaseDate:baseDate offsetDate:eventStartDate];
    BOOL weekIsEqual = false;
    
    // Ensure that we are using the absolute value.
    switch (ABS(daysOffset)) {
        case 0:
            thisSectionHeaderTitle = sectionHeaderTitles[0];
            break;
        case 1:
            thisSectionHeaderTitle = sectionHeaderTitles[1];
            break;
        case 2:
            thisSectionHeaderTitle = sectionHeaderTitles[2];
            break;
        case 3 ... 9:
            weekIsEqual = [CommonUtilities weekIsEqual:baseDate and:eventStartDate];
            if (weekIsEqual) {
                thisSectionHeaderTitle = sectionHeaderTitles[3];
            } else {
                thisSectionHeaderTitle = sectionHeaderTitles[4];
            }
            
            break;
        case 10 ... 14:
            thisSectionHeaderTitle = sectionHeaderTitles[5];
            break;
        case 15 ... 22:
            thisSectionHeaderTitle = sectionHeaderTitles[6];
            break;
        case 23 ... 35:
            thisSectionHeaderTitle = sectionHeaderTitles[7];
            break;
        case 36 ... 63:
            thisSectionHeaderTitle = sectionHeaderTitles[8];
            break;
        default:
            thisSectionHeaderTitle = sectionHeaderTitles[9];
            break;
    }
    
    return thisSectionHeaderTitle;
    
}


- (UINib *)eventCellNib
{
    if (!_eventCellNib)
    {
        _eventCellNib = [UINib nibWithNibName:@"EventCell" bundle:nil];
    }
    return _eventCellNib;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    eventCell = (EventCell *)cell;
    
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [self configureEventCellDateFormatter:dateFormatter];
        
    }
    
    if (!eventCell) {
        
        [[NSBundle bundleForClass:self.class]
         loadNibNamed:@"EventCell"
         owner:self
         options:nil];
    }

    eventCell.titleLabel.text = [[self eventForIndexPath: indexPath] name];
    Group *thisGroup = (Group *)[[self eventForIndexPath: indexPath] group];
    eventCell.groupLabel.text = thisGroup.name;
    //        Venue *thisVenue = (Venue *)[[self eventForIndexPath: indexPath] venue];
    //        eventCell.groupLabel.text = thisGroup.name;

    NSString *formattedDateString = [dateFormatter stringFromDate:[[self eventForIndexPath: indexPath] startDateTime]];
  
    
    NSArray *datetimeArray = [formattedDateString componentsSeparatedByString: @"|"];
//    for (NSString *n in datetimeArray) {
//        NSLog(@"%@", n );
//    }
    
    NSArray *dateArray =[datetimeArray[0] componentsSeparatedByString: @"-"];
    
//    for (NSString *k in dateArray) {
//        NSLog(@"%@", k );
//    }
    
    // Setup the Detail and Text labels with the Event's values
    eventCell.dayLabel.text = [dateArray[0] uppercaseString];
    eventCell.monthLabel.text = [dateArray[1] uppercaseString];
    eventCell.dateLabel.text = dateArray[2];
    eventCell.starttimeLabel.text = datetimeArray[1];

}

- (void)configureEventCellDateFormatter:(NSDateFormatter *)dateFormatter
{
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setLocale:enUSPOSIXLocale];
    
    //to format a date according to the common RFC 3339 (ISO 8601) standard:
    //[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [dateFormatter setDateFormat:@"E'-'MMM'-'d'-'yyyy'|'hh':'mm a'"];
    
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    
}




-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EventHeader * header = [[EventHeader alloc] init];
    header.titleLabel.text = [self tableView: tableView titleForHeaderInSection:section];
    header.titleLabel.textColor = [UIColor darkGrayColor];
    return header;
}


@end

NSString *EventListTableDidSelectEventNotification = @"EventListTableDidSelectEventNotification";