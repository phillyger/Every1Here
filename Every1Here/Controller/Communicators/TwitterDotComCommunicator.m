//
//  TwitterDotComCommunicator.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "TwitterDotComCommunicator.h"
#import "SLAPIClient.h"
#import "TwitterFollowersIdsRequest.h"
#import "TwitterUsersLookupAPIRequest.h"
#import "TwitterMembersListsRequest.h"

#define kTwitterBaseURL @"https://api.twitter.com/"
#define kTwitterURLToFetchFollowersIds @"https://api.twitter.com/1.1/followers/ids.json"
#define kTwitterURLToFetchUsersLookup @"https://api.twitter.com/1.1/users/lookup.json"
#define kTwitterURLToFetchMembersLists @"https://api.twitter.com/1.1/lists/members.json"


//#define kDatasourceURLString @"https://api.twitter.com/1.1/users/lookup.json"
#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)


@interface TwitterDotComCommunicator ()

@property (nonatomic, retain) NSOperationQueue  *operationQueue;
@end

@implementation TwitterDotComCommunicator
@synthesize delegate;

- (PendingOperations *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[PendingOperations alloc] init];
    }
    return _pendingOperations;
}



- (void)launchConnectionForRequest: (SLRequest *)request {
    
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [[SLAPIClient sharedClient]
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
        [[SLAPIClient sharedClient]
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [[SLAPIClient sharedClient] accountsWithAccountType:twitterAccountType];

                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 
                 NSURLRequest *preppedRequest = [request preparedURLRequest];
                 [self startOperationsForUserDataFetch:preppedRequest];
//                  [self startOperationsForUserDataFetch:[request preparedURLRequest]];
                 
             }

         }];

    }
}

- (void)fetchContentAtURL:(NSURL *)url
                   parameters:(NSDictionary *)parameters
                 errorHandler:(void (^)(NSError *))errorBlock
               successHandler:(void (^)(NSDictionary *, SocialNetworkType))successBlock {
    fetchingURL = url;
    fetchingURLParameters = parameters;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];
    
//    [fetchingURLParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//           NSLog(@"The object at key %@ is %@",key,obj);
//    }];
    
    SLRequest *request =
    [SLRequest requestForServiceType:SLServiceTypeTwitter
                       requestMethod:SLRequestMethodGET
                                 URL:fetchingURL
                          parameters:fetchingURLParameters];
    
    [self launchConnectionForRequest: request];
    
    
}


- (SLRequest *)buildSLRequest:(NSURL *)url
               parameters:(NSDictionary *)parameters
             errorHandler:(void (^)(NSError *))errorBlock
           successHandler:(void (^)(NSDictionary *))successBlock {
    fetchingURL = url;
    fetchingURLParameters = parameters;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];
    
    //    [fetchingURLParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //           NSLog(@"The object at key %@ is %@",key,obj);
    //    }];
    
    SLRequest *request =
    [SLRequest requestForServiceType:SLServiceTypeTwitter
                       requestMethod:SLRequestMethodGET
                                 URL:fetchingURL
                          parameters:fetchingURLParameters];
    
    return request;
    
}


- (void)downloadGuestsForGroupName:(NSString *)groupUrlName
                      errorHandler:(GuestErrorBlock)errorBlock
                    successHandler:(GuestObjectNotationBlock)successBlock {
    NSURL *url = nil;
    NSDictionary *parameters = nil;
    
    if (nil != groupUrlName) {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"panoramatoast", @"owner_screen_name",
                      @"panoramatoast", @"owner_id",
                      @"FollowerList", @"slug",
                      
                      nil];
    }
    
    
    url = [NSURL URLWithString:kTwitterURLToFetchMembersLists];
    
    [self fetchContentAtURL: url
                     parameters: parameters
                   errorHandler:(GuestErrorBlock)errorBlock
             successHandler:(GuestObjectNotationBlock)successBlock];
    
    
}


- (void)cancelAndDiscardURLConnection {
//    [[[SLAPIClient sharedClient] operationQueue] cancelAllOperations];
    //    [[AFParseDotComAPIClient sharedClient] cancelAllHTTPOperationsWithMethod:fetchingURLMethod path:fetchingURLPath];
}


- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}
         

// 1: To keep it simple, you pass in an instance of PhotoRecord that requires operations, along with its indexPath.
- (void)startOperationsForUserDataFetch:(NSURLRequest *)dataSourceURLRequest {
    
    NSString *absolutePath = [[dataSourceURLRequest URL] absoluteString];
    
    NSLog(@"URL Path : %@", absolutePath);
    
    // Are you calling the Followers/Ids API
    if (contains(absolutePath, kTwitterURLToFetchFollowersIds)) {
        [self startFollowersIdsApiOperationForURLRequest: dataSourceURLRequest];
    }
    
    // Are you calling the Users/Lookup API
    if(contains(absolutePath, kTwitterURLToFetchUsersLookup)) {
        [self startUsersLookupApiOperationForURLRequest:dataSourceURLRequest];
    }
    
    // Are you calling the Users/Lookup API
    if(contains(absolutePath, kTwitterURLToFetchMembersLists)) {
        [self startMembersListsApiOperationForURLRequest:dataSourceURLRequest];
    }
    
    
    
}

- (void)startFollowersIdsApiOperationForURLRequest:(NSURLRequest *)dataSourceURLRequest {
     
     
//     TwitterFollowersIdsRequest *op_followersIds = [[TwitterFollowersIdsRequest alloc] init];
//     TwitterUsersLookupAPIRequest *op_userLookups = [[TwitterUsersLookupAPIRequest alloc] init];
//     [op_userLookups addDependency: op_followersIds];
     
     // 1: First, check for the particular api request to see if there is already an operation in twitterApiOpsInProgress for it. If so, ignore it.
    NSLog(@"URL Path : %@", [[dataSourceURLRequest URL] absoluteString]);
    if (![self.pendingOperations.twitterApiOpsInProgress.allKeys containsObject:[[dataSourceURLRequest URL] absoluteString]]) {
         
         // 2: If not, create an instance of TwitterFollowersIdsRequest by using the designated initializer, and set TwitterDotComCommunicator as the delegate. Pass in the appropriate dataSourceURLString and a action selector string (for delegate), and then add it to the twitterApiOpsQueue. You also add it to twitterApiOpsInProgress to help keep track of things.
         // Start fetching
         TwitterFollowersIdsRequest *twitterFollersIdsReq = [[TwitterFollowersIdsRequest alloc] initWithDataSourceURLRequest:dataSourceURLRequest selectorName:@"twitterFollowersIdsRequestDidFinish:" delegate:self];
         [self.pendingOperations.twitterApiOpsInProgress setObject:twitterFollersIdsReq forKey:[[dataSourceURLRequest URL] absoluteString]];
         [self.pendingOperations.twitterApiOpsQueue addOperation: twitterFollersIdsReq];
     }
 }




- (void)startUsersLookupApiOperationForURLRequest:(NSURLRequest *)dataSourceURLRequest {
    

    
    // 1: First, check for the particular api request to see if there is already an operation in twitterApiOpsInProgress for it. If so, ignore it.
    NSLog(@"URL Path : %@", [[dataSourceURLRequest URL] absoluteString]);
    if (![self.pendingOperations.twitterApiOpsInProgress.allKeys containsObject:[[dataSourceURLRequest URL] absoluteString]]) {
        
        // 2: If not, create an instance of TwitterFollowersIdsRequest by using the designated initializer, and set TwitterDotComCommunicator as the delegate. Pass in the appropriate dataSourceURLString and a action selector string (for delegate), and then add it to the twitterApiOpsQueue. You also add it to twitterApiOpsInProgress to help keep track of things.
        // Start fetching
        TwitterUsersLookupAPIRequest *twitterUsersLookupReq = [[TwitterUsersLookupAPIRequest alloc] initWithDataSourceURLRequest:dataSourceURLRequest selectorName:@"twitterUsersLookupRequestDidFinish:" delegate:self];
        
        // 5: This one is a little tricky. You first must check to see if this followers/ids api request call is pending; if so, you make this users/lookup operation dependent on that. Otherwise, you donít need dependency.
        TwitterFollowersIdsRequest *dependency = [self.pendingOperations.twitterApiOpsInProgress objectForKey:kTwitterURLToFetchFollowersIds];
        if (dependency)
            [twitterUsersLookupReq addDependency:dependency];
        

        [self.pendingOperations.twitterApiOpsInProgress setObject:twitterUsersLookupReq forKey:[[dataSourceURLRequest URL] absoluteString]];
        [self.pendingOperations.twitterApiOpsQueue addOperation: twitterUsersLookupReq];
    }
}


