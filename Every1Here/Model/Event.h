//
//  Event.h
//  Anseo
//
//  Created by Ger O'Sullivan on 1/16/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Group;
@class Venue;
@class User;

@interface Event : NSObject
{
    NSArray *members;
    NSArray *guests;
}

/**
 * parse.com primary id.
 */
@property (nonatomic, strong)NSString *objectId;  

/**
 * A name for this event, suitable for displaying in the UI.
 */
@property (copy)NSString *name;


/**
 * The date-time on which this event started.
 */
@property (retain) NSDate *startDateTime;

/**
 * The date-time on which this event ended.
 */
@property (retain) NSDate *endDateTime;


/**
 * A name for this event, suitable for displaying in the UI.
 */
@property (copy)NSString *status;


/**
 * A name for this event, suitable for displaying in the UI.
 */
@property (copy)NSString *eventId;


/**
 * A group for this event.
 */
@property (retain)Group *group;

/**
 * A group for this event.
 */
@property (retain)Venue *venue;

/**
 * A time for this event.
 */
@property NSTimeInterval time;

/**
 * A duration for this event.
 */
@property NSNumber *duration;

/**
 * A utc_offset for this event.
 */
@property NSNumber *utc_offset;

/**
 * A yes_rsvp_count for this event.
 */
@property NSNumber *yes_rsvp_count;

/**
 * A maybe_rsvp_count for this event.
 */
@property NSNumber *maybe_rsvp_count;

/**
 * A headcount for this event.
 */
@property NSNumber *headcount;

/**
 * sorted Social Network Types - readonly to outside world.
 */
@property (nonatomic, strong, readonly)NSArray *sortedSocialNetworkTypes;

/**
 * A list of members for this event.
 */
- (NSArray*)allMembers;

/**
 * A list of guest for this event.
 */
- (NSArray*)allGuests;

/**
 * Clear the guest list.
 */
- (void)clearGuestList;


/**
 * Add a user with member role.
 */
- (void)addMember:(User *)user;

/**
 * Add a user with guest role.
 */
- (void)addGuest:(User *)user;

/**
 * Sets the guest list.
 */
- (void)setGuestList:(NSArray *)newGuests;

/**
 * Sorted the list of Social Network Type
 */
- (void)sortSocialNetworkTypes:(NSDictionary *)socialNetworkTypeDict;

- (NSArray *)filterBySocialNetwork:(NSString *)key;

@end
