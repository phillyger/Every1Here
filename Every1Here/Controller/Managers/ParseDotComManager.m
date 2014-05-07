//
//  Every1HereManager.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/29/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "ParseDotComManager.h"
#import "ParseDotComCommunicator.h"
#import "MemberBuilder.h"
#import "GuestBuilder.h"
#import "EventBuilder.h"
#import "Group.h"
#import "Event.h"
#import "User.h"
#import "AFHTTPRequestOperation.h"
#import "CommonUtilities.h"

@interface ParseDotComManager ()

- (void)tellDelegateAboutExecutedOpsError:(NSError *)underlyingError
                            forActionType:(ActionTypes) actionType
                             forNamedClass:(NSString *)namedClass;


@end

@implementation ParseDotComManager
@synthesize eventDelegate;
@synthesize speechDelegate;
@synthesize parseDotComDelegate;
@synthesize communicator;
@synthesize eventBuilder;
@synthesize groupBuilder;
@synthesize memberBuilder;
@synthesize guestBuilder;
@synthesize eventToFill;

- (void)setEventDelegate:(id<EventManagerDelegate>)newDelegate {
    if (newDelegate && (![newDelegate conformsToProtocol: @protocol(EventManagerDelegate)])) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    eventDelegate = newDelegate;
}



- (void)setParseDotComDelegate:(id<ParseDotComManagerDelegate>)newDelegate {
    if (newDelegate && (![newDelegate conformsToProtocol: @protocol(ParseDotComManagerDelegate)])) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    parseDotComDelegate = newDelegate;
}

- (void)setSpeechDelegate:(id<SpeechDelegate>)newDelegate {
    if (newDelegate && (![newDelegate conformsToProtocol: @protocol(SpeechDelegate)])) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    speechDelegate = newDelegate;
}

#pragma mark Attendance Operations

-(void)updateAttendanceForUser:(User*)user {
    ActionTypes actionType = Update;
    
    NSString *namedClass = [user hasRole:@"GuestRole"] ? @"GuestAttendance":@"Attendance";

    
    [communicator updateAttendance:(User*)user
                           forNamedClass:namedClass
                           errorHandler:^(NSError * error){
                               
                               [self executingOpsFailedWithError:error
                                                   forActionType:actionType
                                                    forNamedClass:namedClass];
                           }
                    successBatchHandler:^(NSArray *operations) {
                        [self receivedAttendanceOps:operations
                                     forActionType:actionType
                                      forNamedClass:namedClass
                         ];
                    }
     ];
    
}

- (void)insertAttendanceForUser:(User *)user {
    ActionTypes actionType = Insert;
    
    
    NSString *namedClass = [user hasRole:@"GuestRole"] ? @"GuestAttendance":@"Attendance";
    
    [communicator insertAttendance:(User*)user
                      forNamedClass:namedClass
                      errorHandler:^(NSError * error){
                          
                          [self executingOpsFailedWithError:error
                                              forActionType:actionType
                                               forNamedClass:namedClass];
                      }
               successSingleHandler:^(AFHTTPRequestOperation *operation) {
                   [self receivedAttendanceOp:operation
                                 forActionType:actionType
                                  forNamedClass:namedClass
                    ];
               }
     ];

}

- (void)deleteAttendanceForUser:(User *)user {
    ActionTypes actionType = Delete;
    
    NSString *namedClass = [user hasRole:@"GuestRole"] ? @"GuestAttendance":@"Attendance";
    
    [communicator deleteAttendance:(User*)user
                      forNamedClass:namedClass
                      errorHandler:^(NSError * error){
                          
                          [self executingOpsFailedWithError:error
                                              forActionType:actionType
                                               forNamedClass:namedClass];
                      }
               successBatchHandler:^(NSArray *operations) {
                   [self receivedAttendanceOps:operations
                                 forActionType:actionType
                                  forNamedClass:namedClass
                    ];
               }
     ];
    
}

-(void)receivedAttendanceOps:(NSArray *)operations
               forActionType:(ActionTypes)actionType
               forNamedClass:(NSString*)namedClass {
    
    switch (actionType) {
        case Insert:
//            [parseDotComDelegate didInsertAttendanceWithOutput:operations];
            break;
        case Update:
            [parseDotComDelegate didUpdateAttendance];
            break;
        case Delete:
            [parseDotComDelegate didDeleteAttendance];
            break;
        default:
            break;
    }
    
}