- (void)startMembersListsApiOperationForURLRequest:(NSURLRequest *)dataSourceURLRequest {
    
    
    
    // 1: First, check for the particular api request to see if there is already an operation in twitterApiOpsInProgress for it. If so, ignore it.
    NSLog(@"URL Path : %@", [[dataSourceURLRequest URL] absoluteString]);
    if (![self.pendingOperations.twitterApiOpsInProgress.allKeys containsObject:[[dataSourceURLRequest URL] absoluteString]]) {
        
        // 2: If not, create an instance of TwitterFollowersIdsRequest by using the designated initializer, and set TwitterDotComCommunicator as the delegate. Pass in the appropriate dataSourceURLString and a action selector string (for delegate), and then add it to the twitterApiOpsQueue. You also add it to twitterApiOpsInProgress to help keep track of things.
        // Start fetching
        TwitterMembersListsRequest *twitterMembersListsReq = [[TwitterMembersListsRequest alloc] initWithDataSourceURLRequest:dataSourceURLRequest selectorName:@"twitterMembersListsRequestDidFinish:" delegate:self];
        
        
        [self.pendingOperations.twitterApiOpsInProgress setObject:twitterMembersListsReq forKey:[[dataSourceURLRequest URL] absoluteString]];
        [self.pendingOperations.twitterApiOpsQueue addOperation: twitterMembersListsReq];
    }
}



- (void)twitterFollowersIdsRequestDidFinish:(TwitterFollowersIdsRequest *)responseData {
    

    
    NSURL *url = nil;
    NSDictionary *parameters = nil;
    
    if (responseData.JSON) {
        NSLog(@"Response: %@\n", responseData.JSON);
        NSArray *ids = (NSArray *)[(NSDictionary *)responseData.JSON valueForKey:@"ids"];
//        [ids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSLog(@"The object at index %d is %@",idx,obj);
//        }];

        NSString *user_id_param = [ids componentsJoinedByString:@","];
            
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                      user_id_param, @"user_id",
                      nil];
        
        // 5: Remove the operation from twitterApiOpsInProgress.
         NSLog(@"URL Path : %@", [[responseData.request URL] absoluteString]);
        [self.pendingOperations.twitterApiOpsInProgress removeObjectForKey:[[responseData.request URL] absoluteString]];
        
        url = [NSURL URLWithString:kTwitterURLToFetchUsersLookup];
        
        [self fetchContentAtURL: url
                     parameters: parameters
                   errorHandler:nil
                 successHandler:nil];
        
        
    }
    else {
        // The server did not respond successfully... were we rate-limited?
//        NSLog(@"The response status code is %d", urlResponse.statusCode);
    }

        
}

- (void)twitterUsersLookupRequestDidFinish:(TwitterUsersLookupAPIRequest *)responseData {
    NSLog(@" twitterUsersLookupRequestDidFinish: %@\n", responseData.JSON);
}

- (void)twitterMembersListsRequestDidFinish:(TwitterMembersListsRequest *)responseData {
    //NSLog(@" twitterMembersListsRequestDidFinish: %@\n", responseData.JSON);

    
    if (responseData.JSON) {
        NSLog(@"twitterMembersListsRequestDidFinish Response: %@\n", responseData.JSON);
//        NSDictionary *users =[(NSDictionary *)responseData.JSON valueForKey:@"users"];

//        successHandler(users, Twitter);
        [delegate receivedGuestsJSON:responseData.JSON socialNetworkType:Twitter];
        
    }
    else {
        // The server did not respond successfully... were we rate-limited?
        //        NSLog(@"The response status code is %d", urlResponse.statusCode);
    }
    
}


@end

NSString *TwitterDotComCommunicatorErrorDomain = @"TwitterDotComCommunicatorErrorDomain";

