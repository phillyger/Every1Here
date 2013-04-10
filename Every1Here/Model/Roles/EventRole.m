//
//  EventRole.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventRole.h"
//#import "InAttendanceState.h"
//#import "NotPresentState.h"
#import "AttendanceReceptionist.h"

@interface EventRole ()
//{
//    AttendanceState *notPresentState;
//    AttendanceState *inAttendanceState;
//}
@end

@implementation EventRole
@synthesize eventRoles;
@synthesize attendance;
@synthesize guestCount;

-(id)initWithUser:(User *)aUser effective:(EffectiveDateRange *)anEffectiveDateRange {
    if (self = [super initWithUser:aUser effective:anEffectiveDateRange]) {
        
        meetingRoleBindToFields = [[NSArray alloc] init];
        meetingRoleDict = [[NSDictionary alloc] init];
        meetingRoleIconDict = [[NSDictionary alloc] init];
        
        meetingRoleBindToFields = @[@"isSpeaker",
                                    @"isToastmaster",
                                    @"isGeneralEvaluator",
                                    @"isEvaluator",
                                    @"isTableTopicsMaster",
                                    @"isTableTopicsSpeaker",
                                    @"isTimer",
                                    @"isGrammarian",
                                    @"isAhCounter"
                                    ];

    }
    return self;
}

- (id)initWithUser:(User *)aUser {
    return  [self initWithUser:aUser effective:nil];
}

- (id)init {
    return [self initWithUser:nil];
}


- (void)addRole:(NSString *)aSpec {
    return [super addRole:aSpec];
}

- (EventRole *)getRole:(NSString *)aSpec {
    return [super getRole:aSpec];
}

- (BOOL)hasRole:(NSString *)aSpec {
    return [super hasRole:aSpec];
}

- (void)removeRole:(NSString *)aSpec {
    return [super removeRole:aSpec];
}

-(void)addRoleWithName:(NSString *)aSpec effectiveDateRangeStart:(NSDate *)effectiveStart effectiveDateRangeEnd:(NSDate *)effectiveEnd
{
    
}

- (void)mapFields {
    
}

- (NSDictionary *)mapFieldsToRoles {
    meetingRoleDict = @{
                        meetingRoleBindToFields[0]:[NSNumber numberWithUnsignedInt:TM_Speaker] ,
                        meetingRoleBindToFields[1]:[NSNumber numberWithUnsignedInt:TM_Toastmaster],
                        meetingRoleBindToFields[2]:[NSNumber numberWithUnsignedInt:TM_General_Evaluator],
                        meetingRoleBindToFields[3]:[NSNumber numberWithUnsignedInt:TM_Evaluator],
                        meetingRoleBindToFields[4]:[NSNumber numberWithUnsignedInt:TM_Table_Topics_Master],
                        meetingRoleBindToFields[5]:[NSNumber numberWithUnsignedInt:TM_Table_Topics_Speaker],
                        meetingRoleBindToFields[6]:[NSNumber numberWithUnsignedInt:TM_Timer],
                        meetingRoleBindToFields[7]:[NSNumber numberWithUnsignedInt:TM_Grammarian],
                        meetingRoleBindToFields[8]:[NSNumber numberWithUnsignedInt:TM_Ah_Counter]
                        };
    
    return meetingRoleDict;
}

- (NSDictionary *)mapFieldsToIconsMedium {
    meetingRoleIconDict = @{meetingRoleBindToFields[0]:@"icon-mic-28x28.png",
                            meetingRoleBindToFields[1]:@"icon-globe-28x28.png",
                            meetingRoleBindToFields[2]:@"icon-evaluator-plus-28x28.png",
                            meetingRoleBindToFields[3]:@"icon-evaluator-28x28.png",
                            meetingRoleBindToFields[4]:@"icon-tabletopics-28x28.png",
                            meetingRoleBindToFields[5]:@"icon-tabletopics-28x28.png",
                            meetingRoleBindToFields[6]:@"icon-timedial-28x28.png",
                            meetingRoleBindToFields[7]:@"icon-ab-28x28.png",
                            meetingRoleBindToFields[8]:@"icon-ahcounter-28x28.png"  };
    
    return meetingRoleIconDict;
}

- (NSDictionary *)mapFieldsToIconsSmall {
    meetingRoleIconDict = @{meetingRoleBindToFields[0]:@"icon-mic-16x16.png",
                            meetingRoleBindToFields[1]:@"icon-globe-16x16.png",
                            meetingRoleBindToFields[2]:@"icon-evaluator-plus-16x16.png",
                            meetingRoleBindToFields[3]:@"icon-evaluator-16x16.png",
                            meetingRoleBindToFields[4]:@"icon-tabletopics-16x16.png",
                            meetingRoleBindToFields[5]:@"icon-tabletopics-16x16.png",
                            meetingRoleBindToFields[6]:@"icon-timedial-16x16.png",
                            meetingRoleBindToFields[7]:@"icon-ab-16x16.png",
                            meetingRoleBindToFields[8]:@"icon-ahcounter-16x16.png"  };
    
    return meetingRoleIconDict;
}

@end
