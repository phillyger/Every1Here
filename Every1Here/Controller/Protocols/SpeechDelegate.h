//
//  SpeechDelegate.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/4/14.
//  Copyright (c) 2014 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpeechDelegate <NSObject>

/**
 * The manager successfully inserted a new speech record into Parse.com.
 */
- (void)didInsertSpeechWithOutput:(NSArray *)objectNotationList;


/**
 * The manager successfully updated an existing speech record into Parse.com.
 */
- (void)didUpdateSpeech;


/**
 * The manager successfully deleted an existing speech record into Parse.com.
 */
- (void)didDeleteSpeech;

@end
