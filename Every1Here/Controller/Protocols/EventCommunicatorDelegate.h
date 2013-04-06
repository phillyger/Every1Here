//
//  EventCommunicatorDelegate.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/23/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventCommunicatorDelegate <NSObject>

/**
 * The communicator received a response from the Parse fetch.
 */
- (void)receivedEventsJSON: (NSDictionary *)objectNotation;

/**
 * Trying to retrieve events failed.
 * @param error The error that caused the failure.
 */
- (void)fetchingEventsFailedWithError: (NSError *)error;

@end
