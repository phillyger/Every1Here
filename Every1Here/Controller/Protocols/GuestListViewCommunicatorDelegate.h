//
//  GuestPickerViewControllerDelegate.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/2/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GuestListViewCommunicatorDelegate <NSObject>

/**
 * The communicator received a response from the the twitter selection.
 */
- (void)receivedTwitterEvent:(id)sender;

- (void)receivedMeetupEvent:(id)sender;

- (void)receivedFacebookEvent:(id)sender;

- (void)receivedLinkedInEvent:(id)sender;

@end
