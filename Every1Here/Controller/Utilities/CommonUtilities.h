//
//  CommonUtilities.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/9/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtilities : NSObject

+ (NSDictionary *)generateValueDictWithObject:(id)anObject forClassName:(NSString *)className;
+ (NSString *)fetchUriEndPointFromPListForClassName:(NSString *)className;
+ (NSString *)serializeRequestParmetersWithDictionary:(NSDictionary *)dict;
@end
