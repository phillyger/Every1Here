
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  CommonUtilities.m
 *
 *  Created by Ger O'Sullivan on 4/9/13.
 *  Copyright (c) 2013 Brilliant Age. All rights reserved.
 *
 *  A collection on common (static) methods that are used throughout the application
 *  
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

+ (NSDictionary *)generateValueCustomDictWithObject:(id)anObject forNamedClass:(NSString *)namedClass {
    
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:namedClass ofType:@"plist"];
    NSDictionary *pListInfoDict = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    NSString *dataTypeToNamedClassSeparator = @"::";
    
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
        
        NSDictionary *dict = (NSDictionary*)obj;
        
        NSString *thisKey = key;
        NSString *thisObj = obj;
        
        NSString* routeName = [dict valueForKeyPath:@"routeName"];
        NSString* dataType = [dict valueForKeyPath:@"dataType"];
        NSString* targetKeyPath = [dict valueForKeyPath:@"targetKeyPath"];
        NSString* sourceKeyPath = [dict valueForKeyPath:@"sourceKeyPath"];
        
        if ([dataType hasPrefix:@"@"]) {
            if ([dataType isEqualToString:@"@password"]) {
                E1HAppDelegate *appDelegate = (E1HAppDelegate *)[[UIApplication sharedApplication] delegate];
                
                [dataDict setValue:appDelegate.parseDotComAccountUserAccountPassword forKeyPath:targetKeyPath];
                
            } else if ([dataType isEqualToString:@"@boolean"]) {
                BOOL thisBool = [[anObject valueForKeyPath: sourceKeyPath] boolValue];
                [dataDict setValue:[NSNumber numberWithBool:thisBool] forKey:targetKeyPath];
                
            } else if ([dataType isEqualToString:@"@date"]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
                NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
                NSString *thisKeyPathIso = @"iso";
                NSString *thisKeyPathType = @"__type";
                
                NSDictionary *dateParams = @{thisKeyPathType : @"Date",
                                             thisKeyPathIso : formattedDate};
                
                [dataDict setValue:dateParams forKey:targetKeyPath];
                
            } else if ([dataType hasPrefix:@"@pointer"]) {
                
                
                NSString *thisObjectId = [anObject valueForKeyPath: sourceKeyPath];
                
                if (thisObjectId != nil) {
                    
//                    NSArray *dataTypeToNamedClass = [thisObj componentsSeparatedByString:dataTypeToNamedClassSeparator];
                    NSString *thisTargetClassName = routeName;

                    
                    // Ensure the namedClass attribute is present.
                    if (routeName != nil) {
                        //-------------------------------------------------------
                        // Set the target class to the second component attribute
                        // i.e. @pointer::namedClass
                        //-------------------------------------------------------
                        
                        NSString *thisKeyPathClassName = @"className";
                        NSString *thisKeyPathObjectId = @"objectId";
                        NSString *thisKeyPathType = @"__type";
                        
                        NSDictionary *relationsParams = @{thisKeyPathType : @"Pointer",
                                                          thisKeyPathClassName : thisTargetClassName,
                                                          thisKeyPathObjectId : thisObjectId};
                        
                        [dataDict setValue:relationsParams forKey:targetKeyPath];
                    }
                }
                
                
            } else if ([dataType isEqualToString:@"@string"]){
                NSURL *toStringObj = [anObject valueForKeyPath:sourceKeyPath];
                
                [dataDict setValue:[toStringObj absoluteString] forKeyPath:targetKeyPath];
            }
        } else {
            [dataDict setValue:[anObject valueForKeyPath:sourceKeyPath] forKeyPath:targetKeyPath];
        }
        
        
    }];
    
    
    return [dataDict copy];
    
}


/*---------------------------------------------------------------------------
 * Using the Named Class paramaters pList, 
 * generate the associated field mapping value
 *--------------------------------------------------------------------------*/

