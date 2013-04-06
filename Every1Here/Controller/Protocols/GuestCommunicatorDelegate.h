//
//  GuestCommunicatorDelegate.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/23/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialNetworkUtilities.h"

@protocol GuestCommunicatorDelegate <NSObject>

/**
 * The communicator received a response from the Parse fetch.
 */
- (void)receivedGuestsJSON: (NSDictionary *)objectNotation socialNetworkType:(SocialNetworkType)slType;

/**
 * Trying to retrieve events failed.
 * @param error The error that caused the failure.
 */
- (void)fetchingGuestsFailedWithError: (NSError *)error;

@end
