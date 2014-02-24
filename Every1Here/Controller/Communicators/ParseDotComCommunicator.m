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
#import "EventRoleDefault.h"
#import "E1HOperationFactory.h"
#import "E1HRESTApiOperationFactory.h"
#import "RESTApiOperation.h"
#import "CommonUtilities.h"
#import "AFHTTPRequestOperationManager.h"

@interface ParseDotComCommunicator ()


- (void)execute:(NSArray *)operations
   errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock;


@end

@implementation ParseDotComCommunicator


- (void)launchBatchConnectionForRequests {
    
    //[self cancelAndDiscardURLConnection];

    [self checkReachability];
    
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:fetchingURLRequestList
                                         progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                             NSLog(@"%lu of %lu Completed", (unsigned long)numberOfFinishedOperations, (unsigned long)totalNumberOfOperations);
                                         } completionBlock:^(NSArray *operations) {
//                                             NSLog(@"Completion: %@", operations);
//                                             [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                                                 AFHTTPRequestOperation *ro = obj;
//                                                 NSLog(@"Operation: %@", [ro responseString]);
//                                             }];
                                             successBatchHandler((NSArray *)operations);
                                         }];

    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}


- (void)launchSingleRequestConnection:(RESTApiOperation *)op
                         errorHandler:(void (^)(NSError *))errorBlock
                  successSingleHandler:(void (^)(AFHTTPRequestOperation *))successBlock {
    
    //[self cancelAndDiscardURLConnection];
    
    [self checkReachability];
    
    NSError *error=nil;


    NSMutableURLRequest *request;
    
    /** Fix a AFNetworking issue where a partial URI is not appended to baseUrl of shared client **/
    NSString *fullEndPointUri = [[AFParseDotComAPIClient sharedClient] fetchFullEndPointUri:[op uriPath]];
    
    request = [[[AFParseDotComAPIClient sharedClient] requestSerializer] requestWithMethod:[op uriMethod] URLString:fullEndPointUri parameters:[op data] error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];

    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
    
    
}

- (void)batchContentForRequests:(NSArray *)requestList
                 errorHandler:(void (^)(NSError *))errorBlock
               successBatchHandler:(void (^)(NSArray *))successBlock {
    fetchingURLRequestList = requestList;
    errorHandler = [errorBlock copy];
    successBatchHandler = [successBlock copy];
    
    
    [self launchBatchConnectionForRequests];
    
    
}

#pragma mark - Network Reachability
- (void)checkReachability
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
}

#pragma mark Event Operations
- (void)downloadEventsForOrgId:(NSNumber *)orgId
                        withStatus:(NSString *)status
                    forActionType:(ActionTypes)actionType
                    forNamedClass: (NSString*)namedClass
                      errorHandler:(ParseDotComErrorBlock)errorBlock
               successSingleHandler:(ParseDotComSingleOperationsBlock)successBlock {

    
    
    NSMutableDictionary *queryParameters = [[NSMutableDictionary alloc] init];
//    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    // Fetch operation to return list of Events
    // 'className' is a Parse defined key used in querying class content. Hence E1H variable is namedClass to avoid confusion
    queryParameters = [@{@"status":status,
                       @"groupId":
                       @{@"$inQuery":
                       @{@"where":
                       @{@"orgId":orgId},
                       @"className":@"Group"}}} mutableCopy];
    
    NSArray *includes = @[@"groupId", @"venueId", @"type"];
    
    NSLog(@"%@", queryParameters);
    
    id fetchMemberOp= [E1HOperationFactory create:actionType];
    RESTApiOperation *op = [fetchMemberOp createOperationWithObj:nil forNamedClass:namedClass withQuery:queryParameters withIncludes:includes];
    
    [self launchSingleRequestConnection:op errorHandler:errorBlock successSingleHandler:successBlock];
    

}



#pragma mark Attendance Operations

- (void)insertAttendance:(User *)user forNamedClass:(NSString *)namedClass errorHandler:(ParseDotComErrorBlock)errorBlock successSingleHandler:(ParseDotComSingleOperationsBlock)successBlock {
    
//    NSMutableArray *operations = [[NSMutableArray alloc] init];
    NSDictionary *parameters = [CommonUtilities generateValueDictWithObject:user forNamedClass:namedClass];
    
    id insertOp= [E1HOperationFactory create:Insert];
    RESTApiOperation *op = [insertOp createOperationWithDict:parameters forNamedClass:namedClass];

    
    [self launchSingleRequestConnection:op errorHandler:errorBlock successSingleHandler:successBlock];
    

}


- (void)updateAttendance:(User *)user
            forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    id updateOp= [E1HOperationFactory create:Update];
    RESTApiOperation *op = [updateOp createOperationWithObj:user forNamedClass:namedClass withKey:@"attendanceId"];
    [operations addObject:op];
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
    
}