-(void)receivedAttendanceOp:(AFHTTPRequestOperation *)operation
               forActionType:(ActionTypes)actionType
                forNamedClass:(NSString*)namedClass {
    
    switch (actionType) {
        case Insert:
            [parseDotComDelegate didInsertAttendanceWithOutput:operation];
            break;
        case Update:
            [parseDotComDelegate didUpdateAttendance];
            break;
        case Delete:
            [parseDotComDelegate didDeleteAttendance];
            break;
        default:
            break;
    }
    
}

#pragma mark User Ops

-(void)insertUser:(User *)user withUserType:(UserTypes)userType {
 
     ActionTypes actionType = Insert;
    
     NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];
    
    [communicator insertUser:(User*)user
                forNamedClass:namedClass
                errorHandler:^(NSError * error){
                    
                    [self executingOpsFailedWithError:error
                                        forActionType:actionType
                                         forNamedClass:namedClass];
                }
         successBatchHandler:^(NSArray *operations) {
             [self receivedUserOps:operations
                       withEventId:nil
                    withEventCode:nil
                     forActionType:actionType
                       forUserType:userType
                      forNamedClass:namedClass
              ];
         }
     ];
    
}

- (void)insertUserList:(NSArray *)userList withUserType:(UserTypes)userType forSocialNetworkKey:(SocialNetworkType)slType {
    ActionTypes actionType = Insert;
    
    NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];
    
    [communicator insertUserList:(NSArray*)userList
                   forNamedClass:namedClass
             forSocialNetworkKey:slType
                    errorHandler:^(NSError * error){
                        
                        [self executingOpsFailedWithError:error
                                            forActionType:actionType
                                            forNamedClass:namedClass];
                    }
             successBatchHandler:^(NSArray *operations) {
                 [self receivedUserOps:operations
                           withEventId:nil
                         withEventCode:nil
                         forActionType:actionType
                           forUserType:userType
                         forNamedClass:namedClass
                  ];
             }
     ];
    
}


- (void)updateUser:(User *)user withUserType:(UserTypes)userType {
    ActionTypes actionType = Update;
    
    NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];

    [communicator updateUser:(User*)user
                           forNamedClass:namedClass
                           errorHandler:^(NSError * error){
                               
                               [self executingOpsFailedWithError:error
                                                   forActionType:actionType
                                                    forNamedClass:namedClass];
                           }
         successBatchHandler:^(NSArray *operations) {
             [self receivedUserOps:operations
                       withEventId:nil
                    withEventCode:nil
                     forActionType:actionType
                       forUserType:userType
                      forNamedClass:namedClass
              ];
         }
     ];
    
}


- (void)deleteUser:(User *)user withUserType:(UserTypes)userType {
    ActionTypes actionType = Update;
    
    NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];
    
    [communicator deleteUser:(User*)user
               forNamedClass:namedClass
                errorHandler:^(NSError * error){
                    
                    [self executingOpsFailedWithError:error
                                        forActionType:actionType
                                        forNamedClass:namedClass];
                }
         successBatchHandler:^(NSArray *operations) {
             [self receivedUserOps:operations
                       withEventId:nil
                     withEventCode:nil
                     forActionType:actionType
                       forUserType:userType
                     forNamedClass:namedClass
              ];
         }
     ];
    
}

- (void)deleteUserList:(NSArray *)userList withUserType:(UserTypes)userType forSocialNetworkKey:(SocialNetworkType)slType {
    ActionTypes actionType = Delete;
    
    NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];
    
    [communicator deleteUserList:(NSArray*)userList
               forNamedClass:namedClass
             forSocialNetworkKey:slType
                errorHandler:^(NSError * error){
                    
                    [self executingOpsFailedWithError:error
                                        forActionType:actionType
                                        forNamedClass:namedClass];
                }
         successBatchHandler:^(NSArray *operations) {
             [self receivedUserOps:operations
                       withEventId:nil
                     withEventCode:nil
                     forActionType:actionType
                       forUserType:userType
                     forNamedClass:namedClass
              ];
         }
     ];
    
}

- (void)fetchUserInfoWithUserType:(UserTypes)userType
                       withTMCCId:(NSString *)tmCCId
              withCompletionBlock:(MemberDetailsDialogControllerCompletionBlock)completionBlock;
{
    
    ActionTypes actionType = Fetch;
    
    NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];
    
    
    [communicator downloadUserInfoForActionType:actionType
                          forNamedClass:namedClass
                             withTMCCId:tmCCId
                           errorHandler:^(NSError * error){
                               
                               [self executingOpsFailedWithError:error
                                                   forActionType:actionType
                                                   forNamedClass:namedClass];
                           }
                    successBatchHandler:^(NSArray *operations) {
                        [self receivedUserFetchOps:operations
                                forActionType:actionType
                                  forUserType:userType
                                forNamedClass:namedClass
                         withCompletionBlock:completionBlock
                         ];
                    }
     ];
}


