//
//  User.h
//  Anseo
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "Person.h"
#import "RoleDelegate.h"
#import "SocialNetworkUtilities.h"


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
 *   Parse ObjectId associated with User Table
 */
@property (copy) NSString *userId;

/**
 *   Parse ObjectId associated with Attendance Table
 */
@property (copy) NSString *attendanceId;

/**
 *   The display name of the user
 */
@property (copy) NSString *displayName;


/**
 *  The path to the user's avatar
 */
@property (readonly, strong) NSURL *avatarURL;

/**
 *  The social network through which the user connected.
 */
@property (readonly) SocialNetworkType slType;

/**
 *  The primary email addresss
 */
@property (copy) NSString *primaryEmailAddr;

/**
 *  The secondary email addresss 
 */
@property (copy) NSString *secondaryEmailAddr;


- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
       primaryEmailAddr:(NSString *)primaryEmailAddr
     secondaryEmailAddr:(NSString *)secondaryEmailAddr
         avatarLocation:(NSString *)location
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId
                 slType:(SocialNetworkType)aSlType;

- (id)initWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName;
- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
         avatarLocation:(NSString *)anAvatarLocation
               objectId:(NSString *)anObjectId;

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
         avatarLocation:(NSString *)anAvatarLocation
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId;

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
         avatarLocation:(NSString *)anAvatarLocation;

- (id)initWithDisplayName:(NSString *)aDisplayName
           avatarLocation:(NSString *)location
                   slType:(SocialNetworkType)aSlType;

- (id)initWithDisplayName: (NSString *)aDisplayName
         primaryEmailAddr:(NSString *)primaryEmailAddr
       secondaryEmailAddr:(NSString *)secondaryEmailAddr
           avatarLocation:(NSString *)location
                   slType:(SocialNetworkType)aSlType;

@end
