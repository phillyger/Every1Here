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

#define kURLToClasses @"1/classes"
#define kURLToBatchProcess @"1/batch"
#define kURLToUsersClass @"1/users"
#define kURLToMembersClass @"1/classes/Member"
#define kURLToGuestsClass @"1/classes/Guest"
#define kURLToEventsClass @"1/classes/Event"
#define kURLToAttendanceClass @"1/classes/Attendance"





@interface ParseDotComCommunicator ()

- (NSString *)serializeRequestParmetersWithDictionary:(NSDictionary *)dict;

@end

@implementation ParseDotComCommunicator

@synthesize delegate;


- (NSString *)serializeRequestParmetersWithDictionary:(NSDictionary *)dict {
    
    NSError *error = nil;
    
    
    //convert object to data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:kNilOptions error:&error];
    
    if (!jsonData) {
        NSLog(@"NSJSONSerialization failed %@", error);
    }
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return json;
    
}


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


- (void)launchConnectionForRequest {
    /*** Clean up and cancel any existing items in the queue first **/
    [self cancelAndDiscardURLConnection];
    
    
    
    [[AFParseDotComAPIClient sharedClient] getPath:fetchingURLPath
                                        parameters:fetchingURLParameters
                                           success:^(AFHTTPRequestOperation *operation, id objectNotation) {
                                               if ([objectNotation isKindOfClass:[NSDictionary class]]) {
//                                                   [objectNotation enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//                                                       NSLog(@"The object at key %@ is %@",key,obj);
//                                                   }];

                                                   successHandler((NSDictionary *)objectNotation);
                                               }
                                               
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               
                                              [NSError errorWithDomain: ParseDotComCommunicatorErrorDomain
                                                                                   code: operation.response.statusCode
                                                                               userInfo: nil];
                                               
                                               errorHandler(error);
                                               [self cancelAndDiscardURLConnection];
                                           }];

    
}
                                         
                                         
- (void)launchConnectionForInsert {
     /*** Clean up and cancel any existing items in the queue first **/
     [self cancelAndDiscardURLConnection];
     
     [[AFParseDotComAPIClient sharedClient] setParameterEncoding:AFJSONParameterEncoding];
                                          
      [[AFParseDotComAPIClient sharedClient] postPath:postingURLPath
                                          parameters:postingURLParameters
                                             success:^(AFHTTPRequestOperation *operation, id objectNotation) {
                                                 if ([objectNotation isKindOfClass:[NSDictionary class]]) {
                                                         [objectNotation enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                                               NSLog(@"The object at key %@ is %@",key,obj);
                                                         }];
                                                     
                                                     successHandler((NSDictionary *)objectNotation);
                                                 }
                                                 
                                             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 
                                                 [NSError errorWithDomain: ParseDotComCommunicatorErrorDomain
                                                                     code: operation.response.statusCode
                                                                 userInfo: nil];
                                                 
                                                 errorHandler(error);
                                                 [self cancelAndDiscardURLConnection];
                                             }];
    
                                          
}



- (void)launchConnectionForUpdate {
    /*** Clean up and cancel any existing items in the queue first **/
    [self cancelAndDiscardURLConnection];
    
    [[AFParseDotComAPIClient sharedClient] setParameterEncoding:AFJSONParameterEncoding];
    
    [[AFParseDotComAPIClient sharedClient] putPath:updatingURLPath
                                         parameters:updatingURLParameters
                                            success:^(AFHTTPRequestOperation *operation, id objectNotation) {
                                                if ([objectNotation isKindOfClass:[NSDictionary class]]) {
                                                    [objectNotation enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                                        NSLog(@"The object at key %@ is %@",key,obj);
                                                    }];
                                                    
                                                    successHandler((NSDictionary *)objectNotation);
                                                }
                                                
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                [NSError errorWithDomain: ParseDotComCommunicatorErrorDomain
                                                                    code: operation.response.statusCode
                                                                userInfo: nil];
                                                
                                                errorHandler(error);
                                                [self cancelAndDiscardURLConnection];
                                            }];
    
    
}

