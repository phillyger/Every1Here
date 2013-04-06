//
//  MeetupDotComCommunicator.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/31/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MeetupDotComCommunicator.h"
#import "AFMeetupDotComAPIClient.h"
#import "AFJSONRequestOperation.h"

#define kAFMeetupDotComGroupAPIKey @"c45e311a1b4f526d623c5b2f732e3"
#define kURLToFetchEvents @"2/events?"      
#define kURLToFetchMembers @"2/members?"    

@interface MeetupDotComCommunicator ()


@end

@implementation MeetupDotComCommunicator

@synthesize delegate;

- (void)launchConnectionForRequest {
    /*** Clean up and cancel any existing items in the queue first **/
    [self cancelAndDiscardURLConnection];
    
    
    [[AFMeetupDotComAPIClient sharedClient] getPath:fetchingURLPath
                                        parameters:fetchingURLParameters
                                           success:^(AFHTTPRequestOperation *operation, id objectNotation) {
                                               if ([objectNotation isKindOfClass:[NSDictionary class]]) {
                                                   [objectNotation enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                                       NSLog(@"The object at key %@ is %@",key,obj);
                                                   }];
                                               successHandler((NSDictionary *)objectNotation, (SocialNetworkType) Meetup);
                                               }
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               
                                               errorHandler(error);
                                           }];
    
    
}

- (void)fetchContentAtURLPath:(NSString *)urlPath
                   parameters:(NSDictionary *)parameters
                 errorHandler:(void (^)(NSError *))errorBlock
               successHandler:(void (^)(NSDictionary *, SocialNetworkType))successBlock {
    fetchingURLPath = urlPath;
    fetchingURLParameters = parameters;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];
    
//    [fetchingURLParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"The object at key %@ is %@",key,obj);
//    }];
    
    [self launchConnectionForRequest];
    
    
}


- (void)downloadUpcomingEventsForGroupName:(NSString *)groupUrlName
                              errorHandler:(MeetupDotComErrorBlock)errorBlock
                            successHandler:(MeetupDotComObjectNotationBlock)successBlock{
    NSString *urlPath = nil;
    
    NSDictionary *parameters = nil;
    
    
    if (nil != groupUrlName) {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
            kAFMeetupDotComGroupAPIKey, @"key",
            @"true", @"sign",
            @"upcoming", @"status",
            groupUrlName, @"group_urlname",
            @"2", @"page",
            nil];
    }
    

    urlPath = [kURLToFetchEvents lowercaseString];  // api appears to be case-sensitive on requests.
    
    [self fetchContentAtURLPath: urlPath
                     parameters: parameters
                   errorHandler:(MeetupDotComErrorBlock)errorBlock
                 successHandler:(MeetupDotComObjectNotationBlock)successBlock];
}

- (void)downloadGuestsForGroupName:(NSString *)groupUrlName
                      errorHandler:(MeetupDotComErrorBlock)errorBlock
                    successHandler:(MeetupDotComObjectNotationBlock)successBlock {
    NSString *urlPath = nil;
    NSDictionary *parameters = nil;
    
    if (nil != groupUrlName) {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                      kAFMeetupDotComGroupAPIKey, @"key",
                      @"true", @"sign",
                      groupUrlName, @"group_urlname",
                      @"id,name,photo.thumb_link", @"only",
                      nil];
    }
    
    urlPath = [kURLToFetchMembers lowercaseString];

    [self fetchContentAtURLPath: urlPath
                     parameters: parameters
                   errorHandler:(MeetupDotComErrorBlock)errorBlock
                 successHandler:(MeetupDotComObjectNotationBlock)successBlock];
}


- (void)dealloc {
    [[[AFMeetupDotComAPIClient sharedClient] operationQueue] cancelAllOperations];
}

- (void)cancelAndDiscardURLConnection {
    [[[AFMeetupDotComAPIClient sharedClient] operationQueue] cancelAllOperations];
    //    [[AFParseDotComAPIClient sharedClient] cancelAllHTTPOperationsWithMethod:fetchingURLMethod path:fetchingURLPath];
}

#pragma mark NSURLConnection Delegate


@end

NSString *MeetupDotComCommunicatorErrorDomain = @"MeetupDotComCommunicatorErrorDomain";


