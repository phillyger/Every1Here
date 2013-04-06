//
//  TwitterMembersListsRequest.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/26/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwitterMembersListsRequestDelegate;

@interface TwitterMembersListsRequest : NSOperation

@property (nonatomic, assign) id <TwitterMembersListsRequestDelegate> delegate;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) id JSON;
@property (nonatomic) SEL action;

// Declare a designated initializer.
- (id)initWithDataSourceURLRequest:(NSURLRequest *)dataSourceURLRequest
                      selectorName:(NSString *)aSelectorName
                          delegate:(id<TwitterMembersListsRequestDelegate>)theDelegate;

@end

@protocol TwitterMembersListsRequestDelegate <NSObject>

- (void)twitterMembersListsRequestDidFinish:(TwitterMembersListsRequest *)responseData;

@end