- (void)launchConnectionForDelete {
    /*** Clean up and cancel any existing items in the queue first **/
    [self cancelAndDiscardURLConnection];
    
//    [[AFParseDotComAPIClient sharedClient] setParameterEncoding:AFJSONParameterEncoding];
    
    [[AFParseDotComAPIClient sharedClient] deletePath:deletingURLPath
                                        parameters:nil
                                           success:^(AFHTTPRequestOperation *operation, id objectNotation) {
                                               if ([objectNotation isKindOfClass:[NSDictionary class]]) {
                                                   [objectNotation enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                                                       NSLog(@"The object at key %@ is %@",key,obj);
                                                   }];
                                                   
                                                   successHandler((NSDictionary *)objectNotation);
                                               }
                                               
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               
                                               [NSError errorWithDomain: ParseDotComCommunicatorErrorDomain
                                                                   code: operation.response.statusCode
                                                               userInfo: nil];
                                               
                                               errorHandler(error);
                                               [self cancelAndDiscardURLConnection];
                                           }];
    
    
}


- (void)fetchContentAtURLPath:(NSString *)urlPath
                   parameters:(NSDictionary *)parameters
                 errorHandler:(void (^)(NSError *))errorBlock
               successHandler:(void (^)(NSDictionary *))successBlock {
    fetchingURLPath = urlPath;
    fetchingURLParameters = parameters;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];

    
    [self launchConnectionForRequest];
    
    
}


- (void)postContentToURLPath:(NSString *)urlPath
                    parameters:(NSDictionary *)parameters
                    errorHandler:(void (^)(NSError *))errorBlock
                    successHandler:(void (^)(NSDictionary *))successBlock {
     postingURLPath = urlPath;
     postingURLParameters = parameters;
     errorHandler = [errorBlock copy];
     successHandler = [successBlock copy];
    
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"The object at key %@ is %@",key,obj);
    }];
    
     
     [self launchConnectionForInsert];
 
 
}
                                         


- (void)updateContentToURLPath:(NSString *)urlPath
                  parameters:(NSDictionary *)parameters
                errorHandler:(void (^)(NSError *))errorBlock
              successHandler:(void (^)(NSDictionary *))successBlock {
    updatingURLPath = urlPath;
    updatingURLParameters = parameters;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];
    
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"The object at key %@ is %@",key,obj);
    }];
    
    
    [self launchConnectionForUpdate];
    
    
}


- (void)deleteContentAtURLPath:(NSString *)urlPath
                errorHandler:(void (^)(NSError *))errorBlock
                successHandler:(void (^)(NSDictionary *))successBlock {
    deletingURLPath = urlPath;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];

    
    [self launchConnectionForDelete];
    
    
}

- (void)downloadEventsForGroupName:(NSString *)groupName
                            status:(NSString *)status
                              errorHandler:(ParseDotComErrorBlock)errorBlock
                            successHandler:(ParseDotComObjectNotationBlock)successBlock
{
    NSString *urlPath = nil;
    NSDictionary *parameters = nil;

    if (nil != groupName) {
        
        NSError *error = nil;
        parameters = @{@"status":status,
                       @"groupId":
                           @{@"$inQuery":
                                 @{@"where":
                                       @{@"name":groupName},
                                   @"className":@"Group"}}};

         //convert object to data
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                            options:kNilOptions error:&error];
        
        if (!jsonData) {
            NSLog(@"NSJSONSerialization failed %@", error);
        }
        
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", json);
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                      json, @"where", nil];

        
        NSLog(@"%@", parameters);
    }
    
    
    urlPath = kURLToEventsClass;  // api appears to be case-sensitive on requests.
    
    [self fetchContentAtURLPath: urlPath
                     parameters: parameters
                   errorHandler:(ParseDotComErrorBlock)errorBlock
                 successHandler:(ParseDotComObjectNotationBlock)successBlock];
}


- (void)downloadMembersForGroupName:(NSString *)groupName
                        withEventId:(NSString *)eventId
                        errorHandler:(ParseDotComErrorBlock)errorBlock
                      successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
 {
    
     NSMutableString *json;
     NSDictionary *attendanceParameters = nil;
     NSDictionary *membersParameters = nil;
     NSMutableArray *mutableRequests = [NSMutableArray array];
     
     if (nil != groupName) {
         json = [[self serializeRequestParmetersWithDictionary:@{@"eventId":eventId}] copy];      // fetch attendance by event Id
         attendanceParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                 json, @"where", nil];
         
         json = [[self serializeRequestParmetersWithDictionary:@{@"isActive":[NSNumber numberWithBool:YES]}] copy];  // fetch only active members
         membersParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 json, @"where", nil];
     }
     
     NSDictionary *operationsDict = @{kURLToMembersClass: membersParameters,
                                             kURLToAttendanceClass : attendanceParameters};

     [operationsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
         [mutableRequests addObject:[[AFParseDotComAPIClient sharedClient] requestWithMethod:@"GET" path:key parameters:obj]];
     }];
     
     
     