- (void)fetchUserInfoWithUserType:(UserTypes)userType
              withCompletionBlock:(MemberDetailsDialogControllerCompletionBlock)completionBlock;
{
    
    ActionTypes actionType = Fetch;
    
    NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];
    
    
    [communicator downloadUserInfoForActionType:actionType
                                  forNamedClass:namedClass
                                   errorHandler:^(NSError * error){
                                       
                                       [self executingOpsFailedWithError:error
                                                           forActionType:actionType
                                                           forNamedClass:namedClass];
                                   }
                            successBatchHandler:^(NSArray *operations) {
                                [self receivedUserFetchOps:operations
                                             forActionType:actionType
                                               forUserType:userType
                                             forNamedClass:namedClass
                                       withCompletionBlock:completionBlock
                                 ];
                            }
     ];
}

- (void)fetchUsersForEvent:(Event *)event
              withUserType:(UserTypes)userType;
{
    
    ActionTypes actionType = Fetch;
    
    NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];

    
    [communicator downloadUsersForEvent:(Event*)event
                           forActionType:actionType
                          forNamedClass:namedClass
                             errorHandler:^(NSError * error){
                
                                 [self executingOpsFailedWithError:error
                                                    forActionType:actionType
                                                    forNamedClass:namedClass];
                             }
                      successBatchHandler:^(NSArray *operations) {
                          [self receivedUserOps:operations
                                            withEventId:[event objectId]
                                          withEventCode:[event valueForKeyPath:@"type.code"]
                                          forActionType:actionType
                                        forUserType:userType
                           forNamedClass:namedClass
                                           ];
                      }
     ];
}

- (void)receivedUserOps:(NSArray *)operations
                 withEventId:(NSString *)eventId
                withEventCode:(NSNumber *)eventCode
               forActionType:(ActionTypes) actionType
                 forUserType:(UserTypes)userType
                forNamedClass:(NSString *)namedClass
{
    switch (actionType) {
        case Insert:
            [parseDotComDelegate didInsertUserForUserType:userType withOutput:operations];
            break;
        case Update:
            [parseDotComDelegate didUpdateUserForUserType:userType];
            break;
        case Fetch:
            [self receivedUserFetchOps:operations withEventId:eventId withEventCode:eventCode forActionType:actionType forUserType:userType forNamedClass:namedClass];
            break;
        case Delete:
            [parseDotComDelegate didDeleteAttendance];
            break;
        default:
            break;
    }

}

- (void)receivedUserFetchOps:(NSArray *)operations
                 withEventId:(NSString *)eventId
               withEventCode:(NSNumber *)eventCode
               forActionType:(ActionTypes) actionType
                forUserType:(UserTypes)userType
                 forNamedClass:(NSString *)namedClass
                    {
    NSError *error = nil;
    NSArray *userList;
    SocialNetworkType slType = NONE;
                        
                        
                        
    __block NSDictionary *userDict;
    __block NSDictionary *attendanceDict;
    __block NSDictionary *speechDict;

    [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *ro = obj;
        NSData *jsonData = [ro responseData];
        NSDictionary *jsonObject=[NSJSONSerialization
                                                    JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableLeaves
                                                    error:nil];
        
        
        NSLog(@"ro.request : %@", [[[ro request] URL] absoluteString]);
        
        NSString *routeNamed = [CommonUtilities fetchNamedClassClassFromUriEndPoint:[[[ro request] URL] absoluteString]];
        
        NSArray *results = (NSArray*)[jsonObject objectForKey:@"results"];
        if (results.count > 0) {
        
            if ([routeNamed isEqualToString:@"Speech"]) {
                // contains speech key
                 speechDict = jsonObject;
            } else if([routeNamed isEqualToString:@"Member"] || [routeNamed isEqualToString:@"Guest"]) {
                // contains member key
                userDict = jsonObject;
            } else if([routeNamed isEqualToString:@"Attendance"] || [routeNamed isEqualToString:@"GuestAttendance"]) {
                // contains attendance key
               attendanceDict = jsonObject;
            }

        }
        
//        if (results.count > 0) {
//            if ([[results[0] valueForKey:@"className"] isEqualToString:@"Event"]) {
//                // contains attendance key
//                attendanceDict = jsonObject;
//            } else {
//                // contains member key
//                userDict = jsonObject;
//            }
//        }
        
        
//        NSLog(@"jsonObject is %@",jsonObject);
    }];
    
    
    id userBuilder = ([namedClass isEqualToString:@"Member"] ? memberBuilder : guestBuilder);
    
    if (userDict && attendanceDict && speechDict) {
        userList = [userBuilder usersFromJSON:userDict withAttendance:attendanceDict withSpeechDict:speechDict withEventId:eventId withEventCode:eventCode socialNetworkType:slType error:&error];
    } else if (userDict && attendanceDict) {
        userList = [userBuilder usersFromJSON:userDict withAttendance:attendanceDict withEventId:eventId withEventCode:eventCode socialNetworkType:slType error:&error];
    } else if (userDict && !attendanceDict){
        userList = [userBuilder usersFromJSON:userDict withAttendance:nil withEventId:eventId withEventCode:eventCode socialNetworkType:slType error:&error];
    } else if (!userDict && !attendanceDict){
//        userList = [userBuilder usersFromJSON:nil withAttendance:nil withEventId:eventId socialNetworkType:slType error:&error];
    }

                        
    if (!userList && userType != Guest) {
        [self tellDelegateAboutExecutedOpsError:error forActionType:actionType forNamedClass:namedClass];
    }
    else {
        [parseDotComDelegate didFetchUsers:userList forUserType:(UserTypes)userType];
        
    }
}




