//
//  AFParseDotComAPIClient.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/2/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AFParseDotComAPIClient.h"


static NSString * const kAFParseDotComAPIBaseURLString = @"https://api.parse.com/";
static NSString * const kAFParseDotComAPICharset = @"utf-8";
static NSString * const kAFParseDotComJSONMimeType = @"application/json";
/**
 *   Every1Here - PROD keys
 *
 **/

static NSString * const kAFParseDotComAppIDKey = @"CzxhhRu2NJF9o1IM85xkRedx2ySoaA6G4rv4jRkc";
static NSString * const kAFParseDotComRESTApiKey = @"SyGe3rNcjaXOK8KAtNiXhKGwmPzpUfKo4El96P7d";



/**
*   Every1Here - DEV keys
*
**/
//static NSString * const kAFParseDotComAppIDKey = @"DUW4o1VHHIattNSNAeHmKCzNVWT09qB05SJV2Jzt";
//static NSString * const kAFParseDotComRESTApiKey = @"B1Z7TEH1XAQ1C4AnqxC5SZL42TdIxzOQhlkIl8Gt";



@implementation AFParseDotComAPIClient




+ (instancetype)sharedClient {
    static AFParseDotComAPIClient *_sharedClient = nil;
     static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFParseDotComAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFParseDotComAPIBaseURLString]];
//        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
//    [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self setRequestSerializer:[AFJSONRequestSerializer serializer]];

    
    [self.requestSerializer setValue:kAFParseDotComAppIDKey forHTTPHeaderField:@"X-Parse-Application-Id"];
    [self.requestSerializer setValue:kAFParseDotComRESTApiKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
//    [self startReachabilityMonitoring];

    return self;
}

- (void)startReachabilityMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager managerForDomain:kAFParseDotComAPIBaseURLString];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [manager startMonitoring];
}

- (NSString *)fetchFullEndPointUri:(NSString*)relativeEndPointUri
{
    NSString *clientBaseUrl = [[self baseURL] absoluteString];
    return [clientBaseUrl stringByAppendingString:relativeEndPointUri];
}


@end
