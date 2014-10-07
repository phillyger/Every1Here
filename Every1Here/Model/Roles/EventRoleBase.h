//
//  EventRoleBase.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/18/14.
//  Copyright (c) 2014 Brilliant Age. All rights reserved.
//

#import "UserRole.h"

@class Speech;

typedef NS_OPTIONS(NSUInteger, TMEventRoles) {
    /* Regular Meeting */
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
    
    /* Contest Specific */
    TM_Contest_Evaluator        = 1<<9,
    TM_Contest_Speaker          = 1<<10,
    TM_Contest_Ballot_Counter   = 1<<11,
    TM_Contest_Timer            = 1<<12,
    TM_Contest_Judge            = 1<<13,
    TM_Contest_Chief_Judge      = 1<<14,
    TM_Contest_Chair            = 1<<15,
};


@protocol mappings <NSObject>

@required
- (NSDictionary *)mapFieldsToIconsSmall;
- (NSDictionary *)mapFieldsToRoles;

@optional
- (NSDictionary *)mapFieldsToCellColorHue;
- (NSDictionary *)mapFieldsToIconsMedium;

@end

@interface EventRoleBase : UserRole
{
    NSArray *meetingRoleBindToFields;
    NSDictionary *meetingRoleDict;
    NSDictionary *meetingRoleIconDict;
    NSDictionary *meetingRoleCellColorHueDict;
    
}

@property (nonatomic, getter = isAttending) BOOL attendance;
@property (nonatomic) Speech *speech;
@property (nonatomic) NSInteger guestCount;

@property (nonatomic) TMEventRoles eventRoles;

@end
