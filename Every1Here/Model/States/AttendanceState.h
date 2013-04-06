//
//  AttendanceState.h
//  Anseo
//
//  Created by Ger O'Sullivan on 3/30/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttendanceStateDelegate.h"

@class User;

@interface AttendanceState : NSObject <AttendanceStateDelegate>
{
    User *user;
}

@end