- (void)receivedUserFetchOps:(NSArray *)operations
               forActionType:(ActionTypes) actionType
                 forUserType:(UserTypes)userType
               forNamedClass:(NSString *)namedClass
         withCompletionBlock:(MemberDetailsDialogControllerCompletionBlock)completionBlock
{
    NSError *error = nil;
    NSArray *userList;
    NSArray *tmCCResults;
    
    __block NSDictionary *userDict;
    __block NSDictionary *tmCCDict;

    
    [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *ro = obj;
        NSData *jsonData = [ro responseData];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:jsonData
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        NSArray *results = (NSArray*)[jsonObject objectForKey:@"results"];
        if (results.count > 0) {
            if ([results[0] objectForKey:@"projectTitle"]) {
                // contains speech key
                tmCCDict = jsonObject;
            } else if([results[0] objectForKey:@"firstName"]) {
                // contains member key
                userDict = jsonObject;
            }
            
        }
//        NSLog(@"jsonObject is %@",jsonObject);
    }];
    
    
    id userBuilder = ([namedClass isEqualToString:@"Member"] ? memberBuilder : guestBuilder);
    
    if (userDict) {
        userList = [userBuilder usersFromJSON:userDict error:&error];
    }
    
    if (tmCCDict) {
        tmCCResults = [tmCCDict valueForKey:@"results"];
        
    }
    
    
    if (!userList && userType != Guest) {
        [self tellDelegateAboutExecutedOpsError:error forActionType:actionType forNamedClass:namedClass];
        completionBlock(nil, nil, YES);
    }
    else {
        if (completionBlock!=nil) {
            completionBlock(userList, tmCCResults, YES);
        }
//        [parseDotComDelegate didFetchUsers:userList forUserType:(UserTypes)userType];
        
    }
}


#pragma mark Event Ops


- (void)fetchEventsForOrgId:(NSNumber *)orgId withStatus:(NSString *)status
{
    
    ActionTypes actionType = Fetch;
    NSString *namedClass = @"Event";
    
    
    [communicator downloadEventsForOrgId:orgId
                                  withStatus:status
                               forActionType: actionType
                                forNamedClass: namedClass
                                errorHandler:^(NSError * error){
                                    [self executingOpsFailedWithError:error
                                                        forActionType:actionType
                                                         forNamedClass:namedClass];
                                }
                         successSingleHandler:^(AFHTTPRequestOperation *operation) {
                             [self receivedEventsFetchOps:operation
                                            forActionType:actionType
                                             forNamedClass:namedClass];
                         }
     ];
}


- (void)receivedEventsFetchOps:(AFHTTPRequestOperation *)operation
             forActionType:(ActionTypes) actionType
              forNamedClass:(NSString *)namedClass{
    
//    NSError *error = nil;
//    NSArray *events = [eventBuilder eventsFromJSON:objectNotation error: &error];
    
    
    NSError *error = nil;
    NSArray *events;
    
    NSDictionary *eventDict;
    
    AFHTTPRequestOperation *ro = operation;
    NSData *jsonData = [ro responseData];
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:jsonData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    

    eventDict = jsonObject;

    
//    NSLog(@"jsonObject is %@",jsonObject);

    
    if (eventDict ) {
        events = [eventBuilder eventsFromJSON:eventDict error: &error];
    }
    
    
    if (!events) {
        [self tellDelegateAboutExecutedOpsError:error forActionType:actionType forNamedClass:namedClass];
    }
    else {
        [eventDelegate didReceiveEvents: events];
    }
}




