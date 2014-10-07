//
//  GuestPickerManagerDelegate.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/2/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GuestListViewManagerDelegate <NSObject>

- (void)didReceiveTwitterEvent:(id)sender;

- (void)didReceiveMeetupEvent:(id)sender;

- (void)didReceiveFacebookEvent:(id)sender;

- (void)didReceiveLinkedInEvent:(id)sender;

@end
