//
//  UserRole.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "UserRole.h"
#import "User.h"


@implementation UserRole


- (id)initWithUser:(User *)aUser
{
    return [self initWithUser:aUser effective:nil];
}


// Designated Initializer
-(id)initWithUser:(User *)aUser effective:(EffectiveDateRange *)anEffectiveDateRange
{
    if (self = [super init]) {
        user = aUser;
        effective = anEffectiveDateRange;
    }
    return self;
}

// Overridden inherited Designated Initializer
- (id)init
{
    return [self initWithUser:nil effective:nil];
}

- (void)addRole:(NSString *)aSpec {
    return [user addRole:aSpec forKey:aSpec];
}

- (void)addRole:(NSString *)aSpec forKey:(NSString *)aKey
{
    return [user addRole:aSpec forKey:aKey];
}

- (void)addRoleWithName:(NSString *)aSpec effectiveDateRangeStart:(NSDate *)effectiveStart effectiveDateRangeEnd:(NSDate *)effectiveEnd
{
    return [user addRole:aSpec];
}

- (instancetype)getRole:(NSString *)aSpec {
    return [user getRole:aSpec];
}

- (BOOL)hasRole:(NSString *)aSpec {
    return [user hasRole:aSpec];
}

- (void)removeRole:(NSString *)aSpec {
    return [user removeRole:aSpec];
}


- (BOOL)hasEffectiveDateRange:(NSString *)aSpec {
    return [user hasEffectiveDateRange:aSpec];
}

- (EffectiveDateRange *)effective
{
    return effective;
}

-(void)addEffectiveDateRangeStart:(NSDate *)aStartDate end:(NSDate *)anEndDate
{
    //effective = [[EffectiveDateRange alloc] initWithStartDate:aStartDate endDate:anEndDate];
    
}


@end
