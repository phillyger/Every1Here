//
//  InAttendanceState.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/30/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "InAttendanceState.h"
#import "User.h"

@interface InAttendanceState ()
{
    User *user;
}
@end

@implementation InAttendanceState

- (id)initWithUser:(User *)aUser {
    if (self = [super init]) {
        user = aUser;
    }
    return self;
}

- (id)init {
    return [self initWithUser:nil];
}

- (void)insertAttendance {}

- (void)updateAttendance {}

- (void)deleteAttendance {}


@end
