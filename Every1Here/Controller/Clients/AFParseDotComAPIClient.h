//
//  AFParseDotComAPIClient.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/2/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AFParseDotComAPIClient : AFHTTPClient

+ (AFParseDotComAPIClient *)sharedClient;

@end
