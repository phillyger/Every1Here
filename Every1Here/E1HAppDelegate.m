//
//  AppDelegate.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/11/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

//

#import "E1HAppDelegate.h"


#define AccountTwitterSelectedAccountIdentifier @"TwitterAccountSelectedAccountIdentifier"

#define E1HParseDotComAccountGroupNameIdentifier @"E1HParseDotComAccountGroupNameIdentifier"
#define E1HParseDotComAccountOrgIdentifier @"E1HParseDotComAccountOrgIdentifier"
#define E1HParseDotComAccountEventStatusOnLaunchIdentifier @"E1HParseDotComAccountEventStatusOnLaunchIdentifier"
#define E1HParseDotComAccountUserAccountPasswordIdentifier @"E1HParseDotComAccountUserAccountPasswordIdentifier"


@implementation E1HAppDelegate
@synthesize parseDotComAccountOrgId;
@synthesize parseDotComAccountGroupName;
@synthesize parseDotComAccountEventStatusOnLaunch;
@synthesize parseDotComAccountUserAccountPassword;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
//      [Parse setApplicationId:@"CzxhhRu2NJF9o1IM85xkRedx2ySoaA6G4rv4jRkc" clientKey:@"6BuCDoxhifysHp7hZlEWlilhUAintOPOlh3MKzDh"];

    //
    // If you are using Facebook, uncomment and fill in with your Facebook App Id:
    // [PFFacebookUtils initializeWithApplicationId:@"your_facebook_app_id"];
    // ****************************************************************************
    
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:E1HParseDotComAccountOrgIdentifier];
	if (testValue == nil)
	{
        NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
        
        __block NSString *parseDotComAccountGroupNameDefault;
        __block NSString *parseDotComAccountOrgIdDefault;
        __block NSString *parseDotComAccountEventStatusOnLaunchDefault;
        __block NSString *parseDotComAccountUserAccountPasswordDefault;
        
        [prefSpecifierArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

            
            NSDictionary *prefItem = (NSDictionary *)obj;
            NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
            if ([keyValueStr isEqualToString:E1HParseDotComAccountGroupNameIdentifier])
			{
				parseDotComAccountGroupNameDefault = defaultValue;
			}
			else if ([keyValueStr isEqualToString:E1HParseDotComAccountOrgIdentifier])
			{
				parseDotComAccountOrgIdDefault = defaultValue;
			} else if ([keyValueStr isEqualToString:E1HParseDotComAccountEventStatusOnLaunchIdentifier])
            {
                       parseDotComAccountEventStatusOnLaunchDefault = defaultValue;
            } else if ([keyValueStr isEqualToString:E1HParseDotComAccountUserAccountPasswordIdentifier])
            {
                parseDotComAccountUserAccountPasswordDefault = defaultValue;
            }
        }];

        // since no default values have been set (i.e. no preferences file created), create it here
		NSDictionary *appDefaults = @{E1HParseDotComAccountGroupNameIdentifier: parseDotComAccountGroupNameDefault,
                                E1HParseDotComAccountOrgIdentifier : parseDotComAccountOrgIdDefault,
                                E1HParseDotComAccountEventStatusOnLaunchIdentifier: parseDotComAccountEventStatusOnLaunchDefault,
                                E1HParseDotComAccountUserAccountPasswordIdentifier: parseDotComAccountUserAccountPasswordDefault};
        
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    // we're ready to do, so lastly set the key preference values
	parseDotComAccountGroupName = [[NSUserDefaults standardUserDefaults] stringForKey:E1HParseDotComAccountGroupNameIdentifier];
	parseDotComAccountOrgId = [[NSUserDefaults standardUserDefaults] stringForKey:E1HParseDotComAccountOrgIdentifier];
    parseDotComAccountEventStatusOnLaunch = [[NSUserDefaults standardUserDefaults] stringForKey:E1HParseDotComAccountEventStatusOnLaunchIdentifier];
    parseDotComAccountUserAccountPassword = [[NSUserDefaults standardUserDefaults] stringForKey:E1HParseDotComAccountUserAccountPasswordIdentifier];
    self.accountStore = [[ACAccountStore alloc] init];

    return YES;

    
}
- (void)getFacebookAccount
{
    // 1
    ACAccountType *facebookAccountType = [self.accountStore
                                          accountTypeWithAccountTypeIdentifier:
                                          ACAccountTypeIdentifierFacebook];
    // 2
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 3
        NSDictionary *facebookOptions = @{
        ACFacebookAppIdKey : @"520454277987721",
        ACFacebookPermissionsKey : @[@"email", @"read_stream",
        @"user_relationships", @"user_website"],
        ACFacebookAudienceKey : ACFacebookAudienceEveryone };
        // 4
        [self.accountStore
         requestAccessToAccountsWithType:facebookAccountType
         options:facebookOptions completion:^(BOOL granted,
                                              NSError *error) {
             // 5
             if (granted)
             {
                 [self getPublishStream];
             }
             // 6
             else
             {
                 // 7
                 if (error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                                             message:@"There was an error retrieving your Facebook account,make sure you have an account setup in Settings and that access is granted for iSocial"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Dismiss"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
                 // 8
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc]
                                                   initWithTitle:@"Facebook"
                                                   message:@"Access to Facebook was not granted. Please go to the device settings and allow access for iSocial"
                                                   delegate:nil
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
             }
         }];
    });
}

