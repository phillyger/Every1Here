//
//  AttendanceBuilder.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Attendance;

@interface AttendanceBuilder : NSObject

/**
 * Given a dictionary that describes a person on Stack Overflow, create
 * a Person object with the supplied properties.
 */
+ (Attendance *) attendanceFromDictionary: (NSDictionary *) attendanceValues;


@end
