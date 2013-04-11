//
//  Every1HereCommunicator.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/29/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//




#import "ParseDotComCommunicator.h"
#import "AFParseDotComAPIClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLConnectionOperation.h"
#import "User.h"
#import "Event.h"
#import "EventRole.h"
#import "E1HOperationFactory.h"
#import "E1HRESTApiOperationFactory.h"
#import "RESTApiOperation.h"
#import "CommonUtilities.h"




@interface ParseDotComCommunicator ()

- (NSString *)serializeRequestParmetersWithDictionary:(NSDictionary *)dict;

@end

@implementation ParseDotComCommunicator

@synthesize delegate;




- (void)launchBatchConnectionForRequests {
    
    [self cancelAndDiscardURLConnection];
    
    [[AFParseDotComAPIClient sharedClient] enqueueBatchOfHTTPRequestOperationsWithRequests:fetchingURLRequestList progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"%lu of %lu Completed", (unsigned long)numberOfCompletedOperations, (unsigned long)totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        NSLog(@"Completion: %@", operations);
       [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           AFHTTPRequestOperation *ro = obj;
            NSLog(@"Operation: %@", [ro responseString]);
       }];
        successBatchHandler((NSArray *)operations);
    }];
    
    
}


- (void)batchContentForRequests:(NSArray *)requestList
                 errorHandler:(void (^)(NSError *))errorBlock
               successBatchHandler:(void (^)(NSArray *))successBlock {
    fetchingURLRequestList = requestList;
    errorHandler = [errorBlock copy];
    successBatchHandler = [successBlock copy];
    
    
    [self launchBatchConnectionForRequests];
    
    
}


- (void)downloadEventsForGroupName:(NSString *)groupName
                        withStatus:(NSString *)status
                    forActionType:(ActionTypes)actionType
                    forClassName: (NSString*)className
                      errorHandler:(ParseDotComErrorBlock)errorBlock
               successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {

    
    
    NSMutableDictionary *queryParameters = [[NSMutableDictionary alloc] init];
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    // Fetch operation to return list of Events

    queryParameters = [@{@"status":status,
                       @"groupId":
                       @{@"$inQuery":
                       @{@"where":
                       @{@"name":groupName},
                       @"className":@"Group"}}} mutableCopy];
    NSLog(@"%@", queryParameters);
    
    id fetchMemberOp= [E1HOperationFactory create:actionType];
    RESTApiOperation *op1 = [fetchMemberOp createOperationWithObj:nil forClassName:className withQuery:queryParameters];
    [operations addObject:op1];
    
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
}

- (void)downloadUsersForEvent:(Event *)event
                forActionType:(ActionTypes)actionType
                 forClassName:(NSString *)className
                 errorHandler:(ParseDotComErrorBlock)errorBlock
          successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    
    NSMutableDictionary *queryParameters = [[NSMutableDictionary alloc] init];
    NSMutableArray *operations = [[NSMutableArray alloc] init];
   
    // Fetch operation to return list of Members or Guests
    queryParameters = [@{@"isActive" : [NSNumber numberWithBool:TRUE]} mutableCopy];
    
    id fetchUserOp= [E1HOperationFactory create:actionType];
    RESTApiOperation *usersOp = [fetchUserOp createOperationWithObj:event forClassName:className withQuery:queryParameters];
    [operations addObject:usersOp];
    
    // Fetch operation to return list of Attendance
    NSString *attendanceClassName = [@"Attendance" mutableCopy];
    queryParameters = [@{@"eventId" : [event valueForKey:@"objectId"]} mutableCopy];
    
    id fetchAttendanceOp= [E1HOperationFactory create:actionType];
    RESTApiOperation *attendanceOp = [fetchAttendanceOp createOperationWithObj:event forClassName:attendanceClassName withQuery:queryParameters];
    [operations addObject:attendanceOp];
    
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
    
    
}
#pragma mark Attendance 

- (void)insertAttendance:(User *)user forClassName:(NSString *)className errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    NSDictionary *parameters = [CommonUtilities generateValueDictWithObject:user forClassName:className];
    
    id insertOp= [E1HOperationFactory create:Insert];
    RESTApiOperation *op = [insertOp createOperationWithDict:parameters forClassName:className];
    [operations addObject:op];
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];

}


- (void)updateAttendance:(User *)user
            forClassName:(NSString *)className
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    id updateOp= [E1HOperationFactory create:Update];
    RESTApiOperation *op = [updateOp createOperationWithObj:user forClassName:className withKey:@"attendanceId"];
    [operations addObject:op];
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
    
}

- (void)deleteAttendance:(User *)user
            forClassName:(NSString *)className
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    id deleteOp= [E1HOperationFactory create:Delete];
    RESTApiOperation *op = [deleteOp createOperationWithId:[user valueForKeyPath:@"attendanceId"] forClassName:className];
    [operations addObject:op];
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
}


#pragma mark User Ops

- (void)updateUser:(User *)user forClassName:(NSString *)className errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock{
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    id updateOp= [E1HOperationFactory create:Update];
    RESTApiOperation *op = [updateOp createOperationWithObj:user forClassName:className withKey:@"objectId"];
    [operations addObject:op];
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
}

- (void)execute:(NSArray *)operations
   errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *mutableRequests = [NSMutableArray array];

    [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RESTApiOperation *op = (RESTApiOperation *)obj;
        [mutableRequests addObject:[[AFParseDotComAPIClient sharedClient] requestWithMethod:[op uriMethod] path:[op uriPath] parameters:[op data]]];
    }];

    
    [self batchContentForRequests:mutableRequests
                     errorHandler:(ParseDotComErrorBlock)errorBlock
              successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock];
}



- (void)dealloc {
     [[[AFParseDotComAPIClient sharedClient] operationQueue] cancelAllOperations];
}

- (void)cancelAndDiscardURLConnection {
    [[[AFParseDotComAPIClient sharedClient] operationQueue] cancelAllOperations];
}

#pragma mark NSURLConnection Delegate


@end

NSString *ParseDotComCommunicatorErrorDomain = @"ParseDotComCommunicatorErrorDomain";