- (void)getPublishStream {
    // 1
    ACAccountType *facebookAccountType = [self.accountStore
                                          accountTypeWithAccountTypeIdentifier:
                                          ACAccountTypeIdentifierFacebook];
    // 2
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 3
        NSDictionary *facebookOptions = @{
        ACFacebookAppIdKey : @"520454277987721",
        ACFacebookPermissionsKey : @[@"publish_stream"],
        ACFacebookAudienceKey : ACFacebookAudienceEveryone };
        // 4
        [self.accountStore
         requestAccessToAccountsWithType:facebookAccountType
         options:facebookOptions completion:^(BOOL granted,
                                              NSError *error) {
             // 5
             if (granted)
             {
                 self.facebookAccount = [[self.accountStore
                                          accountsWithAccountType:facebookAccountType]
                                         lastObject];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName: AccountFacebookAccountAccessGranted
                      object:nil];
                 });
             }
             // 6
             else
             {
                 // 7
                 if (error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                                             message:@"There was an error retrieving your Facebook account, make sure you have an account setup in Settings and that access is granted for iSocial"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Dismiss"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
                 // 8
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView
                                                    alloc] initWithTitle:@"Facebook"
                                                   message:@"Access to Facebook was not granted. Please go to the device settings and allow access for iSocial"
                                                   delegate:nil
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
             }
         }];
    });
}

- (void)getTwitterAccount
{
    ACAccountType *twitterAccountType = [self.accountStore
                                         accountTypeWithAccountTypeIdentifier:
                                         ACAccountTypeIdentifierTwitter];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:nil completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 // 1
                 NSArray *twitterAccounts = [self.accountStore
                                             accountsWithAccountType:twitterAccountType];
                 // 2
                 NSString *twitterAccountIdentifier =
                 [[NSUserDefaults standardUserDefaults]
                  objectForKey:
                  AccountTwitterSelectedAccountIdentifier];
                 self.twitterAccount = [self.accountStore
                                        accountWithIdentifier:
                                        twitterAccountIdentifier];
                 // 3
                 if (self.twitterAccount)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:
                          AccountTwitterAccountAccessGranted
                          object:nil];
                     });
                 }
                 else
                 {
                     // 4
                     [[NSUserDefaults standardUserDefaults]
                      removeObjectForKey:
                      AccountTwitterSelectedAccountIdentifier];
                     [[NSUserDefaults standardUserDefaults]
                      synchronize];
                     // 5
                     if (twitterAccounts.count > 1)
                     {
                         UIAlertView *alertView = [[UIAlertView alloc]
                                                   initWithTitle:@"Twitter"
                                                   message:@"Select one of your Twitter Accounts"
                                                   delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:nil];
                         for (ACAccount *account in
                              twitterAccounts)
                         {
                             [alertView addButtonWithTitle:
                              account.accountDescription];
                         }
                         dispatch_async(
                                        dispatch_get_main_queue(), ^{
                                            [alertView show];
                                        });
                     }
                     // 6
                     else
                     {
                         self.twitterAccount =
                         [twitterAccounts lastObject];
                         dispatch_async(
                                        dispatch_get_main_queue(), ^{
                                            [[NSNotificationCenter
                                              defaultCenter]
                                             postNotificationName:
                                             AccountTwitterAccountAccessGranted
                                             object:nil];
                                        });
                     }
                 }
             }
             else
             {
                 if (error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc]
                                                   initWithTitle:@"Twitter"
                                                   message:@"There was an error retrieving your Twitter account, make sure you have an account setup in Settings and that access is granted for iSocial"
                                                   delegate:nil
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc]
                                                   initWithTitle:@"Twitter"
                                                   message:@"Access to Twitter was not granted. Please go to the device settings and allow access for iSocial"
                                                   delegate:nil
                                                   cancelButtonTitle:@"Dimiss"
                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
             }
         }];
    });
}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        NSArray *twitterAccounts = [self.accountStore
                                    accountsWithAccountType:twitterAccountType];
        self.twitterAccount =
        twitterAccounts[(buttonIndex - 1)];
        [[NSUserDefaults standardUserDefaults]
         setObject:self.twitterAccount.identifier
         forKey:AccountTwitterSelectedAccountIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:
         AccountTwitterAccountAccessGranted object:nil];
    }
}


- (void)presentErrorWithMessage:(NSString *)errorMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:errorMessage
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [alertView show];
    });
}


@end
