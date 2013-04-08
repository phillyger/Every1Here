//
//  GuestBuilder.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/25/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuestCommunicatorDelegate.h"



@interface GuestBuilder : NSObject

/**
 * Given a string containing a JSON dictionary, return a list of user objects with a role of 'GUEST'.
 * @param objectNotation The JSON string
 * @param error By-ref error signalling
 * @return An array of user objects with a role of guest, or nil (with error set) if objectNotation cannot be parsed.
 * @see Question
 */
- (NSArray *)guestsFromJSON: (NSDictionary *)objectNotation socialNetworkType:(SocialNetworkType)slType error: (NSError **)error;

@end

extern NSString *GuestBuilderErrorDomain;

enum {
    GuestBuilderInvalidJSONError,
    GuestBuilderMissingDataError,
};