//
//  TwitterUsersLookupRequest.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//


@protocol TwitterUsersLookupAPIRequestDelegate;

@interface TwitterUsersLookupAPIRequest : NSOperation

@property (nonatomic, assign) id <TwitterUsersLookupAPIRequestDelegate> delegate;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic) SEL action;
@property (nonatomic, strong) id JSON;


// Declare a designated initializer.
- (id)initWithDataSourceURLRequest:(NSURLRequest *)dataSourceURLRequest
                      selectorName:(NSString *)aSelectorName
                          delegate:(id<TwitterUsersLookupAPIRequestDelegate>)theDelegate;
@end


@protocol TwitterUsersLookupAPIRequestDelegate <NSObject>

- (void)twitterUsersLookupRequestDidFinish:(TwitterUsersLookupAPIRequest *)responseData;

@end
