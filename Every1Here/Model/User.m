//
//  User.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "User.h"
#import "UserRole.h"
//#import "InAttendanceState.h"
//#import "NotPresentState.h"
//#import "AttendanceReceptionist.h"


@implementation User
@synthesize objectId;
@synthesize userId;
@synthesize attendanceId;
@synthesize displayName, avatarURL;
@synthesize slType;
@synthesize primaryEmailAddr, secondaryEmailAddr;


// Designated Initializer
- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
       primaryEmailAddr:(NSString *)aPrimaryEmailAddr
     secondaryEmailAddr:(NSString *)aSecondaryEmailAddr
         avatarLocation:(NSString *)location
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId
                 slType:(SocialNetworkType)aSlType
{
    if (self = [super initWithFirstName:aFirstName
                               lastName:aLastName]) {
        if (nil != aFirstName && nil != aLastName) {
            displayName = [[NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName] copy];
        }
        
        if (location != nil)
            avatarURL = [[NSURL alloc] initWithString: location];
        
        slType = aSlType;
        
        primaryEmailAddr = [aPrimaryEmailAddr copy];
        secondaryEmailAddr = [aSecondaryEmailAddr copy];
        
        objectId = anObjectId;
        userId = aUserId;
        
        roles = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
         avatarLocation:(NSString *)anAvatarLocation
               objectId:(NSString *)anObjectId
                 userId:(NSString *)aUserId {
    return [self initWithFirstName:aFirstName
                          lastName:aLastName
                  primaryEmailAddr:nil
                secondaryEmailAddr:nil
                    avatarLocation:anAvatarLocation
                          objectId:anObjectId
                            userId:aUserId
                            slType:NONE];
    
}

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
         avatarLocation:(NSString *)anAvatarLocation {
    return [self initWithFirstName:aFirstName
                          lastName:aLastName
                  primaryEmailAddr:nil
                secondaryEmailAddr:nil
                    avatarLocation:anAvatarLocation
                          objectId:nil
                            userId:nil
                            slType:NONE];
    
}

- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName {
    return [self initWithFirstName:aFirstName lastName:aLastName avatarLocation:nil];

}

- (id)initWithDisplayName:(NSString *)aDisplayName
           avatarLocation:(NSString *)location
                   slType:(SocialNetworkType)aSlType{
    return [self initWithDisplayName:aDisplayName primaryEmailAddr:nil secondaryEmailAddr:nil avatarLocation:location slType:aSlType];
}


- (id)initWithDisplayName:(NSString *)aDisplayName
         primaryEmailAddr:(NSString *)aPrimaryEmailAddr
       secondaryEmailAddr:(NSString *)aSecondaryEmailAddr
           avatarLocation:(NSString *)location
                   slType:(SocialNetworkType)aSlType{
    if ((self = [self initWithFirstName:nil
                               lastName:nil
                       primaryEmailAddr:aPrimaryEmailAddr
                     secondaryEmailAddr:aSecondaryEmailAddr
                         avatarLocation:location
                               objectId:nil
                                 userId:nil
                                 slType:aSlType])) {
        displayName = [aDisplayName copy];
        aDisplayName = nil;
    }
    return self;
}


// Overridden inherited Designated Initializer
- (id)init
{
    return [self initWithFirstName:nil lastName:nil primaryEmailAddr:nil secondaryEmailAddr:nil avatarLocation:nil objectId:nil userId:nil slType:NONE];
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
