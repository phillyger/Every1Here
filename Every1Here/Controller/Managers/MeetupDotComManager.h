//
//  MeetupDotComManager.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/31/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetupDotComManagerDelegate.h"
//#import "MeetupDotComCommunicatorDelegate.h"
#import "EventCommunicatorDelegate.h"
#import "EventManagerDelegate.h"
#import "GuestCommunicatorDelegate.h"
#import "GuestManagerDelegate.h"

@class MeetupDotComCommunicator;
@class EventBuilder;
@class GuestBuilder;
@class Event;
@class User;
@class Group;

/**
 * A façade providing access to the external Meetup.com API services.
 * Application code should only use this class to get at External services innards.
 */
@interface MeetupDotComManager : NSObject <EventCommunicatorDelegate, GuestCommunicatorDelegate>

@property (weak, nonatomic) id <EventManagerDelegate> eventDelegate;
@property (weak, nonatomic) id <GuestManagerDelegate> guestDelegate;
@property (strong) MeetupDotComCommunicator *communicator;
@property (strong) EventBuilder *eventBuilder;
@property (strong) GuestBuilder *guestBuilder;
@property (strong) Event *eventToFill;


/**
 * Retrieve guests on a given event from Meetup.com service.
 * @note The delegate will receive messages when new information
 *       arrives, and this class will ask the delegate if it needs
 *       guidance.
 * @param event The subject on which to find members.
 * @see MeetupDotComManagerDelegate
 */
- (void)fetchGuestsForEvent: (Event *)event;


/**
 * Retrieve guests on a given group from Meetup.com service.
 * @note The delegate will receive messages when new information
 *       arrives, and this class will ask the delegate if it needs
 *       guidance.
 * @param event The subject on which to find members.
 * @see ParseDotComManagerDelegate
 */
- (void)fetchGuestsForGroup:(Group *)group;
- (void)fetchGuestsForGroupName:(NSString *)groupUrlName;



@end


extern NSString *MeetupDotComManagerError;

enum {
    MeetupDotComManagerErrorUpcomingFetchCode,
    MeetupDotComManagerErrorGuestFetchCode
};

