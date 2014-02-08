//
//  MemberDetailDialogController.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "QuickDialogController.h"
#import "QuickDialogEntryElementDelegate.h"
#import "User.h"

typedef void (^DetailViewControllerCompletionBlock)(BOOL success);
typedef void (^MemberDetailsDialogControllerCompletionBlock)(NSArray *list, NSArray *tmCCFields, BOOL success);

@interface MemberDetailsDialogController : QuickDialogController <QuickDialogEntryElementDelegate>

@property (nonatomic, strong) User *userToEdit;
@property (nonatomic, assign, getter=isNewUser) BOOL newUser;
@property (nonatomic, copy) DetailViewControllerCompletionBlock completionBlock;
@property (nonatomic, copy) MemberDetailsDialogControllerCompletionBlock successBlock;


- (void)fetchMemberListTableContentWithCompletionBlock:(MemberDetailsDialogControllerCompletionBlock)completionBlock;

@end