- (void)fetchingEventsFailedWithError:(NSError *)error
                        forActionType:(ActionTypes) actionType
                         forNamedClass:(NSString *)namedClass{

    [self tellDelegateAboutExecutedOpsError:error forActionType:actionType forNamedClass:namedClass];
}




#pragma mark Class Continuation

- (void)executingOpsFailedWithError:(NSError *)error
                      forActionType:(ActionTypes) actionType
                       forNamedClass:(NSString *)namedClass{
    [self tellDelegateAboutExecutedOpsError: error
                              forActionType:(ActionTypes) actionType
                               forNamedClass:(NSString *)namedClass];
}

- (void)tellDelegateAboutExecutedOpsError:(NSError *)underlyingError
                            forActionType:(ActionTypes) actionType
                             forNamedClass:(NSString *)namedClass {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [parseDotComDelegate executedOpsFailedWithError:reportableError
                                      forActionType:(ActionTypes) actionType
                                       forNamedClass:(NSString *)namedClass];
}



#pragma mark Speech Ops
-(void)updateSpeechForUser:(User*)user {
    ActionTypes actionType = Update;
    
    NSString *namedClass = @"Speech";
    
    
    [communicator updateSpeech:(User*)user
                     forNamedClass:(NSString*)namedClass
                      errorHandler:^(NSError * error){
                          
                          [self executingOpsFailedWithError:error
                                              forActionType:actionType
                                              forNamedClass:namedClass];
                      }
               successSingleHandler:^(AFHTTPRequestOperation *operation) {
                   [self receivedSpeechOp:operation
                                 forActionType:actionType
                                 forNamedClass:namedClass
                    ];
               }
     ];
    
}

- (void)insertSpeechForUser:(User *)user {
    ActionTypes actionType = Insert;
    
    
    NSString *namedClass = @"Speech";
    
    [communicator insertSpeech:(User*)user
                     forNamedClass:namedClass
                      errorHandler:^(NSError * error){
                          
                          [self executingOpsFailedWithError:error
                                              forActionType:actionType
                                              forNamedClass:namedClass];
                      }
               successSingleHandler:^(AFHTTPRequestOperation *operation) {
                   [self receivedSpeechOp:operation
                                 forActionType:actionType
                                 forNamedClass:namedClass
                    ];
               }
     ];
    
}

- (void)deleteSpeechForUser:(User *)user {
    ActionTypes actionType = Delete;
    
    NSString *namedClass = @"Speech";
    
    [communicator deleteSpeech:(User*)user
                     forNamedClass:namedClass
                      errorHandler:^(NSError * error){
                          
                          [self executingOpsFailedWithError:error
                                              forActionType:actionType
                                              forNamedClass:namedClass];
                      }
               successBatchHandler:^(NSArray *operations) {
                   [self receivedSpeechOps:operations
                                 forActionType:actionType
                                 forNamedClass:namedClass
                    ];
               }
     ];
    
}

-(void)receivedSpeechOps:(NSArray*)operations
               forActionType:(ActionTypes)actionType
               forNamedClass:(NSString*)namedClass {
    
    switch (actionType) {
        case Insert:
            [speechDelegate didInsertSpeechWithOutput:(AFHTTPRequestOperation *)[operations firstObject]];
            break;
        case Update:
            [speechDelegate didUpdateSpeech];
            break;
        case Delete:
            [speechDelegate didDeleteSpeech];
            break;
        default:
            break;
    }
    
}

-(void)receivedSpeechOp:(AFHTTPRequestOperation *)operation
           forActionType:(ActionTypes)actionType
           forNamedClass:(NSString*)namedClass {
    
    switch (actionType) {
        case Insert:
            [speechDelegate didInsertSpeechWithOutput:operation];
            break;
        case Update:
            [speechDelegate didUpdateSpeech];
            break;
        case Delete:
            [speechDelegate didDeleteSpeech];
            break;
        default:
            break;
    }
    
}

- (void)fetchingMembersFailedWithError:(NSError *)error {}

- (void)receivedMembersFetchOps:(NSArray *)operations {}

@end

NSString *ParseDotComManagerError = @"ParseDotComManagerError";
