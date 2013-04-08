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

@class User;
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


- (void)downloadPastEventsForGroupName:(NSString *)groupName
                          errorHandler:(ParseDotComErrorBlock)errorBlock
                        successHandler:(ParseDotComObjectNotationBlock)successBlock;

- (void)downloadEventsForGroupName:(NSString *)groupName
                            status:(NSString *)status
                          errorHandler:(ParseDotComErrorBlock)errorBlock
                        successHandler:(ParseDotComObjectNotationBlock)successBlock;

- (void)downloadMembersForGroupName:(NSString *)groupName
                        withEventId:(NSString *)eventId
                        errorHandler:(ParseDotComErrorBlock)errorBlock
                      successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)downloadGuestsForGroupName:(NSString *)groupName
                        withEventId:(NSString *)eventId
                       errorHandler:(ParseDotComErrorBlock)errorBlock
                successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;

- (void)insertNewUser:(User *)selectedUser
         errorHandler:(ParseDotComErrorBlock)errorBlock
       successHandler:(ParseDotComObjectNotationBlock)successBlock;

- (void)insertNewMember:(User *)selectedUser
         errorHandler:(ParseDotComErrorBlock)errorBlock
       successHandler:(ParseDotComObjectNotationBlock)successBlock;

- (void)insertNewGuest:(User *)selectedUser
           errorHandler:(ParseDotComErrorBlock)errorBlock
         successHandler:(ParseDotComObjectNotationBlock)successBlock;

- (void)insertNewAttendanceWithUser:(User *)selectedUser
                      withEvent:(Event *)event
                   errorHandler:(ParseDotComErrorBlock)errorBlock
                 successHandler:(ParseDotComObjectNotationBlock)successBlock;

- (void)updateAttendanceWithUser:(User *)selectedUser
                          withEvent:(Event *)selectedEvent
                       errorHandler:(ParseDotComErrorBlock)errorBlock
                     successHandler:(ParseDotComObjectNotationBlock)successBlock;

- (void)insertNewEvent:(Event *)selectedEvent
          errorHandler:(ParseDotComErrorBlock)errorBlock
        successHandler:(ParseDotComObjectNotationBlock)successBlock;


- (void)updateExistingUser:(User *)selectedUser
             withClassType:(NSString *)classType
           errorHandler:(ParseDotComErrorBlock)errorBlock
         successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;


- (void)deleteAttendanceForUser:(User *)selectedUser
                            errorHandler:(ParseDotComErrorBlock)errorBlock
                          successHandler:(ParseDotComObjectNotationBlock)successBlock;

- (void)insertNewRow:(id)obj forClass:(NSString *)className withParameters:(NSDictionary *)fieldDict;

@end


extern NSString *ParseDotComCommunicatorErrorDomain;