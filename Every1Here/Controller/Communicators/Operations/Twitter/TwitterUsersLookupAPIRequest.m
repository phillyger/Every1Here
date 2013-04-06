//
//  TwitterUsersLookupRequest.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "TwitterUsersLookupAPIRequest.h"
#import "AFJSONRequestOperation.h"

@implementation TwitterUsersLookupAPIRequest
@synthesize delegate = _delegate;
@synthesize request = _request;
@synthesize action = _action;

#pragma mark - Life Cycle

- (id)initWithDataSourceURLRequest:(NSURLRequest *)dataSourceURLRequest selectorName:(NSString *)aSelectorName
                         delegate:(id<TwitterUsersLookupAPIRequestDelegate>)theDelegate {
    
    if (self = [super init]) {
        self.request = dataSourceURLRequest;
        self.delegate = theDelegate;
        self.action = NSSelectorFromString(aSelectorName);
        self.JSON = nil;
    }
    return self;
}

#pragma mark -
#pragma mark - Fetch Twitter API response for User Lookup Request

// 3: Regularly check for isCancelled, to make sure the operation terminates as soon as possible.
- (void)main {
    
    // 4: Apple recommends using @autoreleasepool block instead of alloc and init NSAutoreleasePool, because blocks are more efficient. You might use NSAuoreleasePool instead and that would be fine.
    @autoreleasepool {
        
        
        
        if (self.isCancelled)
            return;
        
        AFJSONRequestOperation *datasource_twitter_api_operation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:_request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                   //The JSON variable will contain the currently logged users information!
                                                            NSLog(@"Sucess!");
                                                            self.JSON = JSON;
                                                            if ([(NSObject *)self.delegate respondsToSelector:self.action])
                                                                [(NSObject *)self.delegate performSelectorOnMainThread:self.action withObject:self waitUntilDone:NO];
                                                                                                                   
                                                            }
                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error,id JSON) {
                                //Hanlde any request errors
                                                                NSLog(@"Failure!");
                                                        }];
        
        
        [datasource_twitter_api_operation start];
        
        
    }
}

@end
