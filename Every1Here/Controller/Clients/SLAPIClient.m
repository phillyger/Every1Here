//
//  AFTwitterDotComAPIClient.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/22/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "SLAPIClient.h"
#import "AnseoAppDelegate.h"

#define AccountTwitterSelectedAccountIdentifier @"TwitterAccountSelectedAccountIdentifier"
#define AccountTwitterAccessTokenAPIKey @"422865193-hukMktYoKq2yCheJe8hGmoIY5hGQie9PDizmANzW"
#define AccountTwitterAccessTokenSecretAPIKey @"w87ZR3ivAjZXrKNusl8wnsl7V3KPMt1eD96E1tzwPg"


@interface SLAPIClient ()
@property (strong, nonatomic) ACAccount *twitterAccount;

- (void)getTwitterAccount;
- (void)presentErrorWithMessage:(NSString *)errorMessage;
@end

@implementation SLAPIClient


+ (SLAPIClient *)sharedClient {
    static SLAPIClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SLAPIClient alloc] init];
    });
    
    return _sharedClient;
}


- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    [self storeTwitterAccountWithAccessToken:AccountTwitterAccessTokenAPIKey secret:AccountTwitterAccessTokenSecretAPIKey];
    
    
    return self;
}





- (void)storeTwitterAccountWithAccessToken:(NSString *)token secret:(NSString *)secret
{
    //  Each account has a credential, which is comprised of a verified token and secret
    ACAccountCredential *credential =
    [[ACAccountCredential alloc] initWithOAuthToken:token tokenSecret:secret];
    
    //  Obtain the Twitter account type from the store
    ACAccountType *twitterAcctType =
    [self accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Create a new account of the intended type
    ACAccount *newAccount = [[ACAccount alloc] initWithAccountType:twitterAcctType];
    
    //  Attach the credential for this user
    newAccount.credential = credential;
    
    //  Finally, ask the account store instance to save the account
    //  Note: that the completion handler is not guaranteed to be executed
    //  on any thread, so care should be taken if you wish to update the UI, etc.
    [self saveAccount:newAccount withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            // we've stored the account!
            NSLog(@"the account was saved!");
        }
        else {
            //something went wrong, check value of error
            NSLog(@"the account was NOT saved");
            
            // see the note below regarding errors...
            //  this is only for demonstration purposes
            if ([[error domain] isEqualToString:ACErrorDomain]) {
                
                // The following error codes and descriptions are found in ACError.h
                switch ([error code]) {
                    case ACErrorAccountMissingRequiredProperty:
                        NSLog(@"Account wasn't saved because "
                              "it is missing a required property.");
                        break;
                    case ACErrorAccountAuthenticationFailed:
                        NSLog(@"Account wasn't saved because "
                              "authentication of the supplied "
                              "credential failed.");
                        break;
                    case ACErrorAccountTypeInvalid:
                        NSLog(@"Account wasn't saved because "
                              "the account type is invalid.");
                        break;
                    case ACErrorAccountAlreadyExists:
                        NSLog(@"Account wasn't added because "
                              "it already exists.");
                        break;
                    case ACErrorAccountNotFound:
                        NSLog(@"Account wasn't deleted because"
                              "it could not be found.");
                        break;
                    case ACErrorPermissionDenied:
                        NSLog(@"Permission Denied");
                        break;
                    case ACErrorUnknown:
                    default: // fall through for any unknown errors...
                        NSLog(@"An unknown error occurred.");
                        break;
                }
            } else {
                // handle other error domains and their associated response codes...
                NSLog(@"%@", [error localizedDescription]);
            }
        }
    }];
}


- (void)getTwitterAccount
{
    ACAccountType *twitterAccountType = [self
                                         accountTypeWithAccountTypeIdentifier:
                                         ACAccountTypeIdentifierTwitter];
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self
         requestAccessToAccountsWithType:twitterAccountType
         options:nil completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 // 1
                 NSArray *twitterAccounts = [self
                                             accountsWithAccountType:twitterAccountType];
                 // 2
                 NSString *twitterAccountIdentifier =
                 [[NSUserDefaults standardUserDefaults]
                  objectForKey:
                  AccountTwitterSelectedAccountIdentifier];
                 self.twitterAccount = [self
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
        ACAccountType *twitterAccountType = [self
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        NSArray *twitterAccounts = [self
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
