//
//  GuestManagerDelegate.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;
@class User;

@protocol GuestManagerDelegate <NSObject>

/**
 * The manager retrieved a list of 'guests' (aka non-members) from Meetup.com.
 */
- (void)didReceiveGuests: (NSArray *)guests;

/**
 * The manager was unable to retrieve guests from Meetup.com.
 */
- (void)retrievingGuestsFailedWithError: (NSError *)error;

/**
 * The manager retrieved a list of guests for a specific event from Meetup.com.
 */
- (void)guestsReceivedForEvent: (Event *)event;




@end
