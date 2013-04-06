//
//  GuestListSection.m
//  Anseo
//
//  Created by Ger O'Sullivan on 3/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestAttendeeListSection.h"

@interface GuestAttendeeListSection ()
    @property(nonatomic, strong, readwrite)NSMutableArray *users;
@end

@implementation GuestAttendeeListSection


- (id)initWithArray:(NSArray *)array
{
    if ((self = [super init])) {
        self.users = [array mutableCopy];
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return self.users[idx];
}


@end
