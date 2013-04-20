//
//  GuestBuilder.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/25/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestBuilder.h"
#import "User.h"
#import "UserBuilder.h"
#import "EventRole.h"

@implementation GuestBuilder

- (NSArray *)usersFromJSON:(NSDictionary *)objectNotation
            withAttendance:(NSDictionary *)attendanceDict
               withEventId:(NSString *)eventId
         socialNetworkType:(SocialNetworkType)slType
                     error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(objectNotation != nil);

    NSError *localError = nil;
    NSArray *attendance;
    

    NSDictionary *parsedObject = (id)objectNotation;
    if (parsedObject == nil) {
        if (error != NULL) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
            if (localError != nil) {
                [userInfo setObject: localError forKey: NSUnderlyingErrorKey];
            }
            *error = [NSError errorWithDomain:GuestBuilderErrorDomain code: GuestBuilderInvalidJSONError userInfo: userInfo];
        }
        return nil;
    }
    
    NSArray *guests = nil;
    switch (slType) {
        case Meetup:
            guests = [self guestsFromMeetupJSON:parsedObject error:error];
            break;
        case Twitter:
            guests = [self guestsFromTwitterJSON:parsedObject error:error];
            break;
        default:
            guests = [parsedObject objectForKey: @"results"];
            break;
    }
    

    if (guests == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:GuestBuilderErrorDomain code: GuestBuilderMissingDataError userInfo:nil];
        }
        return nil;
    }

    if (attendanceDict)
        attendance = [attendanceDict objectForKey: @"results"];
    
    // Mutable dictionary to allow us to add the eventId
    NSMutableDictionary *guestWithEventId = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity: [guests count]];
    for (NSDictionary *guest in guests) {
        User *user = [[User alloc] init];
        [user addRole:@"GuestRole"];
        [user addRole:@"EventRole"];
        
        if (slType == NONE) {
            // Append the eventId to dictionary values
            guestWithEventId = [guest mutableCopy];
            [guestWithEventId setObject:eventId forKey:@"eventId"];
            
            
            user = [UserBuilder userFromDictionary:guestWithEventId socialNetworkType:slType forUserType:Guest];
            


            if (attendance) {
                
                [attendance enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *attendanceRow = (NSDictionary *)obj;
                    EventRole *thisEventRole = [user getRole:@"EventRole"];
                    NSString *attendanceUserId = (NSString *)[attendanceRow objectForKey:@"userId"];
                    NSString *userId = [user userId];
                    //NSLog(@"userId - attendanceRow : %@ for %@", attendanceUserId, [user displayName]);
                    //NSLog(@"userId - user: %@ for %@", memberUserId, [user displayName]);
                    
                    /**
                     *  Traverse the list of users and set the event roles attributes accordingly.
                     **/
                    if ([attendanceUserId isEqualToString:userId]) {
                        [user setAttendanceId:[attendanceRow objectForKey:@"objectId"]];
    //                    [thisEventRole setEventRoles: [[attendanceRow objectForKey:@"eventRoles"]unsignedIntValue]];
                        [thisEventRole setAttendance:TRUE];
                        [thisEventRole setGuestCount:[[attendanceRow objectForKey:@"guestCount"]unsignedIntValue]];
                    }
                }];
                
                
            }
        } else {
            
            user = [UserBuilder userFromDictionary:guest socialNetworkType:slType forUserType:Guest];
        }
        
        [results addObject: user];
        guestWithEventId = nil;
    }
    return [results copy];
    
}

- (NSArray *)guestsFromMeetupJSON:(NSDictionary *)parsedObject error:(NSError *__autoreleasing *)error
{
    return (NSArray *)[parsedObject objectForKey: @"results"];
}

- (NSArray *)guestsFromTwitterJSON:(NSDictionary *)parsedObject error:(NSError *__autoreleasing *)error
{
    return (NSArray *)[parsedObject objectForKey: @"users"];
}


@end

NSString *GuestBuilderErrorDomain = @"GuestBuilderErrorDomain";