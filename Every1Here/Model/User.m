//
//  User.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "User.h"
#import "UserRole.h"



@implementation User
@synthesize objectId;
@synthesize userId;
@synthesize eventId;
@synthesize eventCode;
@synthesize attendanceId;
@synthesize speechId;
@synthesize displayName, avatarURL;
@synthesize slType;
@synthesize slUserId;
@synthesize primaryEmailAddr, secondaryEmailAddr;
@synthesize hasAttendanceRecord;
@synthesize hasUserRecord;
@synthesize hasSpeechInfoRecord;
@synthesize compComm;
@synthesize latestSpeechDate;
@synthesize latestSpeechId;

// Designated Initializer

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
            displayName:(NSString *)aDisplayName
       primaryEmailAddr:(NSString *)aPrimaryEmailAddr
     secondaryEmailAddr:(NSString *)aSecondaryEmailAddr
         avatarLocation:(NSString *)location
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId
                eventId:(NSString *)anEventId
              eventCode:(NSNumber *)anEventCode
                 slType:(SocialNetworkType)aSlType
               slUserId:(NSString *)aSocialNetworkUserId
               compComm:(NSNumber *)aCompComm
       latestSpeechDate:(NSDate *)aLatestSpeechDate
         latestSpeechId:(NSString *)aLatestSpeechId
{
    if (self = [super initWithFirstName:aFirstName
                               lastName:aLastName]) {

        if ((displayName == nil) && (nil != aFirstName && nil != aLastName)) {
            displayName = [[NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName] copy];
        } else {
            displayName = [aDisplayName copy];
        }
        
        if (location != nil)
            avatarURL = [[NSURL alloc] initWithString: location];
        
        slType = aSlType;
        slUserId = [aSocialNetworkUserId copy];
        
        primaryEmailAddr = [aPrimaryEmailAddr copy];
        secondaryEmailAddr = [aSecondaryEmailAddr copy];
        
        
        objectId = [anObjectId copy];
        userId = [aUserId copy];
        eventId = [anEventId copy];
        compComm = [aCompComm copy];

        latestSpeechDate = [aLatestSpeechDate copy];
        latestSpeechId = [aLatestSpeechId copy];
        
        eventCode = anEventCode;
        
        
        roles = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
       primaryEmailAddr:(NSString *)aPrimaryEmailAddr
     secondaryEmailAddr:(NSString *)aSecondaryEmailAddr
         avatarLocation:(NSString *)aLocation
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId
                 eventId:(NSString *)anEventId
              eventCode:(NSNumber *)anEventCode
                 slType:(SocialNetworkType)aSlType
               slUserId:(NSString *)aSocialNetworkUserId
               compComm:(NSNumber *)aCompComm
       latestSpeechDate:(NSDate *)aLatestSpeechDate
         latestSpeechId:(NSString *)aLatestSpeechId
{
    return [self initWithFirstName:aFirstName
                          lastName:aLastName
                       displayName:nil
                  primaryEmailAddr:aPrimaryEmailAddr
                secondaryEmailAddr:aSecondaryEmailAddr
                    avatarLocation:aLocation
                          objectId:anObjectId
                            userId:aUserId
                           eventId:anEventId
                          eventCode:anEventCode
                            slType:aSlType
                          slUserId:aSocialNetworkUserId
                        compComm:aCompComm
                        latestSpeechDate:aLatestSpeechDate
                    latestSpeechId:aLatestSpeechId];

}

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
         avatarLocation:(NSString *)anAvatarLocation
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId
                eventId:(NSString *)anEventId
              eventCode:(NSNumber *)anEventCode {
    return [self initWithFirstName:aFirstName
                          lastName:aLastName
                  primaryEmailAddr:nil
                secondaryEmailAddr:nil
                    avatarLocation:anAvatarLocation
                          objectId:anObjectId
                            userId:aUserId
                           eventId:anEventId
                          eventCode:anEventCode
                            slType:NONE
                          slUserId:nil
                          compComm:@0
                  latestSpeechDate:nil
                    latestSpeechId:nil];
    
}

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
         avatarLocation:(NSString *)anAvatarLocation
                eventId:(NSString *)anEventId
              eventCode:(NSNumber *)anEventCode{
    return [self initWithFirstName:aFirstName
                          lastName:aLastName
                  primaryEmailAddr:nil
                secondaryEmailAddr:nil
                    avatarLocation:anAvatarLocation
                          objectId:nil
                            userId:nil
                           eventId:anEventId
                         eventCode:anEventCode
                            slType:NONE
                          slUserId:nil
                          compComm:@0
                  latestSpeechDate:nil
                    latestSpeechId:nil];
    
}

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId
                eventId:(NSString *)anEventId
              eventCode:(NSNumber *)anEventCode{
    return [self initWithFirstName:aFirstName lastName:aLastName avatarLocation:nil objectId:anObjectId userId:aUserId eventId:anEventId eventCode:anEventCode];

}

- (id)initWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName {
    return [self initWithFirstName:aFirstName lastName:aLastName avatarLocation:nil eventId:nil eventCode:nil];
}

- (id)initWithDisplayName:(NSString *)aDisplayName
           avatarLocation:(NSString *)location
                 objectId:(NSString *)anObjectId
                   userId:(NSString *)aUserId
                  eventId:(NSString *)anEventId
                eventCode:(NSNumber *)anEventCode
                   slType:(SocialNetworkType)aSlType
                 slUserId:(NSString *)aSocialNetworkUserId
{
    return [self initWithDisplayName:aDisplayName primaryEmailAddr:nil secondaryEmailAddr:nil avatarLocation:location objectId:anObjectId userId:aUserId eventId:anEventId eventCode:anEventCode slType:aSlType slUserId:aSocialNetworkUserId compComm:@0 latestSpeechDate:nil latestSpeechId:nil];
}


- (id)initWithDisplayName:(NSString *)aDisplayName
         primaryEmailAddr:(NSString *)aPrimaryEmailAddr
       secondaryEmailAddr:(NSString *)aSecondaryEmailAddr
           avatarLocation:(NSString *)location
                 objectId:(NSString *)anObjectId
                   userId:(NSString *)aUserId
                  eventId:(NSString *)anEventId
                eventCode:(NSNumber *)anEventCode
                   slType:(SocialNetworkType)aSlType
                 slUserId:(NSString *)aSocialNetworkUserId
                 compComm:(NSNumber *)aCompComm
         latestSpeechDate:(NSDate *)aLatestSpeechDate
           latestSpeechId:(NSString *)aLatestSpeechId

{
    if ((self = [self initWithFirstName:nil
                               lastName:nil
                       primaryEmailAddr:aPrimaryEmailAddr
                     secondaryEmailAddr:aSecondaryEmailAddr
                         avatarLocation:location
                               objectId:anObjectId
                                 userId:aUserId
                                eventId:anEventId
                               eventCode:anEventCode
                                 slType:aSlType
                               slUserId:aSocialNetworkUserId
                               compComm:aCompComm
                       latestSpeechDate:aLatestSpeechDate
                         latestSpeechId:aLatestSpeechId])) {
        displayName = [aDisplayName copy];
        aDisplayName = nil;
    }
    return self;
}



// Overridden inherited Designated Initializer
- (id)init
{
//    return [self initWithFirstName:nil lastName:nil primaryEmailAddr:nil secondaryEmailAddr:nil avatarLocation:nil objectId:nil userId:nil eventId:nil slType:NONE slUserId:nil];
    return [self initWithFirstName:nil lastName:nil displayName:nil primaryEmailAddr:nil secondaryEmailAddr:nil avatarLocation:nil objectId:nil userId:nil eventId:nil eventCode:nil slType:NONE slUserId:nil compComm:@0 latestSpeechDate:nil latestSpeechId:nil];
}

- (id)getRole:(NSString *)aSpec
{
    id obj = [roles objectForKey:aSpec];
    return obj;
}

- (BOOL)hasRole:(NSString *)aSpec {
    return [[roles allKeys] containsObject:aSpec];
}

- (void)addRole:(NSString *)aSpec {
  
    id role = nil;
    if ((role =[self getRole:aSpec]) == nil) {
        // dynamically allocate the correct class
        Class roleClass =  NSClassFromString(aSpec);
        role = [[roleClass alloc] initWithUser:self effective:nil];
    }
    [roles setObject:role forKey:aSpec];
}

- (void)addRole:(NSString *)aSpec forKey:(NSString *)aKey{
    
    id role = nil;
    if ((role =[self getRole:aSpec]) == nil) {
        // dynamically allocate the correct class
        Class roleClass =  NSClassFromString(aSpec);
        role = [[roleClass alloc] initWithUser:self effective:nil];
    }
    [roles setObject:role forKey:aKey];
}

- (void)addRoleWithName:(NSString *)aSpec effectiveDateRangeStart:(NSDate *)effectiveStartDate effectiveDateRangeEnd:(NSDate *)effectiveEndDate
{
    [self addRole:aSpec];
    id role = [self getRole:aSpec];
    [role addEffectiveDateRangeStart:effectiveStartDate end:effectiveEndDate];
}

- (void)removeRole:(NSString *)aSpec {
    [roles removeObjectForKey:aSpec];
}

- (BOOL)hasEffectiveDateRange:(NSString *)aSpec
{
    if ([self hasRole:aSpec]) {
        id role = [roles objectForKey:aSpec];
        if (role != nil) {
            if ([role effective] != nil) {
                return TRUE;
            }
        }
    }
    return FALSE;
}


@end