//     for (NSString *URLString in @[kURLToFetchMembers, kURLToUpdateExistingAttendance]) {
//         [mutableRequests addObject:[[AFParseDotComAPIClient sharedClient] requestWithMethod:@"GET" path:URLString parameters:nil]];
//     }
    
    //urlPath = kURLToFetchMembers;

    [self batchContentForRequests:mutableRequests
                errorHandler:(ParseDotComErrorBlock)errorBlock
              successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock];

}


- (void)downloadGuestsForGroupName:(NSString *)groupName
                        withEventId:(NSString *)eventId
                       errorHandler:(ParseDotComErrorBlock)errorBlock
                successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock
{
    
    NSMutableString *json;
    NSDictionary *attendanceParameters = nil;
    NSDictionary *guestsParameters = nil;
    NSMutableArray *mutableRequests = [NSMutableArray array];
    
    if (nil != groupName) {
        json = [[self serializeRequestParmetersWithDictionary:@{@"eventId":eventId}] copy];      // fetch attendance by event Id
        attendanceParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                json, @"where", nil];
        
        json = [[self serializeRequestParmetersWithDictionary:@{@"isActive":[NSNumber numberWithBool:YES]}] copy];  // fetch only active members
        guestsParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                             json, @"where", nil];
    }
    
    NSDictionary *operationsDict = @{kURLToMembersClass: guestsParameters,
                                     kURLToAttendanceClass : attendanceParameters};
    
    [operationsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [mutableRequests addObject:[[AFParseDotComAPIClient sharedClient] requestWithMethod:@"GET" path:key parameters:obj]];
    }];
    
    
    
    //     for (NSString *URLString in @[kURLToFetchMembers, kURLToUpdateExistingAttendance]) {
    //         [mutableRequests addObject:[[AFParseDotComAPIClient sharedClient] requestWithMethod:@"GET" path:URLString parameters:nil]];
    //     }
    
    //urlPath = kURLToFetchMembers;
    
    [self batchContentForRequests:mutableRequests
                     errorHandler:(ParseDotComErrorBlock)errorBlock
              successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock];
    
}





- (void)insertNewUser:(User *)selectedUser
         errorHandler:(ParseDotComErrorBlock)errorBlock
       successHandler:(ParseDotComObjectNotationBlock)successBlock {
    
    NSDictionary *parameters = nil;
    NSString *urlPath = nil;

    
    if (nil != selectedUser) {
        
        parameters = @{@"username": [selectedUser displayName],
                      @"password":@"WatermARK",
                       @"email": [selectedUser primaryEmailAddr]};
        
        NSLog(@"%@", parameters);
        
    }
    
    
    
    urlPath = kURLToUsersClass;  // api appears to be case-sensitive on requests.

    NSLog(@"urlPath: %@", urlPath );
    
    [self postContentToURLPath: urlPath
                     parameters: parameters
                   errorHandler:(ParseDotComErrorBlock)errorBlock
                 successHandler:(ParseDotComObjectNotationBlock)successBlock];
    
}

- (void)insertNewRow:(id)obj forClass:(NSString *)className withParameters:(NSDictionary *)fieldDict
        errorHandler:(ParseDotComErrorBlock)errorBlock
      successHandler:(ParseDotComObjectNotationBlock)successBlock {
    
    NSString *urlPath;
    
//    
//    if ([className isEqualToString:@"User"]) {
//        urlPath = kURLToUsersClass;
//    } else if ([className isEqualToString:@"Batch"]){
//        urlPath = kURLToBatchProcess;
//    } else {
//        urlPath = [kURLToClasses stringByAppendingString:className];
//    }
    
//    fieldDict = nil;
    
    
    id insertOp= [E1HOperationFactory create:Insert];
    [insertOp createOperationWithObj:obj forClassName:className withKey:nil];

    
    [self postContentToURLPath: urlPath
                    parameters: fieldDict
                  errorHandler:(ParseDotComErrorBlock)errorBlock
                successHandler:(ParseDotComObjectNotationBlock)successBlock];
    
}

