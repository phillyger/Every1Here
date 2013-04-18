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
 * The manager successfully inserted a new Member or Guest into Parse.com.
 */
- (void)didInsertUserForUserType:(UserTypes)userType withOutput:(NSArray *)objectNotationList;

/**
 * The manager successfully updated a new Member or Guest in Parse.com.
 */
- (void)didUpdateUserForUserType:(UserTypes)userType;

/**
 * The manager successfully fetch a listing of Members or Guests from Parse.com.
 */
- (void)didFetchUsers:(NSArray *)userList forUserType:(UserTypes)userType;

/**
 * The manager received an error when inserting an existing Member or Guest into Parse.com.
 */
//- (void)insertingUserFailedWithError: (NSError *)error;

/**
 * The manager received an error when updating an existing Member or Guest into Parse.com.
 */
//- (void)updatingExistingUserFailedWithError: (NSError *)error;

/**
 * The manager successfully inserted a new Member or Guest Attendance record into Parse.com.
 */
- (void)didInsertAttendanceWithOutput:(NSArray *)objectNotationList;


/**
 * The manager successfully updated an existing Member or Guest's Attendance record into Parse.com.
 */
- (void)didUpdateAttendance;


/**
 * The manager successfully deleted an existing Member or Guest's Attendance record into Parse.com.
 */
- (void)didDeleteAttendance;

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
 * The manager received an error when executing batch operation in Parse.com.
 */
- (void)executedOpsFailedWithError:reportableError forActionType:(ActionTypes) actionType forNamedClass:(NSString *)namedClass;




@end
