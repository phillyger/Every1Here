//
//  EventRoleBase.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/18/14.
//  Copyright (c) 2014 Brilliant Age. All rights reserved.
//

#import "EventRoleBase.h"
#import "Speech.h"

@implementation EventRoleBase
@synthesize eventRoles;
@synthesize attendance;
@synthesize guestCount;
@synthesize speech;


-(instancetype)initWithUser:(User *)aUser effective:(EffectiveDateRange *)anEffectiveDateRange {
    if (self = [super initWithUser:aUser effective:anEffectiveDateRange]) {
        
        meetingRoleBindToFields = [[NSArray alloc] init];
        meetingRoleDict = [[NSDictionary alloc] init];
        meetingRoleIconDict = [[NSDictionary alloc] init];
        meetingRoleCellColorHueDict = [[NSDictionary alloc] init];

        
         speech = [[Speech alloc] init];
    }
    return self;
}

- (instancetype)initWithUser:(User *)aUser {
    return  [self initWithUser:aUser effective:nil];
}

- (instancetype)init {
    return [self initWithUser:nil];
}


- (void)addRole:(NSString *)aSpec {
    return [super addRole:aSpec forKey:aSpec];
}

- (void)addRole:(NSString *)aSpec  forKey:(NSString *)aKey
{
    return [super addRole:aSpec forKey:aKey];
}

- (instancetype)getRole:(NSString *)aSpec {
    return [super getRole:aSpec];
}

- (BOOL)hasRole:(NSString *)aSpec {
    return [super hasRole:aSpec];
}

- (void)removeRole:(NSString *)aSpec {
    return [super removeRole:aSpec];
}

-(void)addRoleWithName:(NSString *)aSpec effectiveDateRangeStart:(NSDate *)effectiveStart effectiveDateRangeEnd:(NSDate *)effectiveEnd
{
    
}

- (NSDictionary *)mapFieldsToIconsMedium { return nil;}

- (NSDictionary *)mapFieldsToIconsSmall { return nil; }

- (NSDictionary *)mapFieldsToRoles {return nil;}

- (NSDictionary *)mapFieldsToCellColorHue {return nil;}

@end
