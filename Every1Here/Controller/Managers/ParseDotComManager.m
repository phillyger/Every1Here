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



#pragma mark Attendance Operations

-(void)updateAttendanceForUser:(User*)user {
    ActionTypes actionType = Update;
    
    NSString *namedClass = @"Attendance";
    
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
    
    NSString *namedClass = @"Attendance";
    
    [communicator insertAttendance:(User*)user
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

- (void)deleteAttendanceForUser:(User *)user {
    ActionTypes actionType = Delete;
    
    NSString *namedClass = @"Attendance";
    
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

-(void)receivedAttendanceOps:operations
               forActionType:(ActionTypes)actionType
                forNamedClass:(NSString*)namedClass {
    
    switch (actionType) {
        case Insert:
            [parseDotComDelegate didInsertAttendanceWithOutput:operations];
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
                     forActionType:actionType
                       forUserType:userType
                     forNamedClass:namedClass
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
                                          forActionType:actionType
                                        forUserType:userType
                           forNamedClass:namedClass
                                           ];
                      }
     ];
}

- (void)receivedUserOps:(NSArray *)operations
                 withEventId:(NSString *)eventId
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
            [self receivedUserFetchOps:operations withEventId:eventId forActionType:actionType forUserType:userType forNamedClass:namedClass];
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
               forActionType:(ActionTypes) actionType
                forUserType:(UserTypes)userType
                 forNamedClass:(NSString *)namedClass
                    {
    NSError *error = nil;
    NSArray *userList;
    SocialNetworkType slType = NONE;
                        
                        
                        
    __block NSDictionary *userDict;
    __block NSDictionary *attendanceDict;

    [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *ro = obj;
        NSData *jsonData = [ro responseData];
        NSDictionary *jsonObject=[NSJSONSerialization
                                                    JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableLeaves
                                                    error:nil];
        
        NSArray *results = (NSArray*)[jsonObject objectForKey:@"results"];
        if (results.count > 0) {
            if ([results[0] objectForKey:@"eventRoles"]) {
                // contains attendance key
                attendanceDict = jsonObject;
            } else {
                // contains member key
                userDict = jsonObject;
            }
        } 
        //NSLog(@"jsonObject is %@",jsonObject);
    }];
    
    
    id userBuilder = ([namedClass isEqualToString:@"Member"] ? memberBuilder : guestBuilder);
    
    if (userDict && attendanceDict) {
        
        userList = [userBuilder usersFromJSON:userDict withAttendance:attendanceDict withEventId:eventId socialNetworkType:slType error:&error];
    } else if (userDict && !attendanceDict){
        userList = [userBuilder usersFromJSON:userDict withAttendance:nil withEventId:eventId socialNetworkType:slType error:&error];
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
                         successBatchHandler:^(NSArray *operations) {
                             [self receivedEventsFetchOps:operations
                                            forActionType:actionType
                                             forNamedClass:namedClass];
                         }
     ];
}


- (void)receivedEventsFetchOps:(NSArray *)operations
             forActionType:(ActionTypes) actionType
              forNamedClass:(NSString *)namedClass{
    
//    NSError *error = nil;
//    NSArray *events = [eventBuilder eventsFromJSON:objectNotation error: &error];
    
    
    NSError *error = nil;
    NSArray *events;
    
    __block NSDictionary *eventDict;
    
    [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *ro = obj;
        NSData *jsonData = [ro responseData];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:jsonData
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        NSArray *results = (NSArray*)[jsonObject objectForKey:@"results"];
        if (results.count > 0) {
            eventDict = jsonObject;

        }
        NSLog(@"jsonObject is %@",jsonObject);
    }];
    
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





@end

NSString *ParseDotComManagerError = @"ParseDotComManagerError";
