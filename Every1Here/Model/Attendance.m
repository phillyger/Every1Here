//
//  Attendance.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "Attendance.h"

@implementation Attendance
@synthesize eventId;
@synthesize eventRoles;
@synthesize guestCount;
@synthesize userId;

- (id)initWithEventId:(NSString*)anEventId
               userId:(NSString*)aUserId
            guestCount:(NSNumber*)aGuestCount
           eventRoles:(NSNumber*)aEventRoles
{
    if (self = [super init]) {
        self.eventId = [anEventId copy];
        self.userId = [aUserId copy];
        self.guestCount = aGuestCount;
        self.eventRoles = aEventRoles;

        
        anEventId = aUserId = nil;
        aGuestCount = aEventRoles = nil;
       
    }
    return self;
}

@end
