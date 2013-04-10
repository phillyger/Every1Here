////
////  ParseDotComManagerDelegate.h
////  Every1Here
////
////  Created by Ger O'Sullivan on 1/29/13.
////  Copyright (c) 2013 Brilliant Age. All rights reserved.
////
//
#import <Foundation/Foundation.h>
#import "E1HOperationFactory.h"

@class Event;
@class User;


/**
 * The delegate protocol for the ParseDotComManager class.
 *
 * ParseDotComManager uses this delegate protocol to indicate when information becomes available, and to ask about doing further processing.
 */

@protocol ParseDotComManagerDelegate <NSObject>


/**
 * The manager successfully inserted a new User into Parse.com.
 */
- (void)didInsertNewUser:(User *)selectedUser
               withEvent: (Event *)selectedEvent;

/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didInsertNewGuest:(User *)selectedUser
                withEvent: (Event *)selectedEvent;


/**
 * The manager received an error when inserting a new member into Parse.com.
 */
- (void)insertingNewGuestFailedWithError: (NSError *)error;


/**
 * The manager received an error when inserting a new user into Parse.com.
 */
- (void)insertingNewUserFailedWithError: (NSError *)error;


/**
 * The manager received an error when updating an existing member into Parse.com.
 */
- (void)updatingExistingUserFailedWithError: (NSError *)error;

/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didUpdateExistingGuest:(User *)selectedUser;

/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didUpdateExistingUser:(User *)selectedUser;


/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didInsertNewAttendanceWithUser:(User *)selectedUser
                             withEvent:(Event *)selectedEvent;


/**
 * The manager received an error when inserting a new member into Parse.com.
 */
- (void)insertingNewAttendanceFailedWithError: (NSError *)error;

/**
 * The manager successfully updated an existing User Attendance record into Parse.com.
 */
- (void)didUpdateAttendanceWithUser:(User *)selectedUser
                          withEvent:(Event *)selectedEvent;



/**
 * The manager successfully deleted an existing User Attendance record into Parse.com.
 */
- (void)didDeleteAttendanceForUser:(User *)selectedUser;


/**
 * The manager received an error when updating a User attendance record into Parse.com.
 */
- (void)updatingExistingUserAttendanceFailedWithError: (NSError *)error;

/**
 * The manager received an error when deleting a User attendance record into Parse.com.
 */
- (void)deletingExistingUserAttendanceFailedWithError: (NSError *)error;


/**
 * The manager received an error when executing insert operations into Parse.com.
 */
- (void)executedOpsFailedWithError:(NSError *)error
                     forActionType:(ActionTypes) actionType
                      forClassName:(NSString *)className;


/**
 * The manager successfully deleted an existing User Attendance record into Parse.com.
 */
- (void)didExecuteOps:(NSArray *)objectNotationList
              forActionType:(ActionTypes) actionType
               forClassName:(NSString *)className;




@end
