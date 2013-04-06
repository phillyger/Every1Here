//
//  TwitterDotComManager.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/23/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuestManagerDelegate.h"
#import "GuestCommunicatorDelegate.h"

@class TwitterDotComCommunicator;
@class GuestBuilder;


/**
 * A façade providing access to the external Meetup.com API services.
 * Application code should only use this class to get at External services innards.
 */
@interface TwitterDotComManager : NSObject <GuestCommunicatorDelegate>

@property (weak, nonatomic) id <GuestManagerDelegate> guestDelegate;
@property (strong) TwitterDotComCommunicator *communicator;
@property (strong) GuestBuilder *guestBuilder;

/**
 * Retrieve guests on a given group from Meetup.com service.
 * @note The delegate will receive messages when new information
 *       arrives, and this class will ask the delegate if it needs
 *       guidance.
 * @param event The subject on which to find members.
 * @see ParseDotComManagerDelegate
 */
- (void)fetchGuestsForGroupName:(NSString *)groupName;

@end

extern NSString *TwitterDotComManagerError;

enum {
    TwitterDotComManagerErrorUpcomingFetchCode,
    TwitterDotComManagerErrorGuestFetchCode
};