//
//  NotPresentState.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/30/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "NotPresentState.h"
#import "User.h"

@interface NotPresentState ()
{
    User *user;
}
@end


@implementation NotPresentState

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
