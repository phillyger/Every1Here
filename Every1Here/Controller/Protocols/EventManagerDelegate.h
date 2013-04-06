//
//  EventManagerDelegate.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

@protocol EventManagerDelegate <NSObject>

/**
 * The manager retrieved a list of events.
 */
- (void)didReceiveEvents: (NSArray *)events;

/**
 * The manager was unable to retrieve events
 */
- (void)retrievingEventsFailedWithError: (NSError *)error;

/**
 * The manager was unable to insert a new event into Parse
 */
- (void)insertingNewEventFailedWithError: (NSError *)error;

/**
 * The manager inserted a new event into Parse
 */
- (void)didInsertNewEvent:(Event *)selectedEvent;

@end
