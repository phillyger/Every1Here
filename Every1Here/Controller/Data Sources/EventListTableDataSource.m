//
//  EmptyTableViewDataSource.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventListTableDataSource.h"
#import "EventCell.h"
#import "Event.h"
#import "Group.h"
#import "Venue.h"

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
@synthesize eventDict;
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
    return self.sectionHeaderTitleList[section];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.sectionHeaderTitleList count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    NSParameterAssert(section == 0);

    NSArray *eventsOnThisDay = [self.eventDict objectForKey:self.sectionHeaderTitleList[section]];
    return [eventsOnThisDay count];
    
}


- (Event *)eventForIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionName = sectionHeaderTitleList[indexPath.section];
    Event *event = [eventDict[sectionName] objectAtIndex:indexPath.row];
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
        Event *event = [eventDict[sectionName] objectAtIndex:indexPath.row];
//        eventCell = [aTableView dequeueReusableCellWithIdentifier: eventCellReuseIdentifier];
        eventCell = [aTableView dequeueReusableCellWithIdentifier:eventCellReuseIdentifier forIndexPath:indexPath];

//        if (!eventCell) {
//            
//            [self.eventCellNib instantiateWithOwner:self options:nil];
//        }
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [self configureEventCellDateFormatter:dateFormatter];
            
        }
        

        
        eventCell.titleLabel.text = [event name];
        Group *thisGroup = (Group *)[event group];
        eventCell.groupLabel.text = thisGroup.name;
        //        Venue *thisVenue = (Venue *)[[self eventForIndexPath: indexPath] venue];
        //        eventCell.groupLabel.text = thisGroup.name;
        
        NSString *formattedDateString = [dateFormatter stringFromDate:[event startDateTime]];
        
        
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
    
    NSArray *sectionHeaderTitleUpcomingFullList = @[@"Today",
                                            @"Tomorrow",
                                            @"Later This Week",
                                            @"Next Week",
                                            @"In Two Weeks",
                                            @"In Three Weeks",
                                            @"Later"];
    
    
    NSArray *sectionHeaderTitlePastFullList = @[@"Today",
                                                @"Yesterday",
                                            @"Earlier This Week",
                                            @"Last Week",
                                            @"Two Weeks Ago",
                                            @"Three Weeks Ago",
                                            @"Earlier"];
    
    sectionHeaderTitleList = [[NSMutableArray alloc] init];
    eventDict = [[NSMutableDictionary alloc] init];
    
    NSDate *dateBeginningOfThisDay = [self dateAtBeginningOfDayForDate:[NSDate date]];
    
    
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Event *event = obj;
        NSArray *sectionHeaderTitleFullList = [[event status] isEqualToString:@"upcoming"] ? sectionHeaderTitleUpcomingFullList : sectionHeaderTitlePastFullList;
        
        NSString *sectionHeaderTitle = [self categorizeEventStartDate:[event startDateTime]
                                                        usingBaseDate:dateBeginningOfThisDay
                                                            withArray:sectionHeaderTitleFullList];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *eventsOnThisDay = [self.eventDict objectForKey:sectionHeaderTitle];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            // Use the section header title as dictionary key to later retrieve the event list this day
            [self.eventDict setObject:eventsOnThisDay forKey:sectionHeaderTitle];
        }
        
        // Add the event to the list for this day
        [eventsOnThisDay addObject:event];
        
    }];
    
    // Create a sorted list of days
    self.sectionHeaderTitleList = [self.eventDict allKeys];
    
    
}

- (NSString *)categorizeEventStartDate:(NSDate *)eventStartDate usingBaseDate:(NSDate *)baseDate withArray:(NSArray*)sectionHeaderTitles {
    
    NSString *thisSectionHeaderTitle = nil;
    NSInteger daysOffset = [self numberOfDaysBetweenBaseDate:baseDate offsetDate:eventStartDate];
    
    // Ensure that we are using the absolute value.
    switch (ABS(daysOffset)) {
        case 0:
            thisSectionHeaderTitle = sectionHeaderTitles[0];
            break;
        case 1:
            thisSectionHeaderTitle = sectionHeaderTitles[1];
            break;
        case 2 ... 7:
            thisSectionHeaderTitle = sectionHeaderTitles[2];
            break;
        case 8 ... 13:
            thisSectionHeaderTitle = sectionHeaderTitles[3];
            break;
        case 14 ... 23:
            thisSectionHeaderTitle = sectionHeaderTitles[4];
            break;
        case 24 ... 31:
            thisSectionHeaderTitle = sectionHeaderTitles[5];
            break;
        default:
            thisSectionHeaderTitle = sectionHeaderTitles[6];
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


- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSInteger)numberOfDaysBetweenBaseDate:(NSDate *)baseDate offsetDate:(NSDate *)offsetDate  {
    
    NSDate *dateBeginningOfEventStartDay = [self dateAtBeginningOfDayForDate:offsetDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorianCalendar components:unitFlags
                                                        fromDate:baseDate
                                                          toDate:dateBeginningOfEventStartDay
                                                         options:0];
    gregorianCalendar= nil;
    
    NSInteger daysOffset = [components day];
    
    return daysOffset;
}


@end

NSString *EventListTableDidSelectEventNotification = @"EventListTableDidSelectEventNotification";