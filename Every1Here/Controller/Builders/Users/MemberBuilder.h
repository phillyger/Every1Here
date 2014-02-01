//
//  MemberBuilder.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/25/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialNetworkUtilities.h"


@interface MemberBuilder : NSObject {

}

/**
 * Given a string containing a JSON dictionary, return a list of user objects with a role of 'MEMBER'.
 * @param objectNotation The JSON string
 * @param error By-ref error signalling
 * @return An array of user objects with a role of member, or nil (with error set) if objectNotation cannot be parsed.
 * @see Question
 */
- (NSArray *)usersFromJSON: (NSDictionary *)objectNotation
                     error: (NSError **)error;

/**
 * Given a string containing a JSON dictionary, return a list of user objects with a role of 'MEMBER'.
 * @param objectNotation The JSON string
 * @param error By-ref error signalling
 * @return An array of user objects with a role of member, or nil (with error set) if objectNotation cannot be parsed.
 * @see Question
 */
- (NSArray *)usersFromJSON: (NSDictionary *)objectNotation
            withAttendance:(NSDictionary *)attendanceDict
               withEventId:(NSString *)eventId
         socialNetworkType:(SocialNetworkType)slType
                     error: (NSError **)error;

- (NSArray *)usersFromJSON: (NSDictionary *)objectNotation
            withAttendance:(NSDictionary *)attendanceDict
            withSpeechDict:(NSDictionary *)speechDict
               withEventId:(NSString *)eventId
         socialNetworkType:(SocialNetworkType)slType
                     error: (NSError **)error;

@end

enum {
    MemberBuilderInvalidJSONError,
    MemberBuilderMissingDataError,
};


extern NSString *MemberBuilderErrorDomain;
