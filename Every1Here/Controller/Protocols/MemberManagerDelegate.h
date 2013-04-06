//
//  MemberManagerDelegate.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;
@class User;

@protocol MemberManagerDelegate <NSObject>

/**
 * The manager was unable to retrieve questions from Parse.com.
 */
- (void)retrievingMembersFailedWithError: (NSError *)error;

/**
 * The manager retrieved a list of questions from Parse.com.
 */
- (void)didReceiveMembers: (NSArray *)members;

/**
 * The manager retrieved a list of members for a specific event from Parse.com.
 */
- (void)membersReceivedForEvent: (Event *)event;

- (void)userDidSelectMemberNotification: (NSNotification *)note;



/**
 * The manager successfully inserted a new Member into Parse.com.
 */
- (void)didInsertNewMember:(User *)selectedUser
                 withEvent: (Event *)selectedEvent;


/**
 * The manager received an error when inserting a new member into Parse.com.
 */
- (void)insertingNewMemberFailedWithError: (NSError *)error;








@end
