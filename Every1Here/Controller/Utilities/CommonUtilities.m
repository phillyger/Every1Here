//
//  CommonUtilities.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/9/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "CommonUtilities.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "E1HAppDelegate.h"

@interface CommonUtilities ()

@end

@implementation CommonUtilities

/*---------------------------------------------------------------------------
 * Using the Named Class paramaters pList, 
 * generate the associated field mapping value
 *--------------------------------------------------------------------------*/

+ (NSDictionary *)generateValueDictWithObject:(id)anObject forNamedClass:(NSString *)namedClass {
    
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:namedClass ofType:@"plist"];
    NSDictionary *pListInfoDict = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    
    //-------------------------------------------------------
    // Enumerate through pList to process field types.
    // Values with prefix of '@' must be handled on case-by-case basis.
    // Supported Types:
    //
    // @password    - default password for new user accounts (they will be forced to reset when first used)
    // @boolean     - sets a boolean value
    // @date        - sets the current date time.
    //-------------------------------------------------------
    
    [pListInfoDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //        [dataDict setObject:[anObject objectForKey:key] forKey:key];
        NSString *thisKey = key;
        NSString *thisObj = obj;
        
        if ([thisObj hasPrefix:@"@"]) {
            if ([thisObj isEqualToString:@"@password"]) {
                E1HAppDelegate *appDelegate = (E1HAppDelegate *)[[UIApplication sharedApplication] delegate];
                
                [dataDict setValue:appDelegate.parseDotComAccountUserAccountPassword forKeyPath:thisKey];

            } else if ([thisObj isEqualToString:@"@boolean"]) {
                [dataDict setValue:[NSNumber numberWithBool:TRUE] forKey:thisKey];
            
            } else if ([thisObj isEqualToString:@"@date"]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
                NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
                NSString *thisKeyPathIso = @"iso";
                NSString *thisKeyPathType = @"__type";
                
                NSDictionary *dateParams = @{thisKeyPathType : @"Date",
                                             thisKeyPathIso : formattedDate};
                
                [dataDict setValue:dateParams forKey:thisKey];

            }
        } else {
            [dataDict setValue:[anObject valueForKeyPath:thisObj] forKeyPath:thisKey];
        }
        
     
    }];
    
    
    return [dataDict copy];

}

/*---------------------------------------------------------------------------
 * Using the Named Class paramaters pList,
 * fetches the uri endpoint from the associated field mapping.
 *--------------------------------------------------------------------------*/

+ (NSString *)fetchUriEndPointFromPListForNamedClass:(NSString *)namedClass {
    
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:@"Classes" ofType:@"plist"];
    NSDictionary *classPathInfoDict = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    
    NSString *uriEndPointForNamedClass = [NSString stringWithFormat:@"%@", [classPathInfoDict objectForKey:namedClass]];
    
    return uriEndPointForNamedClass;
}


/*---------------------------------------------------------------------------
 * Converts the enum type UserType to NSString.
 *--------------------------------------------------------------------------*/
+ (NSString *) convertUserTypeToNamedClass:(UserTypes)userType {
    NSString *namedClass = nil;
    
    switch (userType) {
        case Member:
            namedClass = @"Member";
            break;
        case Guest:
            namedClass = @"Guest";
        default:
            break;
    }
    return namedClass;
}


/*---------------------------------------------------------------------------
 * Shows the Progress HUD  
 *--------------------------------------------------------------------------*/
+(void)showProgressHUD:(UIView *)view {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.dimBackground = YES;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    hud.labelText = @"Loading..";
    [hud show:TRUE];
}

/*---------------------------------------------------------------------------
 * Hides the Progress HUD
 *--------------------------------------------------------------------------*/
+ (void)hideProgressHUD:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
