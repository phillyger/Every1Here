//
//  AFFBDotComClient.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/22/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

//#define kAFMeetupDotComAPIBaseURLString @"https://api.meetup.com/"
static NSString * const kAFFBDotComAPIBaseURLString = @"https://api.meetup.com/";
static NSString * const kAFFBDotComGroupIdKey = @"3169852";

@interface AFFBDotComClient : AFHTTPClient

@end
