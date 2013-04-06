//
//  TwitterDotComCommunicator.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuestCommunicatorDelegate.h"
#import "TwitterFollowersIdsRequest.h"
#import "TwitterUsersLookupAPIRequest.h"
#import "TwitterMembersListsRequest.h"
#import "PendingOperations.h"


typedef void (^GuestObjectNotationBlock)(NSDictionary *, SocialNetworkType);
typedef void (^GuestErrorBlock)(NSError *);

@interface TwitterDotComCommunicator: NSObject <NSURLConnectionDataDelegate, TwitterUsersLookupAPIRequestDelegate, TwitterFollowersIdsRequestDelegate, TwitterMembersListsRequestDelegate> {
@protected
    NSString *fetchingURLPath;
    NSURL *fetchingURL;
    NSDictionary *fetchingURLParameters;
@private
    id <GuestCommunicatorDelegate> __weak delegate;
    void (^errorHandler)(NSError *);
    void (^successHandler)(NSDictionary *, SocialNetworkType);
}

@property (weak) id <GuestCommunicatorDelegate> delegate;
//This property is used to track pending operations.
@property (nonatomic, strong) PendingOperations *pendingOperations;


- (void)downloadGuestsForGroupName:(NSString *)groupUrlName
                      errorHandler:(GuestErrorBlock)errorBlock
                    successHandler:(GuestObjectNotationBlock)successBlock;
@end


extern NSString *TwitterDotComCommunicatorErrorDomain;