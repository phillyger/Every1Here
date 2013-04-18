//
//  AFParseDotComAPIClient.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/2/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AFParseDotComAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kAFParseDotComAPIBaseURLString = @"https://api.parse.com/";

/**
 *   Every1Here - PROD keys
 *
 **/

//static NSString * const kAFParseDotComAppIDKey = @"CzxhhRu2NJF9o1IM85xkRedx2ySoaA6G4rv4jRkc";
//static NSString * const kAFParseDotComRESTApiKey = @"SyGe3rNcjaXOK8KAtNiXhKGwmPzpUfKo4El96P7d";
//


/**
*   Every1Here - DEV keys
*
**/
static NSString * const kAFParseDotComAppIDKey = @"DUW4o1VHHIattNSNAeHmKCzNVWT09qB05SJV2Jzt";
static NSString * const kAFParseDotComRESTApiKey = @"B1Z7TEH1XAQ1C4AnqxC5SZL42TdIxzOQhlkIl8Gt";



@implementation AFParseDotComAPIClient




+ (AFParseDotComAPIClient *)sharedClient {
    static AFParseDotComAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFParseDotComAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFParseDotComAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [self setDefaultHeader:@"X-Parse-Application-Id" value:kAFParseDotComAppIDKey];
    [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kAFParseDotComRESTApiKey];
    
    return self;
}


@end
