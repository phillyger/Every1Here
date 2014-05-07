//
//  GuestPickerViewController.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/27/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FPPopoverController.h"
#import "GuestListViewManagerDelegate.h"
#import "ParseDotComManagerDelegate.h"


@interface GuestListViewController : BaseViewController <FPPopoverControllerDelegate, GuestListViewManagerDelegate, ParseDotComManagerDelegate>



//- (void)didSelectPopoverRow:(NSUInteger)rowNum forSocialNetworkType:(SocialNetworkType)slType;
//- (void)didDeselectPopoverRow:(NSUInteger)rowNum forSocialNetworkType:(SocialNetworkType)slType;
- (void)userDidSelectGuestListNotification: (NSNotification *)note;
- (void)receivedGuestFullList:(NSArray *)guestFullList forKey:(NSString *)aKey;
- (void)updateTableContentsWithArray:(NSArray *)newGuestAttendeeList forKey:(NSString *)aKey;

@end
