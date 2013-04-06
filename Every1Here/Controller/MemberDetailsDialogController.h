//
//  MemberDetailDialogController.h
//  Anseo
//
//  Created by Ger O'Sullivan on 3/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "QuickDialogController.h"
#import "QuickDialogEntryElementDelegate.h"
#import "User.h"


typedef void (^DetailViewControllerCompletionBlock)(BOOL success);

@interface MemberDetailsDialogController : QuickDialogController <QuickDialogStyleProvider, QuickDialogEntryElementDelegate>

@property (nonatomic, strong) User *userToEdit;
@property (nonatomic, assign, getter=isNewUser) BOOL *newUser;
//@property (nonatomic, assign, getter=isNewUser) BOOL *newAttendance;
@property (nonatomic, copy) DetailViewControllerCompletionBlock completionBlock;


@end
