//
//  GuestNavIconView.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/1/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuestListViewCommunicatorDelegate.h"
#import "GuestListViewManagerDelegate.h"

@interface GuestNavIconView : UIView <GuestListViewCommunicatorDelegate>

@property (weak, nonatomic) id <GuestListViewCommunicatorDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *iconTwitter;
@property (weak, nonatomic) IBOutlet UIImageView *iconMeetup;
@property (weak, nonatomic) IBOutlet UIImageView *iconLinkedIn;
@property (weak, nonatomic) IBOutlet UIImageView *iconFacebook;

- (IBAction)popover:(id)sender;

@end
