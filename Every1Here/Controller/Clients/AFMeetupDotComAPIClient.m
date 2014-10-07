//
//  AFMeetupDotComAPIClient.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/2/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AFMeetupDotComAPIClient.h"


//#define kAFMeetupDotComAPIBaseURLString @"https://api.meetup.com/"
static NSString * const kAFMeetupDotComAPIBaseURLString = @"https://api.meetup.com/";
static NSString * const kAFMeetupDotComGroupIdKey = @"3169852";
static NSString * const kAFMeetupDotComAPICharset = @"utf-8";


@implementation AFMeetupDotComAPIClient


+ (AFMeetupDotComAPIClient *)sharedClient {
    static AFMeetupDotComAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFMeetupDotComAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFMeetupDotComAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
//    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    [self setParameterEncoding:AFJSONParameterEncoding];
    
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
//	[self setDefaultHeader:@"Accept" value:@"application/json"];
//    [self setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    
    [self.requestSerializer setValue:kAFMeetupDotComAPICharset forHTTPHeaderField:@"Accept-Charset"];
    

    
    return self;
}

@end





