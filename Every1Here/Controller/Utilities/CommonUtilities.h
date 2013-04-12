//
//  CommonUtilities.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/9/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface CommonUtilities : NSObject

+ (NSDictionary *)generateValueDictWithObject:(id)anObject forNamedClass:(NSString *)namedClass;
+ (NSString *)fetchUriEndPointFromPListForNamedClass:(NSString *)namedClass;
+ (NSString *)serializeRequestParmetersWithDictionary:(NSDictionary *)dict;
+ (NSString *) convertUserTypeToNamedClass:(UserTypes)userType;


+(void)showProgressHUD:(UIView *)view;
+(void)hideProgressHUD:(UIView *)view;

@end
