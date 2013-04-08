//
//  MemberCommunicatorDelegate.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/23/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MemberCommunicatorDelegate <NSObject>

/**
 * The communicator received a response from the Parse fetch.
 */
- (void)receivedMembersFetchOps: (NSArray *)operations;

/**
 * Trying to retrieve events failed.
 * @param error The error that caused the failure.
 */
- (void)fetchingMembersFailedWithError: (NSError *)error;


@end
