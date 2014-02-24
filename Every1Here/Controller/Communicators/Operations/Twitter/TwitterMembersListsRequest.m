//
//  TwitterMembersListsRequest.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/26/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "TwitterMembersListsRequest.h"
#import "AFHTTPRequestOperation.h"

@implementation TwitterMembersListsRequest
@synthesize delegate = _delegate;
@synthesize request = _request;
@synthesize action = _action;
@synthesize JSON=_JSON;

#pragma mark - Life Cycle

- (id)initWithDataSourceURLRequest:(NSURLRequest *)dataSourceURLRequest selectorName:(NSString *)aSelectorName
                          delegate:(id<TwitterMembersListsRequestDelegate>)theDelegate {
    
    if (self = [super init]) {
        self.request = dataSourceURLRequest;
        self.delegate = theDelegate;
        self.action = NSSelectorFromString(aSelectorName);
        self.JSON = nil;
    }
    return self;
}

#pragma mark -
#pragma mark - Fetch Twitter API response for Members Lists Request

// 3: Regularly check for isCancelled, to make sure the operation terminates as soon as possible.
- (void)main {
    
    // 4: Apple recommends using @autoreleasepool block instead of alloc and init NSAutoreleasePool, because blocks are more efficient. You might use NSAuoreleasePool instead and that would be fine.
    @autoreleasepool {
        
        
        
        if (self.isCancelled)
            return;

        NSURLRequest *request = self.request;
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            //The JSON variable will contain the currently logged users information!
            NSLog(@"Sucess!");
            self.JSON = responseObject;
            
            if ([(NSObject *)self.delegate respondsToSelector:self.action])
                [(NSObject *)self.delegate performSelectorOnMainThread:self.action withObject:self waitUntilDone:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [[NSOperationQueue mainQueue] addOperation:op];
        
        
//        AFJSONRequestOperation *datasource_twitter_api_operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:_request
//                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
//                     //The JSON variable will contain the currently logged users information!
//                                        NSLog(@"Sucess!");
//                                       self.JSON = JSON;
//                                                                                                                       
//                                      if ([(NSObject *)self.delegate respondsToSelector:self.action])
//                                     [(NSObject *)self.delegate performSelectorOnMainThread:self.action withObject:self waitUntilDone:NO];
//                                                                                                                       
//                                    }
//                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error,id JSON) {
//                                        //Hanlde any request errors
//                                          NSLog(@"Failure!");
//                                   }];
//        
//        
//        [datasource_twitter_api_operation start];
        
    }
}


@end