- (void)insertNewMember:(User *)selectedUser
           errorHandler:(ParseDotComErrorBlock)errorBlock
         successHandler:(ParseDotComObjectNotationBlock)successBlock {
    
    
    NSDictionary *parameters = nil;
    //     NSString *jsonString = nil;
    NSString *urlPath = nil;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
    
    parameters = @{@"firstName": [selectedUser firstName],
                   @"lastName": [selectedUser lastName],
                   @"userId": @"bKacaqBBmH",
                   @"isActive": [NSNumber numberWithBool:YES],
                   @"memberSince": @{@"__type": @"Date",
                                     @"iso": formattedDate},
                   @"primaryEmail": [selectedUser primaryEmailAddr]
                   };
    
    
    dateFormatter = nil;
    urlPath = kURLToMembersClass;        //Parse class object are case-sensitive.  **Must MATCH with MBaaS**
    
    
    [self postContentToURLPath: urlPath
                    parameters: parameters
                  errorHandler:(ParseDotComErrorBlock)errorBlock
                successHandler:(ParseDotComObjectNotationBlock)successBlock];
    
}


- (void)insertNewGuest:(User *)selectedUser
           errorHandler:(ParseDotComErrorBlock)errorBlock
         successHandler:(ParseDotComObjectNotationBlock)successBlock {
    
    
    NSDictionary *parameters = nil;
    //     NSString *jsonString = nil;
    NSString *urlPath = nil;
    
    
    
    parameters = @{@"firstName": [selectedUser firstName],
                   @"lastName": [selectedUser lastName],
                   @"userId": [selectedUser userId],
                   @"primaryEmail": [selectedUser primaryEmailAddr],
                   @"isActive": [NSNumber numberWithBool:YES],
                   @"socialNetworkConnection": [SocialNetworkUtilities formatTypeToString:[selectedUser slType]]
                   };

    urlPath = kURLToGuestsClass;        //Parse class object are case-sensitive.  **Must MATCH with MBaaS**
    
    
    [self postContentToURLPath: urlPath
                    parameters: parameters
                  errorHandler:(ParseDotComErrorBlock)errorBlock
                successHandler:(ParseDotComObjectNotationBlock)successBlock];
    
}


- (void)updateExistingUser:(User *)selectedUser
             withClassType:(NSString *)classType
                errorHandler:(ParseDotComErrorBlock)errorBlock
              successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *mutableRequests = [NSMutableArray array];
    NSDictionary *memberParameters = nil;
    NSDictionary *userParameters = nil;
    NSMutableString *memberUrlPath;
    NSMutableString *s1, *s2;

    

    memberParameters = @{@"firstName": [selectedUser firstName],
                   @"lastName": [selectedUser lastName],
                   @"userId": [selectedUser userId],
                   };

    userParameters = @{@"username": [selectedUser displayName]};
    
    NSString *baseUrlPath = [classType isEqualToString:@"Guest"] ? kURLToGuestsClass : kURLToMembersClass;
    s1 = [baseUrlPath copy];
    s2 = [[@"/" stringByAppendingString:[selectedUser objectId]] copy];    // ensure we add the end slash
    memberUrlPath = [[s1 stringByAppendingString:s2] copy];
    NSLog(@"memberUrlPath : %@", memberUrlPath);

    /**
     *  Cannoit update the Parse defined User table without session information.
     * {"code":206,"error":"Parse::UserCannotBeAlteredWithoutSessionError"}
     * See https://parse.com/questions/error-206-usercannotbealteredwithoutsessionerror-adding-user-relation-js-sdk
     */
