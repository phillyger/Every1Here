//
//  MemberBuilder.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/25/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberBuilder.h"
#import "User.h"
#import "UserBuilder.h"
#import "EventRole.h"

@implementation MemberBuilder

- (NSArray *)membersFromJSON:(NSDictionary *)memberDict withAttendance:(NSDictionary *)attendanceDict withEventId:(NSString *)eventId error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(memberDict != nil);
//    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
    NSError *localError = nil;
    NSArray *attendance;
    
//    id jsonObject = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0 error: &localError];
    NSDictionary *parsedObject = (id)memberDict;
    if (parsedObject == nil) {
        if (error != NULL) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
            if (localError != nil) {
                [userInfo setObject: localError forKey: NSUnderlyingErrorKey];
            }
            *error = [NSError errorWithDomain:MemberBuilderErrorDomain code: MemberBuilderInvalidJSONError userInfo: userInfo];
        }
        return nil;
    }
    NSArray *members = [parsedObject objectForKey: @"results"];
    if (members == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:MemberBuilderErrorDomain code: MemberBuilderMissingDataError userInfo:nil];
        }
        return nil;
    }
    
    if (attendanceDict) 
       attendance = [attendanceDict objectForKey: @"results"];
       
    // Mutable dictionary to allow us to add the eventId
    NSMutableDictionary *memberWIthEventId = [[NSMutableDictionary alloc] init];
    
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity: [members count]];
    for (NSDictionary *member in members) {
        User *user = [[User alloc] init];
        
        // Append the eventId to dictionary values
        memberWIthEventId = [member mutableCopy];
        [memberWIthEventId setObject:eventId forKey:@"eventId"];
       
        
        user = [UserBuilder memberFromDictionary: memberWIthEventId];
        
        [user addRole:@"MemberRole"];
        [user addRole:@"EventRole"];
        
        if (attendance) {
            
            [attendance enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *attendanceRow = (NSDictionary *)obj;
                EventRole *thisEventRole = [user getRole:@"EventRole"];
                NSString *attendanceUserId = (NSString *)[attendanceRow objectForKey:@"userId"];
                NSString *memberUserId = [user userId];
                //NSLog(@"userId - attendanceRow : %@ for %@", attendanceUserId, [user displayName]);
                //NSLog(@"userId - user: %@ for %@", memberUserId, [user displayName]);
                
                /**
                 *  Traverse the list of users and set the event roles attributes accordingly.
                 **/
                if ([attendanceUserId isEqualToString:memberUserId]) {
                    [user setAttendanceId:[attendanceRow objectForKey:@"objectId"]];
                    [thisEventRole setEventRoles: [[attendanceRow objectForKey:@"eventRoles"]unsignedIntValue]];
                    [thisEventRole setAttendance:TRUE];
                    [thisEventRole setGuestCount:[[attendanceRow objectForKey:@"guestCount"]unsignedIntValue]];
                }
            }];
            
                        
        }
        [results addObject: user];
        memberWIthEventId = nil;
    }
    return [results copy];
    
    
}


@end

NSString *MemberBuilderErrorDomain = @"MemberBuilderErrorDomain";
