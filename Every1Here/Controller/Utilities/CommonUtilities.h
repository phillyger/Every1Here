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
+ (BOOL) weekIsEqual:(NSDate *)date and:(NSDate *)otherDate;

+(void)showProgressHUD:(UIView *)view;
+(void)hideProgressHUD:(UIView *)view;

+(NSString*)transformDate:(NSDate*)date toDateFormat:(NSString*)dateFormat;
+ (NSDate *)transformDateString:(NSString *)dateString fromDateFormat:(NSString *)dateFormat;


+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
+ (NSInteger)numberOfDaysBetweenBaseDate:(NSDate *)baseDate offsetDate:(NSDate *)offsetDate;
+ (NSString*)convertDaysCountToLabelWithBaseDate:(NSDate *)baseDate offsetDate:(NSDate *)offsetDate;
@end
