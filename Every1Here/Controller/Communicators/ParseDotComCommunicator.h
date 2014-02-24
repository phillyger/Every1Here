//
//  ParseDotComCommunicator.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/29/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ParseDotComCommunicatorDelegate.h"
#import "EventCommunicatorDelegate.h"
#import "MemberCommunicatorDelegate.h"
#import "E1HOperationFactory.h"
#import "User.h"

@class Event;
@class AFHTTPRequestOperation;

typedef void (^ParseDotComObjectNotationBlock)(NSDictionary *);
typedef void (^ParseDotComBatchOperationsBlock)(NSArray *);
typedef void (^ParseDotComSingleOperationsBlock)(AFHTTPRequestOperation *);
typedef void (^ParseDotComErrorBlock)(NSError *);

@interface ParseDotComCommunicator : NSObject {
@protected
    NSString *fetchingURLPath;
    NSString *postingURLPath;
    NSString *updatingURLPath;
    NSString *deletingURLPath;
    

    NSDictionary *fetchingURLParameters;
    NSDictionary *postingURLParameters;
    NSDictionary *updatingURLParameters;
    NSArray *fetchingURLRequestList;

@private
    void (^errorHandler)(NSError *);
    void (^successHandler)(NSDictionary *);
    void (^successBatchHandler)(NSArray *);
    void (^successSingleHandler)(NSArray *);
}


@property (weak) id <EventCommunicatorDelegate, MemberCommunicatorDelegate> delegate;


/*
 *  Event Operations
 */

- (void)downloadEventsForOrgId:(NSNumber *)orgId
                        withStatus:(NSString *)status
                     forActionType:(ActionTypes)actionType
                      forNamedClass: (NSString*)namedClass
                      errorHandler:(ParseDotComErrorBlock)errorBlock
               successSingleHandler:(ParseDotComSingleOperationsBlock)successBlock;




/*
 *  User(Type) Operations (i.e. Members and Guests)
 */

- (void)downloadUserInfoForActionType:(ActionTypes)actionType
                     forNamedClass:(NSString *)namedClass
                        withTMCCId:(NSString *)tmCCId
                      errorHandler:(ParseDotComErrorBlock)errorBlock
               successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)downloadUserInfoForActionType:(ActionTypes)actionType
                        forNamedClass:(NSString *)namedClass
                         errorHandler:(ParseDotComErrorBlock)errorBlock
                  successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)downloadUsersForEvent:(Event *)event
                forActionType:(ActionTypes)actionType
                forNamedClass:(NSString *)namedClass
                 errorHandler:(ParseDotComErrorBlock)errorBlock
          successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)insertUser:(User*)user
            forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)insertUserList:(NSArray*)userList
     forNamedClass:(NSString *)namedClass
forSocialNetworkKey:(SocialNetworkType)slType
      errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)updateUser:(User*)user
      forNamedClass:(NSString *)namedClass
      errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)deleteUser:(User*)user
     forNamedClass:(NSString *)namedClass
      errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)deleteUserList:(NSArray*)userList
     forNamedClass:(NSString *)namedClass
forSocialNetworkKey:(SocialNetworkType)slType
      errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;



/*
 *  Attendance Operations
 */

- (void)insertAttendance:(User*)user
            forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successSingleHandler:(ParseDotComSingleOperationsBlock)successBlock;

- (void)updateAttendance:(User*)user
            forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)deleteAttendance:(User*)user
            forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;


/*
 *  Speech Operations
 */

- (void)insertSpeech:(User*)user
           forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successSingleHandler:(ParseDotComSingleOperationsBlock)successBlock;

- (void)updateSpeech:(User*)user
           forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successSingleHandler:(ParseDotComSingleOperationsBlock)successBlock;

- (void)deleteSpeech:(User*)user
           forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

@end


extern NSString *ParseDotComCommunicatorErrorDomain;