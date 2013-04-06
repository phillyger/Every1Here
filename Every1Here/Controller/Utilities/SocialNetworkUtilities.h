//
//  SocialNetworkUtilities.h
//  Anseo
//
//  Created by Ger O'Sullivan on 3/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SocialNetworkType) {
    NONE=0,
    Meetup,
    Twitter,
    LinkedIn,
    Facebook
    
};

@interface SocialNetworkUtilities : NSObject

+ (NSString*)formatTypeToString:(SocialNetworkType)slType;
+ (SocialNetworkType)formatStringToType:(NSString*)slTypeString;
+ (NSString *)formatIntegerToString:(NSUInteger)slTypeInt;
+ (SocialNetworkType)formatIntegerToType:(NSUInteger *)slTypeInt;

@end