- (void)deleteAttendance:(User *)user
            forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    id deleteOp= [E1HOperationFactory create:Delete];
    RESTApiOperation *op = [deleteOp createOperationWithId:[user valueForKeyPath:@"attendanceId"] forNamedClass:namedClass];
    [operations addObject:op];
    
    deleteOp=nil;
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
}


#pragma mark Speech Operations

- (void)insertSpeech:(User *)user forNamedClass:(NSString *)namedClass errorHandler:(ParseDotComErrorBlock)errorBlock successSingleHandler:(ParseDotComSingleOperationsBlock)successBlock {
    
    NSDictionary *parameters = [CommonUtilities generateValueCustomDictWithObject:user forNamedClass:namedClass];
    
    id insertOp= [E1HOperationFactory create:Insert];
    RESTApiOperation *op = [insertOp createOperationWithDict:parameters forNamedClass:namedClass];

    [self launchSingleRequestConnection:op errorHandler:errorBlock successSingleHandler:successBlock];
    
}


- (void)updateSpeech:(User *)user
           forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successSingleHandler:(ParseDotComSingleOperationsBlock)successBlock {
    
//    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
     NSDictionary *aQuery = [CommonUtilities generateValueCustomDictWithObject:user forNamedClass:namedClass];
    
    
    id updateOp= [E1HOperationFactory create:Update];
    RESTApiOperation *op = [updateOp createOperationWithObj:user forNamedClass:namedClass withQuery:aQuery withKey:@"speechId"];
//    [operations addObject:op];
//    
//    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
//     ];
    
    [self launchSingleRequestConnection:op errorHandler:errorBlock successSingleHandler:successBlock];
    
    
}

- (void)deleteSpeech:(User *)user
           forNamedClass:(NSString *)namedClass
            errorHandler:(ParseDotComErrorBlock)errorBlock
     successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    
    
    id deleteOp= [E1HOperationFactory create:Delete];
    RESTApiOperation *op = [deleteOp createOperationWithId:[user valueForKeyPath:@"speechId"] forNamedClass:namedClass];
    [operations addObject:op];
    
    deleteOp=nil;
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
}



#pragma mark User(Type) Operations

- (void)downloadUserInfoForActionType:(ActionTypes)actionType
                forNamedClass:(NSString *)namedClass
                   withTMCCId:(NSString *)tmCCId
                 errorHandler:(ParseDotComErrorBlock)errorBlock
          successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    /*
     *  Operation to return the list of users
     */
    RESTApiOperation *usersOp = [self getUserListOperationWithNamedClass:namedClass withActionType:actionType];
    [operations addObject:usersOp];
    
    if (tmCCId!=nil) {
        RESTApiOperation *tmCCOp = [self getTMCCOperationWithId:tmCCId withActionType:actionType];
        [operations addObject:tmCCOp];
    }

    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
    
}

- (void)downloadUserInfoForActionType:(ActionTypes)actionType
                        forNamedClass:(NSString *)namedClass
                         errorHandler:(ParseDotComErrorBlock)errorBlock
                  successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    /*
     *  Operation to return the list of users
     */
    RESTApiOperation *usersOp = [self getUserListOperationWithNamedClass:namedClass withActionType:actionType];
    [operations addObject:usersOp];
    
    RESTApiOperation *tmCCOp = [self getTMCCOperationWithActionType:actionType];
    [operations addObject:tmCCOp];
    
    
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
    
}


- (RESTApiOperation *)getTMCCOperationWithActionType:(ActionTypes)actionType
{

    
    // The TM Competent Communicator class
    NSString *namedClass = @"TM_CC";
    
    id fetchTMCCOp= [E1HOperationFactory create:actionType];
    RESTApiOperation *speechOp = [fetchTMCCOp createOperationWithObj:nil forNamedClass:namedClass withQuery:nil withOrder:@"projectNum"];
    
    
    fetchTMCCOp = nil;
    
    return speechOp;
}

- (RESTApiOperation *)getTMCCOperationWithId:tmCCId withActionType:(ActionTypes)actionType
{
    /*
     *  Operation to return the TM CC info based up id value
     */
    NSMutableDictionary *queryParameters = [[NSMutableDictionary alloc] init];
    
    queryParameters = [@{@"objectId": tmCCId}
                       mutableCopy];
    
    // If this is Guest member, return nil.
    NSString *namedClass = @"TM_CC";
    
    id fetchTMCCOp= [E1HOperationFactory create:actionType];
    RESTApiOperation *speechOp = [fetchTMCCOp createOperationWithObj:nil forNamedClass:namedClass withQuery:queryParameters];
    
    
    fetchTMCCOp = nil;
    
    return speechOp;
}


