//
//  AFTwitterDotComAPIClient.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/22/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AFHTTPClient.h"

#define AccountTwitterAccountAccessGranted @"TwitterAccountAccessGranted"


@interface SLAPIClient : ACAccountStore

+ (SLAPIClient *)sharedClient;

@end