//    s1 = [kURLToUsersClass copy];
//    s2 = [[@"/" stringByAppendingString:[selectedMember userId]] copy];    // ensure we add the end slash
//    userUrlPath = [[s1 stringByAppendingString:s2] copy];
//    NSLog(@"userUrlPath : %@", userUrlPath);
//    
//    NSDictionary *operationsDict = @{memberUrlPath: memberParameters, userUrlPath: userParameters};
    NSDictionary *operationsDict = @{memberUrlPath: memberParameters};
    
    [operationsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [[AFParseDotComAPIClient sharedClient] setParameterEncoding:AFJSONParameterEncoding];
        [mutableRequests addObject:[[AFParseDotComAPIClient sharedClient] requestWithMethod:@"PUT" path:key parameters:obj]];
    }];
    
    
    [self batchContentForRequests:mutableRequests
                     errorHandler:(ParseDotComErrorBlock)errorBlock
              successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock];
    
    
//    [self updateContentToURLPath: urlPath
//                    parameters: parameters
//                  errorHandler:(ParseDotComErrorBlock)errorBlock
//                successHandler:(ParseDotComObjectNotationBlock)successBlock];
    
}


- (void)insertNewAttendanceWithUser:(User *)selectedUser
                      withEvent:(Event *)selectedEvent
           errorHandler:(ParseDotComErrorBlock)errorBlock
         successHandler:(ParseDotComObjectNotationBlock)successBlock {
    
    
    NSDictionary *parameters = nil;
    //     NSString *jsonString = nil;
    NSString *urlPath = nil;
    
    
    EventRole *thisEventRole = (EventRole *)[selectedUser getRole:@"EventRole"];
    TMEventRoles roles = [thisEventRole eventRoles];
    
    
    parameters = @{@"eventId": [selectedEvent objectId],
                   @"userId": [selectedUser userId],
                   @"guestCount": [NSNumber numberWithInt:[thisEventRole guestCount]],
                   @"eventRoles":[NSNumber numberWithInt:roles],
                   };
    
    urlPath = kURLToAttendanceClass;        //Parse class object are case-sensitive.  **Must MATCH with MBaaS**
    
    
    [self postContentToURLPath: urlPath
                    parameters: parameters
                  errorHandler:(ParseDotComErrorBlock)errorBlock
                successHandler:(ParseDotComObjectNotationBlock)successBlock];
    
}


- (void)deleteAttendanceForUser:(User *)selectedUser
                       errorHandler:(ParseDotComErrorBlock)errorBlock
                     successHandler:(ParseDotComObjectNotationBlock)successBlock {
    
    
    NSDictionary *parameters = nil;
    NSString *urlPath = nil;

    if (![selectedUser attendanceId])
        return;
    
    NSMutableString *s1 = [kURLToAttendanceClass copy];
    NSMutableString *s2 = [[@"/" stringByAppendingString:[selectedUser attendanceId]] copy];    // ensure we add the end slash
    urlPath = [[s1 stringByAppendingString:s2] copy];
    s1 =s2 =nil;
    
    
    [self deleteContentAtURLPath: urlPath 
                  errorHandler:(ParseDotComErrorBlock)errorBlock
                successHandler:(ParseDotComObjectNotationBlock)successBlock];
    
}



- (void)insertNewEvent:(id)selectedEvent
          errorHandler:(ParseDotComErrorBlock)errorBlock
        successHandler:(ParseDotComObjectNotationBlock)successBlock {
    
    
    NSDictionary *parameters = nil;
    //     NSString *jsonString = nil;
    NSString *urlPath = nil;

    
    
    parameters = @{@"name": [selectedEvent name],
                   @"eventId": [selectedEvent eventId],
                   @"headcount": @0,
                   @"maybe_rsvp_count": [selectedEvent maybe_rsvp_count],
                   @"yes_rsvp_count": [selectedEvent yes_rsvp_count],
                   @"duration":  [(Event *)selectedEvent duration],
                   @"time":  [NSNumber numberWithDouble:[(Event *)selectedEvent time]],
                   @"utcOffset":  [(Event *)selectedEvent utc_offset],
                   @"status":[selectedEvent status],
                   @"groupId":
                    @{
                           @"__op":@"AddRelation",@"objects":
                              @[
                                  @{
                                   @"__type": @"Pointer",
                                   @"className": @"Group",
                                   @"objectId": @"VPQ4uXnJRB"
                                   }
                                ]
                    },
                   @"venueId":
                       @{
                           @"__op":@"AddRelation",@"objects":
                               @[
                                   @{
                                       @"__type": @"Pointer",
                                       @"className": @"Venue",
                                       @"objectId": @"9ModxnN9Zg"
                                       }
                                   ]
                           }
                   };

    urlPath = kURLToEventsClass;        //Parse class object are case-sensitive.  **Must MATCH with MBaaS**
    
    
    [self postContentToURLPath: urlPath
                    parameters: parameters
                  errorHandler:(ParseDotComErrorBlock)errorBlock
                successHandler:(ParseDotComObjectNotationBlock)successBlock];

    
}


