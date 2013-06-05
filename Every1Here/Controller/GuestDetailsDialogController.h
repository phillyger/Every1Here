//
//  GuestDetailsViewController.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/10/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "QuickDialogController.h"
#import "QuickDialogEntryElementDelegate.h"
#import "User.h"


typedef void (^DetailViewControllerCompletionBlock)(BOOL success);

@interface GuestDetailsDialogController : QuickDialogController <QuickDialogStyleProvider, QuickDialogEntryElementDelegate>

@property (nonatomic, strong) User *userToEdit;
@property (nonatomic, assign, getter=isNewUser) BOOL newUser;
@property (nonatomic, copy) DetailViewControllerCompletionBlock completionBlock;


@end

