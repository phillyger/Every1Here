//
//  GuestNavIconImageView.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/1/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestNavIconImageView.h"
#import "GuestNavIconView.h"
#import "GuestListViewNavigationItem.h"

@interface GuestNavIconImageView ()

@end

@implementation GuestNavIconImageView


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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    GuestNavIconView *navIconView = (GuestNavIconView *)[self superview];
//    GuestNavIconView *delegate = (GuestNavIconView *)[navIconView delegate];
    GuestListViewNavigationItem *delegate = (GuestListViewNavigationItem *)[navIconView delegate];
    
    NSLog(@"Tag : %ld", (long)[self tag]);
    switch ([self tag]) {
        case 0:
            // Meetup image was clicked
            [delegate receivedMeetupEvent:self];
            break;
        case 1:
            // Twitter image was clicked
            [delegate receivedTwitterEvent:self];
            break;
        case 2:
            //LinkedIn the image was clicked
            [delegate receivedLinkedInEvent:self];
            break;
        case 3:
            // Facebook the image was clicked
            [delegate receivedFacebookEvent:self];

            break;
        default:
            break;
    }
    
//    NSLog(@"-- I'M TOUCHED --");
}

@end

