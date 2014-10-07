//
//  EventBuilder.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

/**
 * Construct Event objects from an external representation.
 * @note The format of the JSON is driven by the Meetup 2.0 API.
 * @see Event
 */

@interface EventBuilder : NSObject{
    
}
/**
 * Given a string containing a JSON dictionary, return a list of 'upcoming' Events objects.
 * @param objectNotation The JSON string
 * @param error By-ref error signalling
 * @return An array of Event objects, or nil (with error set) if objectNotation cannot be parsed.
 * @see Question
 */
//- (NSArray *)eventsFromJSON: (NSString *)objectNotation error: (NSError **)error;
- (NSArray *)eventsFromJSON: (NSDictionary *)objectNotation error: (NSError **)error;

@end


extern NSString *EventBuilderErrorDomain;

enum {
    EventBuilderInvalidJSONError,
    EventBuilderMissingDataError,
};
