//
//  TwitterFollowersIdsRequest.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TwitterFollowersIdsRequestDelegate;

@interface TwitterFollowersIdsRequest : NSOperation

@property (nonatomic, assign) id <TwitterFollowersIdsRequestDelegate> delegate;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) id JSON;
@property (nonatomic) SEL action;

// Declare a designated initializer.
- (id)initWithDataSourceURLRequest:(NSURLRequest *)dataSourceURLRequest
                      selectorName:(NSString *)aSelectorName
                          delegate:(id<TwitterFollowersIdsRequestDelegate>)theDelegate;

@end

@protocol TwitterFollowersIdsRequestDelegate <NSObject>

- (void)twitterFollowersIdsRequestDidFinish:(TwitterFollowersIdsRequest *)responseData;

@end
