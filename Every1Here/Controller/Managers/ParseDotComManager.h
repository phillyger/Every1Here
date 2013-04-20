//
//  Every1HereManager.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/29/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseDotComManagerDelegate.h"
#import "EventCommunicatorDelegate.h"
#import "MemberCommunicatorDelegate.h"
#import "EventManagerDelegate.h"
#import "E1HOperationFactory.h"
#import "User.h"

@class ParseDotComCommunicator;
@class EventBuilder;
@class MemberBuilder;
@class GuestBuilder;
@class GroupBuilder;
@class Event;
@class Group;


/**
 * A façade providing access to the external Parse.com API services.
 * Application code should only use this class to get at external services innards.
 */
@interface ParseDotComManager : NSObject

@property (weak, nonatomic) id <EventManagerDelegate> eventDelegate;
@property (weak, nonatomic) id <ParseDotComManagerDelegate> parseDotComDelegate;
@property (strong) ParseDotComCommunicator *communicator;
@property (strong) EventBuilder *eventBuilder;
@property (strong) GroupBuilder *groupBuilder;
@property (strong) MemberBuilder *memberBuilder;
@property (strong) GuestBuilder *guestBuilder;
@property (strong) Event *eventToFill;

/**
 * Retrieve members on a given event from Parse.com service.
 * @note The delegate will receive messages when new information
 *       arrives, and this class will ask the delegate if it needs
 *       guidance.
 * @param event The subject on which to find members.
 * @see ParseDotComManagerDelegate
 */
- (void)fetchUsersForEvent: (Event *)event withUserType:(UserTypes)userType;


/**
 * Retrieve past events on a given group from Parse.com service.
 * @note The delegate will receive messages when new information
 *       arrives, and this class will ask the delegate if it needs
 *       guidance.
 * @param group The subject on which to find members.
 * @see ParseDotComManagerDelegate, Group
 */
- (void)fetchEventsForOrgId:(NSNumber *)orgId withStatus:(NSString *)status;


-(void)updateAttendanceForUser:(User*)user;
-(void)insertAttendanceForUser:(User*)user;
-(void)deleteAttendanceForUser:(User*)user;


-(void)insertUser:(User*)user withUserType:(UserTypes)userType;
-(void)insertUserList:(NSArray *)userList withUserType:(UserTypes)userType forSocialNetworkKey:(SocialNetworkType)slType;

-(void)updateUser:(User*)user withUserType:(UserTypes)userType;

-(void)deleteUser:(User*)user withUserType:(UserTypes)userType;
-(void)deleteUserList:(NSArray *)userList withUserType:(UserTypes)userType forSocialNetworkKey:(SocialNetworkType)slType;



@end

extern NSString *ParseDotComManagerError;

enum {
    ParseDotComManagerErrorPastEventFetchCode,
    ParseDotComManagerErrorMemberFetchCode
};
