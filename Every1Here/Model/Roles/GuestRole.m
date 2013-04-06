//
//  Guest.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestRole.h"

@implementation GuestRole


-(id)initWithUser:(User *)aUser effective:(EffectiveDateRange *)anEffectiveDateRange {
    return  [super initWithUser:aUser effective:anEffectiveDateRange];
}

- (id)initWithUser:(User *)aUser {
    return  [self initWithUser:aUser effective:nil];
}

- (id)init {
    return [self initWithUser:nil];
}

- (void)addRole:(NSString *)aSpec {
    return [super addRole:aSpec];
}

- (GuestRole *)getRole:(NSString *)aSpec {
    return [super getRole:aSpec];
}

- (BOOL)hasRole:(NSString *)aSpec {
    return [super hasRole:aSpec];
}

- (void)removeRole:(NSString *)aSpec {
    return [super removeRole:aSpec];
}


@end
