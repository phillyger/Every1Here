//
//  Every1HereManager.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/29/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseDotComManagerDelegate.h"
//#import "ParseDotComCommunicatorDelegate.h"
#import "EventCommunicatorDelegate.h"
#import "MemberCommunicatorDelegate.h"
#import "EventManagerDelegate.h"
#import "MemberManagerDelegate.h"


@class ParseDotComCommunicator;
@class EventBuilder;
@class MemberBuilder;
@class GuestBuilder;
@class GroupBuilder;
@class Event;
@class Group;
@class User;

/**
 * A façade providing access to the external Parse.com API services.
 * Application code should only use this class to get at external services innards.
 */
@interface ParseDotComManager : NSObject <EventCommunicatorDelegate, MemberCommunicatorDelegate, ParseDotComManagerDelegate>

@property (weak, nonatomic) id <EventManagerDelegate> eventDelegate;
@property (weak, nonatomic) id <MemberManagerDelegate> memberDelegate;
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
- (void)fetchMembersForEvent: (Event *)event;

/**
 * Retrieve members on a given group from Parse.com service.
 * @note The delegate will receive messages when new information
 *       arrives, and this class will ask the delegate if it needs
 *       guidance.
 * @param event The subject on which to find members.
 * @see ParseDotComManagerDelegate
 */
- (void)fetchMembersForGroup:(Group *)group;
- (void)fetchMembersForGroupName:(NSString *)groupName;

/**
 * Retrieve past events on a given group from Parse.com service.
 * @note The delegate will receive messages when new information
 *       arrives, and this class will ask the delegate if it needs
 *       guidance.
 * @param group The subject on which to find members.
 * @see ParseDotComManagerDelegate, Group
 */
- (void)fetchPastEventsForGroup:(Group *)group;
- (void)fetchPastEventsForGroupName:(NSString *)groupName;
- (void)fetchEventsForGroupName:(NSString *)groupName status:(NSString *)status;

/**
 *  Parse CRUD methods for User/Member/Guests
 **/

- (void)createNewMember:(User *)selectedMember withEvent: selectedEvent;
- (void)createNewUser:(User *)selectedMember withEvent: selectedEvent;
- (void)createNewGuest:(User *)selectedGuest withEvent: selectedEvent;

- (void)updateExistingUser:(User *)selectedMember withClassType:(NSString *)classType;

/**
 *  Parse CRUD methods for Event
 **/
- (void)createNewEvent:(Event *)selectedEvent;

/**
 *  Parse CRUD methods for Attendance
 **/
- (void)createNewAttendanceWithUser:(User *)selectedUser
                          withEvent:(Event *)selectedEvent;

- (void)updateAttendanceWithUser:(User *)selectedUser
                          withEvent:(Event *)selectedEvent;

- (void)deleteAttendanceForUser:(User *)selectedUser;



@end

extern NSString *ParseDotComManagerError;

enum {
    ParseDotComManagerErrorPastEventFetchCode,
    ParseDotComManagerErrorMemberFetchCode
};
