//
//  EventListTableDataSource.h
//  E1H
//
//  Created by Ger O'Sullivan on 2/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;
@class EventCell;

@interface EventListTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong) IBOutlet EventCell *eventCell;
@property (strong, nonatomic) NSArray *sectionHeaderTitleList;
@property (strong, nonatomic) NSMutableDictionary *sections;

- (void)setEvents:(NSArray *)events;
- (NSArray *)sortEventArray:(NSArray *)events;
- (void)buildEventDict;


@end

extern NSString *EventListTableDidSelectEventNotification;
