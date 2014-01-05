//
//  User.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "Person.h"
#import "RoleDelegate.h"
#import "SocialNetworkUtilities.h"


typedef NS_ENUM(NSUInteger, UserTypes) {
    Member,
    Guest
};

@interface User : Person <RoleDelegate>
{
    //id <RoleDelegate> delegate;
    NSMutableDictionary *roles;
}

/**
 * parse.com primary id for the Member Table
 */
@property (nonatomic, strong)NSString *objectId;

/**
 *   Parse eventId associated with User Table
 */
@property (copy) NSString *eventId;

/**
 *   Parse ObjectId associated with User Table
 */
@property (copy) NSString *userId;

/**
 *   User has an Attendance record
 */
@property (nonatomic, readonly) BOOL hasUserRecord; // Return YES if User has an User record.

/**
 *   Parse ObjectId associated with Attendance Table
 */
@property (copy) NSString *attendanceId;

/**
 *   User has an Attendance record
 */
@property (nonatomic, readonly) BOOL hasAttendanceRecord; // Return YES if User has an Attendance record.

/**
 *   The display name of the user
 */
@property (copy) NSString *displayName;

/**
 *   The number of speeches completed.
 */
@property (nonatomic) NSNumber *compComm;

/**
 *  The path to the user's avatar
 */
@property (readonly, strong) NSURL *avatarURL;

/**
 *  The social network through which the user connected.
 */
@property (readonly) SocialNetworkType slType;

/**
 *  The social network through which the user connected.
 */
@property (readonly) NSString *slUserId;

/**
 *  The primary email addresss
 */
@property (copy) NSString *primaryEmailAddr;

/**
 *  The secondary email addresss 
 */
@property (copy) NSString *secondaryEmailAddr;

- (id)init;


- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
            displayName:(NSString *)displayName
       primaryEmailAddr:(NSString *)primaryEmailAddr
     secondaryEmailAddr:(NSString *)secondaryEmailAddr
         avatarLocation:(NSString *)location
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId
                eventId:(NSString *)anEventId
                 slType:(SocialNetworkType)aSlType
               slUserId:(NSString *)aSocialNetworkUserId
               compComm:(NSNumber *)compComm;

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
       primaryEmailAddr:(NSString *)primaryEmailAddr
     secondaryEmailAddr:(NSString *)secondaryEmailAddr
         avatarLocation:(NSString *)location
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId
                eventId:(NSString *)anEventId
                 slType:(SocialNetworkType)aSlType
               slUserId:(NSString *)aSocialNetworkUserId
               compComm:(NSNumber *)compComm;



- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
         avatarLocation:(NSString *)anAvatarLocation
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId
                eventId:(NSString *)anEventId;

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName;


- (id)initWithDisplayName:(NSString *)aDisplayName
           avatarLocation:(NSString *)location
                 objectId:(NSString *)anObjectId
                   userId:(NSString *)aUserId
                  eventId:(NSString *)anEventId
                   slType:(SocialNetworkType)aSlType
                 slUserId:(NSString *)aSocialNetworkUserId;


- (id)initWithDisplayName:(NSString *)aDisplayName
         primaryEmailAddr:(NSString *)aPrimaryEmailAddr
       secondaryEmailAddr:(NSString *)aSecondaryEmailAddr
           avatarLocation:(NSString *)location
                 objectId:(NSString *)anObjectId
                   userId:(NSString *)aUserId
                  eventId:(NSString *)anEventId
                   slType:(SocialNetworkType)aSlType
                 slUserId:(NSString *)aSocialNetworkUserId
                 compComm:(NSNumber *)compComm;


@end