- (void)updateAttendanceWithUser:(User *)selectedUser
                       withEvent:(Event *)selectedEvent
                    errorHandler:(ParseDotComErrorBlock)errorBlock
                  successHandler:(ParseDotComObjectNotationBlock)successBlock {
    
    NSDictionary *parameters = nil;
    NSMutableString *urlPath;
    
    
    EventRole *thisEventRole = (EventRole *)[selectedUser getRole:@"EventRole"];
    TMEventRoles roles = [thisEventRole eventRoles];
    
    
    parameters = @{@"eventId": [selectedEvent objectId],
                   @"userId": [selectedUser userId],
                   @"guestCount": [NSNumber numberWithInt:[thisEventRole guestCount]],
                   @"eventRoles":[NSNumber numberWithInt:roles],
                   };
    
    
    NSMutableString *s1 = [kURLToAttendanceClass copy];
    NSMutableString *s2 = [[@"/" stringByAppendingString:[selectedUser attendanceId]] copy];    // ensure we add the end slash
    urlPath = [[s1 stringByAppendingString:s2] copy];
    s1 =s2 =nil;
    
    //NSLog(@"urlPath : %@", urlPath);
    
    [self updateContentToURLPath: urlPath
                      parameters: parameters
                    errorHandler:(ParseDotComErrorBlock)errorBlock
                  successHandler:(ParseDotComObjectNotationBlock)successBlock];
    
}

- (void)execute:(NSArray *)operations
  forActionType:(ActionTypes)actionType
   forClassName:(NSString *)className
   errorHandler:(ParseDotComErrorBlock)errorBlock
successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock {
    
    NSMutableArray *mutableRequests = [NSMutableArray array];
    
    [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RESTApiOperation *op = (RESTApiOperation *)obj;
        [mutableRequests addObject:[[AFParseDotComAPIClient sharedClient] requestWithMethod:[op uriMethod] path:[op uriPath] parameters:[op data]]];
    }];
//
//    NSDictionary *parameters = nil;
//    //     NSString *jsonString = nil;
//    NSString *urlPath = nil;
//    
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
//    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
//    
//    parameters = @{@"firstName": @"Tom",
//                   @"lastName": @"Thumb",
//                   @"userId": @"bKacaqBBmH",
//                   @"isActive": [NSNumber numberWithBool:YES],
//                   @"memberSince": @{@"__type": @"Date",
//                                     @"iso": formattedDate},
//                   @"primaryEmail": @"tt@gmail.com"
//                   };
//    
//    NSLog(@"%@", parameters);
//    
//    dateFormatter = nil;
//    urlPath = kURLToMembersClass;        //Parse class object are case-sensitive.  **Must MATCH with MBaaS**
//    NSLog(@"%@", kURLToMembersClass);
//    
//    [self postContentToURLPath: urlPath
//                    parameters: parameters
//                  errorHandler:(ParseDotComErrorBlock)errorBlock
//                successHandler:(ParseDotComObjectNotationBlock)successBlock];
    
    
    [self batchContentForRequests:mutableRequests
                     errorHandler:(ParseDotComErrorBlock)errorBlock
              successBatchHandler:(ParseDotComBatchOperationsBlock)successBlock];
}



- (void)dealloc {
     [[[AFParseDotComAPIClient sharedClient] operationQueue] cancelAllOperations];
}

- (void)cancelAndDiscardURLConnection {
    [[[AFParseDotComAPIClient sharedClient] operationQueue] cancelAllOperations];
//    [[AFParseDotComAPIClient sharedClient] cancelAllHTTPOperationsWithMethod:fetchingURLMethod path:fetchingURLPath];
}

#pragma mark NSURLConnection Delegate


@end

NSString *ParseDotComCommunicatorErrorDomain = @"ParseDotComCommunicatorErrorDomain";

