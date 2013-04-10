//
//  AttendanceBuilder.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AttendanceBuilder.h"
#import "Attendance.h"
#import "User.h"
#import "Event.h"

@implementation AttendanceBuilder

+ (Attendance *) attendanceFromDictionary: (NSDictionary *) attendanceValues  {
    
    
    
    NSString *eventId = attendanceValues[@"eventId"];
    NSString *userId = attendanceValues[@"userId"];
    NSNumber *guestCount = [NSNumber numberWithInteger:[attendanceValues[@"guestCount"] integerValue]];
    NSNumber *eventRoles = [NSNumber numberWithInteger:[attendanceValues[@"eventRoles"] integerValue]];
        
    Attendance *attendance = [[Attendance alloc] initWithEventId:eventId userId:userId guestCount:guestCount eventRoles:eventRoles];
    
    
    return attendance;
}

@end
