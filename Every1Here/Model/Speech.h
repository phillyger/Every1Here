//
//  Speech.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/27/14.
//  Copyright (c) 2014 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Speech : NSObject

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *eventId;
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *tmCCId;
@property (nonatomic, strong)NSString *evaluatorId;
@property (nonatomic, getter = hasIntro)BOOL hasIntro;
@property (nonatomic, strong)NSString *speakingOrder;

- (id)initWithTitle:(NSString*)aTitle
            eventId:(NSString*)anEventId
            userId:(NSString*)aUserId
           tmCCId:(NSString*)aTMCCId
           evaluatorId:(NSString*)anEvaluatorId
        hasIntro:(BOOL)aSpeechIntro
      speakingOrder:(NSString*)aSpeakingOrder;

@end
