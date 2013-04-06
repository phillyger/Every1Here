//
//  AttendanceState.h
//  Anseo
//
//  Created by Ger O'Sullivan on 3/30/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AttendanceStateDelegate <NSObject>

- (void)insertAttendance;
- (void)updateAttendance;
- (void)deleteAttendance;

@end
