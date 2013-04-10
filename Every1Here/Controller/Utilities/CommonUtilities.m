//
//  CommonUtilities.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/9/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "CommonUtilities.h"

@implementation CommonUtilities

+ (NSDictionary *)generateValueDictWithObject:(id)anObject forClassName:(NSString *)className {
    
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:className ofType:@"plist"];
    NSDictionary *pListInfoDict = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    
    //    Class objClass =  NSClassFromString(className);
    
    
    //    [pListInfoDict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
    ////        NSDictionary *item = obj;
    //        [dataDict setObject:[anObject objectForKey:key] forKey:key];
    //    }];
    
    [pListInfoDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //        [dataDict setObject:[anObject objectForKey:key] forKey:key];
        NSString *thisKey = key;
        NSString *thisObj = obj;
        
        if ([thisObj hasPrefix:@"@"]) {
            if ([thisObj isEqualToString:@"@password"]) {
                [dataDict setValue:@"WatermARK" forKeyPath:thisKey];

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
//                [[dataDict objectForKey:@"memberSince"] setObject:formattedDate forKey:thisKeyPathIso];
//                [[dataDict objectForKey:@"memberSince"] setObject:@"Date" forKey:thisKeyPathType];
//                [dataDict setValue:nil forKeyPath:@"memberSince"];
//                [dataDict setValue:formattedDate forKeyPath:thisKeyPathIso];
//                [dataDict setValue:@"Date" forKeyPath:thisKeyPathType];
            }
        } else {
            [dataDict setValue:[anObject valueForKeyPath:thisObj] forKeyPath:thisKey];
        }
        
     
    }];
    
    
    return [dataDict copy];

}


+ (NSString *)fetchUriEndPointFromPListForClassName:(NSString *)className {
    
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:@"Classes" ofType:@"plist"];
    NSDictionary *classPathInfoDict = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    
    NSString *uriEndPointForClassName = [NSString stringWithFormat:@"%@", [classPathInfoDict objectForKey:className]];
    
    return uriEndPointForClassName;
}
@end
