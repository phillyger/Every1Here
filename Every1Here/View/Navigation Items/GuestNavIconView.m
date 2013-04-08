//
//  GuestNavIconView.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/1/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestNavIconView.h"


@implementation GuestNavIconView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




-(IBAction)popover:(id)sender
{
    NSLog(@"Clicked on button: %d",[sender tag]);

}


- (void)receivedMeetupEvent:(id)sender {
    NSLog(@"Received MEETUP event.");
//    [delegate didReceiveMeetupEvent:sender];
    
}

- (void)receivedTwitterEvent:(id)sender {
    NSLog(@"Received TWITTER event.");
//    [delegate didReceiveTwitterEvent:sender];
    
}

- (void)receivedFacebookEvent:(id)sender {
    NSLog(@"Received FACEBOOK event.");
//    [delegate didReceiveFacebookEvent:sender];
    
}

- (void)receivedLinkedInEvent:(id)sender {
    NSLog(@"Received LINKEDIN event.");
//    [delegate didReceiveLinkedInEvent:sender];
}

//
//- (void)receivedFacebookEvent:(id)sender {
//    NSLog(@"I TOUCHED FACEBOOK");
//    
//    [delegate didReceiveFacebookEvent:sender];
//}
//
//- (void)receivedLinkedInEvent:(id)sender {
//    NSLog(@"I TOUCHED LINKEDIN");
//    
//    [delegate didReceiveLinkedInEvent:sender];
//}
//
//- (void)receivedMeetupEvent:(id)sender {
//    NSLog(@"I TOUCHED MEETUP");
//    
//    [delegate didReceiveMeetupEvent:sender];
//}
//
//- (void)receivedTwitterEvent:(id)sender {
//    NSLog(@"I TOUCHED TWITTER");
//    
//    [delegate didReceiveTwitterEvent:sender];
//}


@end
