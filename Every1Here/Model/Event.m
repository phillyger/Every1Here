//
//  Event.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/16/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "Event.h"
#import "User.h"
#import "Group.h"
#import "Venue.h"
#import "SocialNetworkUtilities.h"

@interface Event ()
/**
 * Make this private read/write.
 */
@property (nonatomic, strong, readwrite)NSArray *sortedSocialNetworkTypes;


@end

@implementation Event
@synthesize objectId;
@synthesize name, status, eventId;
@synthesize time, duration, utc_offset;
@synthesize group, venue;
@synthesize yes_rsvp_count, maybe_rsvp_count, headcount;
@synthesize sortedSocialNetworkTypes;


- (id)init
{
    if (self = [super init]) {
        members = [[NSArray alloc] init];
        guests = [[NSArray alloc] init];
    }
    return self;
}




- (NSArray *)allMembers
{
    return [self sortUsersByLastName: members];

    //return members;
}

- (NSArray *)allGuests
{

    return [self sortUsersByDisplayName: guests];
    //return guests;
    
}

- (void)clearGuestList
{
    
    guests = [[NSArray alloc] init];
    //return guests
}

- (void)setGuestList:(NSArray *)newGuests {
    guests = newGuests;
}


- (void)addMember:(User *)user
{
    NSArray *newMembers = [members arrayByAddingObject: user];
    newMembers = [self sortUsersByLastName: newMembers];
    
    members = newMembers;
}

- (void)addGuest:(User *)user
{
    NSArray *newGuests = [guests arrayByAddingObject: user];
    newGuests = [self sortUsersByDisplayName: newGuests];

    guests = newGuests;
}

- (NSArray *)sortUsersByLastName: (NSArray *)userList {
    NSMutableArray *sortedGuests = (NSMutableArray *)[userList sortedArrayUsingComparator: ^(id a, id b) {
        User *first = ( User* ) a;
        User *second = ( User* ) b;
        return [first.lastName compare:second.lastName options:NSCaseInsensitiveSearch];
        
    }];
    
    return sortedGuests;
}

- (NSArray *)sortUsersByDisplayName: (NSArray *)userList {
    NSMutableArray *sortedGuests = (NSMutableArray *)[userList sortedArrayUsingComparator: ^(id a, id b) {
        User *first = ( User* ) a;
        User *second = ( User* ) b;
        return [first.displayName compare:second.displayName options:NSCaseInsensitiveSearch];
        
    }];
    
    return sortedGuests;
}


- (void)sortSocialNetworkTypes:(NSDictionary *)socialNetworkTypeDict {
    
    self.sortedSocialNetworkTypes = [[socialNetworkTypeDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
}


- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return self.sortedSocialNetworkTypes[idx];
}

- (NSArray *)filterBySocialNetwork:(NSString *)key
{
    
    
    SocialNetworkType slType = [SocialNetworkUtilities formatStringToType:(NSString *)key];
    
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.slType == %u", slType];
//    
    NSMutableArray *myAttendees = [[self allGuests] mutableCopy];
    

    NSIndexSet* indexes = [myAttendees indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        User *user= (User *)obj;
        BOOL isMatch = NO;
        if([user slType] == slType)
            isMatch = TRUE;
        return isMatch;
    }];
    
    NSArray* newArray = [myAttendees objectsAtIndexes:indexes];
    
    return newArray;
    
    
//////    [array filte]
////    
////    [myAttendees filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id attendee, NSDictionary *bindings) {
////        return [[(User *)attendee slType] matches:slType];
////    }];
//    [myAttendees filterUsingPredicate:predicate];
//    
//    return myAttendees;

//
//    return dictionary[key];
}

@end
