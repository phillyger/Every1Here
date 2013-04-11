//
//  Every1HereCommunicator.h
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


typedef void (^ParseDotComObjectNotationBlock)(NSDictionary *);
typedef void (^ParseDotComBatchOperationsBlock)(NSArray *);
typedef void (^ParseDotComErrorBlock)(NSError *);

@interface ParseDotComCommunicator : NSObject <NSURLConnectionDataDelegate> {
@protected
    NSString *fetchingURLPath;
    NSString *postingURLPath;
    NSString *updatingURLPath;
    NSString *deletingURLPath;
    
//    NSString *fetchingURLMethod;
    NSDictionary *fetchingURLParameters;
    NSDictionary *postingURLParameters;
    NSDictionary *updatingURLParameters;
    NSArray *fetchingURLRequestList;
//    NSMutableData *receivedData;
@private
    id <EventCommunicatorDelegate, MemberCommunicatorDelegate> __weak delegate;
    void (^errorHandler)(NSError *);
    void (^successHandler)(NSDictionary *);
    void (^successBatchHandler)(NSArray *);
}


@property (weak) id <EventCommunicatorDelegate, MemberCommunicatorDelegate> delegate;



- (void)downloadEventsForGroupName:(NSString *)groupName
                        withStatus:(NSString *)status
                     forActionType:(ActionTypes)actionType
                      forClassName: (NSString*)className
                      errorHandler:(ParseDotComErrorBlock)errorBlock
               successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)downloadUsersForEvent:(Event *)event
                forActionType:(ActionTypes)actionType
                 forClassName:(NSString *)className
                 errorHandler:(ParseDotComErrorBlock)errorBlock
          successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)execute:(NSArray *)operations
                forActionType:(ActionTypes)actionType
                 forClassName:(NSString *)className
                 errorHandler:(ParseDotComErrorBlock)errorBlock
          successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;


- (void)insertUser:(User*)user
            forClassName:(NSString *)className
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)updateUser:(User*)user
      forClassName:(NSString *)className
      errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)deleteUser:(User*)user
      forClassName:(NSString *)className
      errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;




- (void)insertAttendance:(User*)user
            forClassName:(NSString *)className
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)updateAttendance:(User*)user
            forClassName:(NSString *)className
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)deleteAttendance:(User*)user
            forClassName:(NSString *)className
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

@end


extern NSString *ParseDotComCommunicatorErrorDomain;