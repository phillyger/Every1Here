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
#import "User.h"
@class Event;
@class User;


/**
 * The delegate protocol for the ParseDotComManager class.
 *
 * ParseDotComManager uses this delegate protocol to indicate when information becomes available, and to ask about doing further processing.
 */

@protocol ParseDotComManagerDelegate <NSObject>



/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didInsertUserForUserType:(UserTypes)userType;

/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didUpdateUserForUserType:(UserTypes)userType;

/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didDeleteUserForUserType:(UserTypes)userType;

/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didFetchUsersForUserType:(UserTypes)userType;


/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didInsertAttendance;


/**
 * The manager successfully updated an existing User Attendance record into Parse.com.
 */
- (void)didUpdateAttendance;


/**
 * The manager successfully deleted an existing User Attendance record into Parse.com.
 */
- (void)didDeleteAttendance;

/**
 * The manager successfully deleted an existing User Attendance record into Parse.com.
 */
- (void)didFetchAttendance;

/**
 * The manager received an error when inserting a new member into Parse.com.
 */
//- (void)insertingAttendanceFailedWithError: (NSError *)error;


/**
 * The manager received an error when updating a User attendance record into Parse.com.
 */
//- (void)updatingAttendanceFailedWithError: (NSError *)error;

/**
 * The manager received an error when deleting a User attendance record into Parse.com.
 */
//- (void)deletingAttendanceFailedWithError: (NSError *)error;


/**
 * The manager received an error when updating an existing member into Parse.com.
 */
//- (void)updatingExistingUserFailedWithError: (NSError *)error;


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
