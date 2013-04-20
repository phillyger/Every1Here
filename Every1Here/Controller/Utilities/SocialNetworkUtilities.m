//
//  SocialNetworkUtilities.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "SocialNetworkUtilities.h"

@implementation SocialNetworkUtilities


+ (NSString*)formatTypeToString:(SocialNetworkType)slType {
    NSString *result = nil;
    
    switch(slType) {
        case NONE:
            result = @"Direct";
            break;
        case Twitter:
            result = @"Twitter";
            break;
        case Meetup:
            result = @"Meetup";
            break;
        case Facebook:
            result = @"Facebook";
            break;
        case LinkedIn:
            result = @"LinkedIn";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected SocialNetworkType."];
    }
    
    return result;
}


/*
 *  Converts an string value into it corresponding SocialNetworkType
 */

+ (SocialNetworkType)formatStringToType:(NSString*)slTypeString {

    if ([slTypeString isEqualToString:@"Meetup"]) {
        return Meetup;
    } else if ([slTypeString isEqualToString:@"Twitter"]){
        return Twitter;
    } else if ([slTypeString isEqualToString:@"Facebook"]){
        return Facebook;
    } else if ([slTypeString isEqualToString:@"LinkedIn"]){
        return LinkedIn;
    }
    return NONE;
    
}

/*
 *  Converts an integer value into it corresponding SocialNetworkType
 */

+ (NSString *)formatIntegerToString:(NSUInteger)slTypeInt {
    NSString *result = nil;
    
    switch(slTypeInt) {
        case 0:
            result = @"Direct";
            break;
        case 1:
            result = @"Meetup";
            break;
        case 2:
            result = @"Twitter";
            break;
        case 3:
            result = @"Facebook";
            break;
        case 4:
            result = @"LinkedIn";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected SocialNetworkType."];
    }
    
    return result;
}

/*
 *  Converts an integer value into it corresponding SocialNetworkType
 */

+ (SocialNetworkType)formatIntegerToType:(NSUInteger)slTypeInt {
    
    
    if ((int)slTypeInt == Meetup) {
        return Meetup;
    } else if ((int)slTypeInt == Twitter){
        return Twitter;
    } else if ((int)slTypeInt == Facebook){
        return Facebook;
    } else if ((int)slTypeInt == LinkedIn){
        return LinkedIn;
    }
    return NONE;
    
}

@end
