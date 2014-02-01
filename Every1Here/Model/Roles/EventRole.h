//
//  EventRole.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRole.h"
//#import "NotPresentState.h"
//#import "InAttendanceState.h"

@class Speech;

typedef NS_OPTIONS(NSUInteger, TMEventRoles) {
    TM_None                  = 0,
    TM_Table_Topics_Speaker  = 1<<0,
    TM_Timer                 = 1<<1,
    TM_Grammarian            = 1<<2,
    TM_Ah_Counter            = 1<<3,
    TM_Evaluator             = 1<<4,
    TM_General_Evaluator     = 1<<5,
    TM_Table_Topics_Master   = 1<<6,
    TM_Speaker               = 1<<7,
    TM_Toastmaster           = 1<<8,
};

@interface EventRole : UserRole
{
    NSArray *meetingRoleBindToFields;
    NSDictionary *meetingRoleDict;
    NSDictionary *meetingRoleIconDict;
    NSDictionary *meetingRoleCellColorHueDict;
    
}

@property (nonatomic) TMEventRoles eventRoles;
@property (nonatomic, getter = isAttending) BOOL attendance;
@property (nonatomic) Speech *speech;
@property (nonatomic) NSInteger guestCount;


- (NSDictionary *)mapFieldsToIconsMedium;
- (NSDictionary *)mapFieldsToIconsSmall;
- (NSDictionary *)mapFieldsToRoles;
- (NSDictionary *)mapFieldsToCellColorHue;

@end