- (void)downloadUsersForEvent:(Event *)event
                forActionType:(ActionTypes)actionType
                forNamedClass:(NSString *)namedClass
                 errorHandler:(ParseDotComErrorBlock)errorBlock
          successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    

    /*
     *  Operation to return the list of users
     */
    RESTApiOperation *usersOp = [self getUserListOperationWithNamedClass:namedClass withActionType:actionType];
    [operations addObject:usersOp];
    
    RESTApiOperation *attendanceOp = [self getAttendanceListByEventOperationWithEvent:event withNamedClass:namedClass withActionType:actionType];
    [operations addObject:attendanceOp];
    
    if ([namedClass isEqualToString:@"Member"]) {
        RESTApiOperation *speechOp = [self getSpeechListByEventOperationWithEvent:event withNamedClass:namedClass withActionType:actionType];
        [operations addObject:speechOp];
    }

    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
    
    
}


- (RESTApiOperation *)getSpeechListByEventOperationWithEvent:(Event*)event withNamedClass:(NSString *)namedClass withActionType:(ActionTypes)actionType
{
    /*
     *  Operation to return list of Attendanees by Event Id
     */
    NSMutableDictionary *queryParameters = [[NSMutableDictionary alloc] init];
    
    queryParameters = [@{@"eventId":
                             @{@"__type": @"Pointer",
                               @"className": @"Event",
                               @"objectId": [event valueForKey:@"objectId"]}}
                       mutableCopy];
    
    // If this is Guest member, return nil.
    NSString *speechNamedClass = [namedClass isEqualToString:@"Guest"] ? nil : @"Speech";
    
    if (speechNamedClass == nil) {
        return nil;
    }
    
    id fetchSpeechOp= [E1HOperationFactory create:actionType];
    RESTApiOperation *speechOp = [fetchSpeechOp createOperationWithObj:nil forNamedClass:speechNamedClass withQuery:queryParameters];
    
    
    fetchSpeechOp=nil;
    
    return speechOp;
    
}


- (RESTApiOperation *)getAttendanceListByEventOperationWithEvent:(Event*)event withNamedClass:(NSString *)namedClass withActionType:(ActionTypes)actionType
{
    /*
     *  Operation to return list of Attendanees by Event Id
     */
    NSMutableDictionary *queryParameters = [[NSMutableDictionary alloc] init];
    
    NSString *attendanceNamedClass = [namedClass isEqualToString:@"Guest"] ? @"GuestAttendance" : @"Attendance";
    
    queryParameters = [@{@"eventId":
                             @{@"__type": @"Pointer",
                               @"className": @"Event",
                               @"objectId": [event valueForKey:@"objectId"]}}
                       mutableCopy];
    
    id fetchAttendanceOp= [E1HOperationFactory create:actionType];
    RESTApiOperation *attendanceOp = [fetchAttendanceOp createOperationWithObj:nil forNamedClass:attendanceNamedClass withQuery:queryParameters];
    
    
    fetchAttendanceOp=nil;
    
    return attendanceOp;

}

- (RESTApiOperation *)getUserListOperationWithNamedClass:(NSString *)namedClass withActionType:(ActionTypes)actionType
{
    NSMutableDictionary *queryParameters = [[NSMutableDictionary alloc] init];
    
    /*
     *  First Operation
     */
    
    //    NSString *unescaped = @"include=latestSpeech";
    //    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
    //                                                                                                    NULL,
    //                                                                                                    (__bridge CFStringRef) unescaped,
    //                                                                                                    NULL,
    //                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
    //                                                                                                    kCFStringEncodingUTF8));
    //
    //    NSLog(@"escapedString: %@",escapedString);
    
    // Fetch operation to return list of Members or Guests
    queryParameters = [@{@"isActive" : [NSNumber numberWithBool:TRUE]} mutableCopy];
    
    id fetchUserOp= [E1HOperationFactory create:actionType];
    RESTApiOperation *usersOp = [fetchUserOp createOperationWithObj:nil forNamedClass:namedClass withQuery:queryParameters withOrder:@"lastName"];
    
    fetchUserOp = nil;
    
    return usersOp;
}


