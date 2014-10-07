//
//  GuestPickerNavigationItem.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/2/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuestListViewCommunicatorDelegate.h"

@interface GuestListViewNavigationItem : UINavigationItem <GuestListViewCommunicatorDelegate>

@property (weak, nonatomic) id delegate;

// Designated Initializer
- (id)initWithDelegate:(id)delegate;
- (id)init;

@end
