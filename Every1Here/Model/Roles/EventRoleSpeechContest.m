//
//  EventRoleSpeechContest.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/18/14.
//  Copyright (c) 2014 Brilliant Age. All rights reserved.
//

#import "EventRoleSpeechContest.h"

@implementation EventRoleSpeechContest

-(instancetype)initWithUser:(User *)aUser effective:(EffectiveDateRange *)anEffectiveDateRange {
    if (self = [super initWithUser:aUser effective:anEffectiveDateRange]) {
        

        meetingRoleBindToFields = @[@"isEvaluator",
                                    @"isSpeaker",
                                    @"isContestBallotCounter",
                                    @"isContestTimer",
                                    @"isContestJudge",
                                    @"isContestChiefJudge",
                                    @"isContestChair"
                                    ];
        
        
        
    }
    return self;
}

- (instancetype)initWithUser:(User *)aUser {
    return  [self initWithUser:aUser effective:nil];
}

- (instancetype)init {
    return [self initWithUser:nil];
}


- (void)addRole:(NSString *)aSpec {
    return [super addRole:aSpec forKey:aSpec];
}

- (void)addRole:(NSString *)aSpec  forKey:(NSString *)aKey
{
    return [super addRole:aSpec forKey:aKey];
}

- (instancetype)getRole:(NSString *)aSpec {
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
                        meetingRoleBindToFields[0]:[NSNumber numberWithUnsignedInt:TM_Contest_Evaluator] ,
                        meetingRoleBindToFields[1]:[NSNumber numberWithUnsignedInt:TM_Contest_Speaker],
                        meetingRoleBindToFields[2]:[NSNumber numberWithUnsignedInt:TM_Contest_Ballot_Counter],
                        meetingRoleBindToFields[3]:[NSNumber numberWithUnsignedInt:TM_Contest_Timer],
                        meetingRoleBindToFields[4]:[NSNumber numberWithUnsignedInt:TM_Contest_Judge],
                        meetingRoleBindToFields[5]:[NSNumber numberWithUnsignedInt:TM_Contest_Chief_Judge],
                        meetingRoleBindToFields[6]:[NSNumber numberWithUnsignedInt:TM_Contest_Chair],
                        };
    
    return meetingRoleDict;
}

- (NSDictionary *)mapFieldsToIconsMedium {
    meetingRoleIconDict = @{meetingRoleBindToFields[0]:@"icon-mic-28x28.png",
                            meetingRoleBindToFields[1]:@"icon-globe-28x28.png",
                            meetingRoleBindToFields[3]:@"icon-evaluator-28x28.png",
                            meetingRoleBindToFields[2]:@"icon-evaluator-plus-28x28.png",
                            meetingRoleBindToFields[4]:@"icon-tts-28x28.png",
                            meetingRoleBindToFields[5]:@"icon-ttm-28x28.png",
                            meetingRoleBindToFields[6]:@"icon-timedial-28x28.png"  };
    
    return meetingRoleIconDict;
}

- (NSDictionary *)mapFieldsToIconsSmall {
    meetingRoleIconDict = @{meetingRoleBindToFields[0]:@"icon-mic-16x16.png",
                            meetingRoleBindToFields[1]:@"icon-globe-16x16.png",
                            meetingRoleBindToFields[3]:@"icon-evaluator-16x16.png",
                            meetingRoleBindToFields[2]:@"icon-evaluator-plus-16x16.png",
                            meetingRoleBindToFields[4]:@"icon-tts-16x16.png",
                            meetingRoleBindToFields[5]:@"icon-ttm-16x16.png",
                            meetingRoleBindToFields[6]:@"icon-timedial-16x16.png"  };
    
    return meetingRoleIconDict;
}

- (NSDictionary *)mapFieldsToCellColorHue {
    meetingRoleCellColorHueDict = @{meetingRoleBindToFields[0]:@.05,
                                    meetingRoleBindToFields[1]:@0.05,
                                    meetingRoleBindToFields[2]:@0.26,
                                    meetingRoleBindToFields[3]:@0.26,
                                    meetingRoleBindToFields[4]:@0.65,
                                    meetingRoleBindToFields[5]:@0.65,
                                    meetingRoleBindToFields[6]:@0.91
                                    };
    
    return meetingRoleCellColorHueDict;
}


@end