+ (NSDictionary *)generateValueDictWithObject:(id)anObject forNamedClass:(NSString *)namedClass {
    
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:namedClass ofType:@"plist"];
    NSDictionary *pListInfoDict = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    NSString *dataTypeToNamedClassSeparator = @"::";
    
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

            } else if ([thisObj hasPrefix:@"@pointer"]) {
            
                
                NSString *thisObjectId = [anObject valueForKeyPath: thisKey];

                if (thisObjectId != nil) {
                    
                    NSArray *dataTypeToNamedClass = [thisObj componentsSeparatedByString:dataTypeToNamedClassSeparator];
                    
                    // Ensure the namedClass attribute is present.
                    if ([dataTypeToNamedClass count] > 1) {
                        //-------------------------------------------------------
                        // Set the target class to the second component attribute
                        // i.e. @pointer::namedClass
                        //-------------------------------------------------------
                        NSString *thisTargetClassName = dataTypeToNamedClass[1];
                        
                        NSString *thisKeyPathClassName = @"className";
                        NSString *thisKeyPathObjectId = @"objectId";
                        NSString *thisKeyPathType = @"__type";
                        
                        NSDictionary *relationsParams = @{thisKeyPathType : @"Pointer",
                                                     thisKeyPathClassName : thisTargetClassName,
                                                     thisKeyPathObjectId : thisObjectId};
                        
                        [dataDict setValue:relationsParams forKey:thisKey];
                    }
                }
                
            
            } else if ([thisObj isEqualToString:@"@string"]){
                NSURL *toStringObj = [anObject valueForKey:thisKey];

                [dataDict setValue:[toStringObj absoluteString] forKeyPath:thisKey];
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
 * Given a dictionary, it returns a serialized version in string format.
 *--------------------------------------------------------------------------*/
+ (NSString *)serializeRequestParmetersWithDictionary:(NSDictionary *)dict {
    
    NSError *error = nil;
    
    
    //convert object to data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:kNilOptions error:&error];
    
    if (!jsonData) {
        NSLog(@"NSJSONSerialization failed %@", error);
    }
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return json;
    
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


/*---------------------------------------------------------------------------
 * Compares two dates to see if they are within the same week
 *--------------------------------------------------------------------------*/
+ (BOOL) weekIsEqual:(NSDate *)date and:(NSDate *)otherDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned unitFlags = NSYearForWeekOfYearCalendarUnit | NSWeekOfYearCalendarUnit;
    NSDateComponents *dateComponents      = [gregorian components:unitFlags fromDate:date];
    NSDateComponents *otherDateComponents = [gregorian components:unitFlags fromDate:otherDate];
    
    gregorian = nil;
    return [dateComponents weekOfYear] == [otherDateComponents weekOfYear] && [dateComponents yearForWeekOfYear] == [otherDateComponents yearForWeekOfYear];
}


/*---------------------------------------------------------------------------
 * Returns a formatted date string from a NSDate object
 *--------------------------------------------------------------------------*/
+(NSString*)transformDate:(NSDate*)date toDateFormat:(NSString*)dateFormat
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}


/*---------------------------------------------------------------------------
 * Returns a NSDate object from a NSString with a specific format
 *--------------------------------------------------------------------------*/
+ (NSDate *)transformDateString:(NSString *)dateString fromDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}


/*---------------------------------------------------------------------------
 * Returns a NSDate object with start of day components
 *--------------------------------------------------------------------------*/
+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

/*---------------------------------------------------------------------------
 * Returns the number of days between two dates.
 *--------------------------------------------------------------------------*/
+ (NSInteger)numberOfDaysBetweenBaseDate:(NSDate *)baseDate offsetDate:(NSDate *)offsetDate  {
    
    NSDate *dateBeginningOfEventStartDay = [self dateAtBeginningOfDayForDate:offsetDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorianCalendar components:unitFlags
                                                        fromDate:baseDate
                                                          toDate:dateBeginningOfEventStartDay
                                                         options:0];
    gregorianCalendar= nil;
    
    NSInteger daysOffset = [components day];
    
    return daysOffset;
}


+ (NSString*)convertDaysCountToLabelWithBaseDate:(NSDate *)baseDate offsetDate:(NSDate *)offsetDate
{
    NSInteger daysOffset = [CommonUtilities numberOfDaysBetweenBaseDate:baseDate offsetDate:offsetDate];
    
    NSArray *durationPastArray = @[@"Today",
                                   @"days ago",
                                   @"1 week ago",
                                   @"2 weeks ago",
                                   @"3 weeks ago",
                                   @"4 weeks ago",
                                   @"+1 month ago",
                                   @"+2 months ago",
                                   @"+3 months ago",
                                   @"+4 months ago",
                                   @"+5 months ago",
                                   @"> 6 months ago"
                                   ];
    
    NSString *durationLabel;
    
    
    
    switch (daysOffset * -1) {
        case 0:
            durationLabel = durationPastArray[0];
            break;
        case 1 ... 6:
            durationLabel = [NSString stringWithFormat:@"%d %@", daysOffset, durationPastArray[1]];
            break;
        case 7 ... 13:
            durationLabel = durationPastArray[2];
            break;
        case 14 ... 20:
            durationLabel = durationPastArray[3];
            break;
        case 21 ... 27:
            durationLabel = durationPastArray[4];
            break;
        case 28 ... 30:
            durationLabel = durationPastArray[5];
            break;
        case 31 ... 61:
            durationLabel = durationPastArray[6];
            break;
        case 62 ... 92:
            durationLabel = durationPastArray[7];
            break;
        case 93 ... 123:
            durationLabel = durationPastArray[9];
            break;
        case 124 ... 154:
            durationLabel = durationPastArray[10];
            break;
        case 155 ... 10000:
            durationLabel = durationPastArray[11];
            break;
        default:
            break;
    }
    

    return   durationLabel;
    

}

@end
