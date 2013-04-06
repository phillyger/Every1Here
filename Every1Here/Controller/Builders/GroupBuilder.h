//
//  GroupBuilder.h
//  Anseo
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Group;

/**
 * Construct Group objects from an external representation.
 * @note The format of the JSON is driven by the Meetup 2 API.
 * @see Group
 */

 @interface GroupBuilder : NSObject
/**
 * Given a dictionary that describes a person on Stack Overflow, create
 * a Person object with the supplied properties.
 */
+ (Group *) groupFromDictionary: (NSDictionary *) groupValues;

/**
 * Given a JSON string that describes a group on Parse.com, create
 * a Group object with the supplied properties.
 */
/**
 * Given a string containing a JSON dictionary, return a list of Group objects.
 * @param objectNotation The JSON string
 * @param error By-ref error signalling
 * @return An Group object, or nil (with error set) if objectNotation cannot be parsed.
 * @see Group
 */

+ (NSArray *)groupsFromJSON:(NSDictionary *)objectNotation error: (NSError **)error;




@end

extern NSString *GroupBuilderErrorDomain;

enum {
    GroupBuilderInvalidJSONError,
    GroupBuilderMissingDataError,
};