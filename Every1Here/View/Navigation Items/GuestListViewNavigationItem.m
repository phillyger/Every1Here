//
//  GuestPickerNavigationItem.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/2/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestListViewNavigationItem.h"
#import "GuestNavIconView.h"

@interface GuestListViewNavigationItem ()

@end

@implementation GuestListViewNavigationItem
@synthesize delegate;

- (id)initWithDelegate:(id)aDelegate {
    if (self = [super init]) {
        self.delegate = aDelegate;
        UINib *guestNavIconNib = [UINib nibWithNibName:@"GuestNavIconView" bundle:nil];
        GuestNavIconView *guestNavIconView = (GuestNavIconView *)[guestNavIconNib instantiateWithOwner:self options:nil][0];
        [guestNavIconView setDelegate:self];
        [self setTitleView:guestNavIconView];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self.delegate action:@selector(addNewGuest)];
        
//        [rightBarButtonItem setTarget:self.delegate];
//        [rightBarButtonItem setAction:@selector(addNewGuest)];
        
//        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.delegate action:@selector(dismissViewController)];
        
        NSString *backArrowString = @"\U000025C0\U0000FE0E"; //BLACK LEFT-POINTING TRIANGLE PLUS VARIATION SELECTOR
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backArrowString style:UIBarButtonItemStylePlain target:self.delegate action:@selector(dismissViewController)];
        
        self.rightBarButtonItem = rightBarButtonItem;
        self.leftBarButtonItem = leftBarButtonItem;
    }
    return self;
}

-(id)init {
    return [self initWithDelegate:nil];
}



- (void)receivedMeetupEvent:(id)sender {
    NSLog(@"Received MEETUP event.");
    [delegate didReceiveMeetupEvent:sender];

}

- (void)receivedTwitterEvent:(id)sender {
    NSLog(@"Received TWITTER event.");
    [delegate didReceiveTwitterEvent:sender];

}

- (void)receivedFacebookEvent:(id)sender {
    NSLog(@"Received FACEBOOK event.");
    [delegate didReceiveFacebookEvent:sender];
    
}

- (void)receivedLinkedInEvent:(id)sender {
    NSLog(@"Received LINKEDIN event.");
    [delegate didReceiveLinkedInEvent:sender];
}


@end
