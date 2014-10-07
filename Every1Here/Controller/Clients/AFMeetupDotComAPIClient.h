//
//  AFMeetupDotComAPIClient.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/2/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFMeetupDotComAPIClient : AFHTTPSessionManager

+ (AFMeetupDotComAPIClient *)sharedClient;

@end
