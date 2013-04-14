//
//  AppDelegate.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/11/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AccountFacebookAccountAccessGranted @"FacebookAccountAccessGranted"
#define AccountTwitterAccountAccessGranted @"TwitterAccountAccessGranted"

@interface E1HAppDelegate : UIResponder <UIApplicationDelegate>


@property (nonatomic, retain) NSString	*parseDotComAccountGroupName;
@property (nonatomic, retain) NSNumber	*parseDotComAccountOrgId;
@property (nonatomic, retain) NSString	*parseDotComAccountEventStatusOnLaunch;
@property (nonatomic, retain) NSString	*parseDotComAccountUserAccountPassword;


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong, nonatomic) ACAccount *twitterAccount;
- (void)getFacebookAccount;
- (void)getTwitterAccount;
- (void)presentErrorWithMessage:(NSString *)errorMessage;

@end
