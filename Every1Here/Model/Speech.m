//
//  Speech.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/27/14.
//  Copyright (c) 2014 Brilliant Age. All rights reserved.
//

#import "Speech.h"

@implementation Speech
@synthesize evaluatorId;
@synthesize eventId;
@synthesize userId;
@synthesize title;
@synthesize tmCCId;
@synthesize hasIntro;

- (id)initWithTitle:(NSString *)aTitle
            eventId:(NSString *)anEventId
             userId:(NSString *)aUserId
             tmCCId:(NSString *)aTMCCId
        evaluatorId:(NSString *)anEvaluatorId
        hasIntro:(BOOL)aSpeechIntro
{
    if (self = [super init]) {
        self.eventId = [anEventId copy];
        self.userId = [aUserId copy];
        self.evaluatorId= [anEvaluatorId copy];
        self.tmCCId = [aTMCCId copy];
        self.title = [aTitle copy];
        self.hasIntro = aSpeechIntro;
        
        anEventId = aUserId = anEvaluatorId= aTitle= aTMCCId = nil;
        
        
    }
    return self;
}

- (id)init
{
    return [self initWithTitle:nil eventId:nil userId:nil tmCCId:nil evaluatorId:nil hasIntro:NO];
}
@end