- (void)insertUser:(User *)user forNamedClass:(NSString *)namedClass errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    

    NSDictionary *parameters = [CommonUtilities generateValueDictWithObject:user forNamedClass:namedClass];
    NSLog(@"%@", parameters);
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    id insertOp1= [E1HOperationFactory create:Insert];
    RESTApiOperation *insertToNamedTableOp = [insertOp1 createOperationWithDict:parameters forNamedClass:namedClass];
    [operations addObject:insertToNamedTableOp];
    
    if ([namedClass isEqualToString:@"Member"]) {
        NSString *usernamedClass = [@"User" mutableCopy];
        parameters = [CommonUtilities generateValueDictWithObject:user forNamedClass:usernamedClass];
        NSLog(@"%@", parameters);
        id insertOp2= [E1HOperationFactory create:Insert];
        RESTApiOperation *insertToUserTableOp = [insertOp2 createOperationWithDict:parameters forNamedClass:usernamedClass];
        [operations addObject:insertToUserTableOp];
        insertOp2= nil;
    }
    
    insertOp1= nil;
    
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
    
}


- (void)insertUserList:(NSArray *)userList forNamedClass:(NSString *)namedClass forSocialNetworkKey:(SocialNetworkType)slType errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {

    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSMutableDictionary *parameters = [[CommonUtilities generateValueDictWithObject:(User*)obj forNamedClass:namedClass] mutableCopy];
        if ([namedClass isEqualToString:@"Guest"]) {
            [parameters setObject:[NSNumber numberWithInt:slType] forKey:@"socialNetwork"];
            [parameters setObject:[obj valueForKeyPath:@"slUserId"] forKey:@"socialNetworkUserId"];
        }
        
        NSLog(@"%@", parameters);
        id insertOp1= [E1HOperationFactory create:Insert];
        RESTApiOperation *insertToNamedTableOp = [insertOp1 createOperationWithDict:parameters forNamedClass:namedClass];
        [operations addObject:insertToNamedTableOp];
        

        
        if ([namedClass isEqualToString:@"Member"]) {
            NSString *userNamedClass = [@"User" mutableCopy];
            parameters = [[CommonUtilities generateValueDictWithObject:(User*)obj forNamedClass:userNamedClass] mutableCopy];
            NSLog(@"%@", parameters);
            id insertOp2= [E1HOperationFactory create:Insert];
            RESTApiOperation *insertToUserTableOp = [insertOp2 createOperationWithDict:parameters forNamedClass:userNamedClass];
            [operations addObject:insertToUserTableOp];
            insertOp2= nil;
        }
        
        insertOp1= nil;
        
    }];
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
    
}



- (void)updateUser:(User *)user forNamedClass:(NSString *)namedClass errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock{
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    id updateOp= [E1HOperationFactory create:Update];
    RESTApiOperation *updateToNamedTableOp = [updateOp createOperationWithObj:user forNamedClass:namedClass withKey:@"objectId"];
    [operations addObject:updateToNamedTableOp];
    
    updateOp=nil;
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
}

- (void)deleteUser:(User *)user forNamedClass:(NSString *)namedClass errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock{
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    id deleteOp= [E1HOperationFactory create:Delete];
    RESTApiOperation *deleteToNamedTableOp = [deleteOp createOperationWithObj:user forNamedClass:namedClass withKey:@"objectId"];
    [operations addObject:deleteToNamedTableOp];
    
    deleteOp= nil;
    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
}

- (void)deleteUserList:(NSArray *)userList forNamedClass:(NSString *)namedClass forSocialNetworkKey:(SocialNetworkType)slType errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock{
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id deleteOp= [E1HOperationFactory create:Delete];
        RESTApiOperation *deleteToNamedTableOp = [deleteOp createOperationWithObj:obj forNamedClass:namedClass withKey:@"objectId"];
        [operations addObject:deleteToNamedTableOp];
        
       deleteOp= nil;
    }];

    
    [self execute:operations errorHandler:(ParseDotComErrorBlock)errorBlock successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
     ];
}


- (void)execute:(NSArray *)operations
   errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
//    NSMutableArray *mutableRequests = [NSMutableArray array];
    NSMutableArray *mutableOperations = [NSMutableArray array];
    
    
    
    [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RESTApiOperation *op = (RESTApiOperation *)obj;
        NSError *error = nil;
        
        /** Fix a AFNetworking issue where a partial URI is not appended to baseUrl of shared client **/
        NSString *fullEndPointUri = [[AFParseDotComAPIClient sharedClient] fetchFullEndPointUri:[op uriPath]];
        
        NSMutableURLRequest *request= [[[AFParseDotComAPIClient sharedClient] requestSerializer] requestWithMethod:[op uriMethod] URLString:fullEndPointUri parameters:[op data] error:&error];
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

        [mutableOperations addObject:operation];

    }];

    
    [self batchContentForRequests:mutableOperations
                     errorHandler:(ParseDotComErrorBlock)errorBlock
              successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock];
}




- (void)cancelAndDiscardURLConnection {
    [[[AFParseDotComAPIClient sharedClient] operationQueue] cancelAllOperations];
}



@end

NSString *ParseDotComCommunicatorErrorDomain = @"ParseDotComCommunicatorErrorDomain";

