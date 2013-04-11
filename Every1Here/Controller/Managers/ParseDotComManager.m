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

@interface ParseDotComManager ()

- (void)tellDelegateAboutExecutedOpsError:(NSError *)underlyingError
                            forActionType:(ActionTypes) actionType
                             forClassName:(NSString *)className;


@end

@implementation ParseDotComManager
@synthesize eventDelegate;
@synthesize memberDelegate;
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

- (void)setMemberDelegate:(id<MemberManagerDelegate>)newDelegate {
    if (newDelegate && (![newDelegate conformsToProtocol: @protocol(MemberManagerDelegate)])) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    memberDelegate = newDelegate;
}

- (void)setParseDotComDelegate:(id<ParseDotComManagerDelegate>)newDelegate {
    if (newDelegate && (![newDelegate conformsToProtocol: @protocol(ParseDotComManagerDelegate)])) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    parseDotComDelegate = newDelegate;
}


#pragma mark Operations

- (void)execute:(NSArray *)operations
  forActionType:(ActionTypes) actionType
   forClassName:(NSString *)className
   {
    [communicator execute:operations
            forActionType:(ActionTypes) actionType
             forClassName:(NSString *)className
                                 errorHandler:^(NSError * error){
                                     [self executingOpsFailedWithError:error
                                                forActionType:actionType
                                                forClassName:className];
                                 }
                          successBatchHandler:^(NSArray *operations) {
                              [self receivedExecutedOps:operations
                                  forActionType:actionType
                                   forClassName:className];
                          }
     ];
}


- (void)receivedExecutedOps:(NSArray *)operations
              forActionType:(ActionTypes) actionType
               forClassName:(NSString *)className {
    
    //    [selectedUser setAttendanceId:[objectNotation objectForKey:@"objectId"]];   // we set objectId from Attendance table to a field in the Member/Guest table.
    
    NSMutableArray *mutableJSONObjects = [[NSMutableArray alloc] init];
    
    [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *ro = obj;
        NSData *jsonData = [ro responseData];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:jsonData
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        [mutableJSONObjects addObject:jsonObject];
    }];
    
    [parseDotComDelegate didExecuteOps:mutableJSONObjects forActionType:actionType forClassName:className];
    
}


-(void)updateAttendanceForUser:(User*)user {
    ActionTypes actionType = Update;
    
    NSString *className = @"Attendance";
    
    [communicator updateAttendance:(User*)user
                           forClassName:className
                           errorHandler:^(NSError * error){
                               
                               [self executingOpsFailedWithError:error
                                                   forActionType:actionType
                                                    forClassName:className];
                           }
                    successBatchHandler:^(NSArray *operations) {
                        [self receivedAttendanceOps:operations
                                     forActionType:actionType
                                      forClassName:className
                         ];
                    }
     ];
    
}

- (void)insertAttendanceForUser:(User *)user {
    ActionTypes actionType = Insert;
    
    NSString *className = @"Attendance";
    
    [communicator insertAttendance:(User*)user
                      forClassName:className
                      errorHandler:^(NSError * error){
                          
                          [self executingOpsFailedWithError:error
                                              forActionType:actionType
                                               forClassName:className];
                      }
               successBatchHandler:^(NSArray *operations) {
                   [self receivedAttendanceOps:operations
                                 forActionType:actionType
                                  forClassName:className
                    ];
               }
     ];

}

- (void)deleteAttendanceForUser:(User *)user {
    ActionTypes actionType = Insert;
    
    NSString *className = @"Attendance";
    
    [communicator deleteAttendance:(User*)user
                      forClassName:className
                      errorHandler:^(NSError * error){
                          
                          [self executingOpsFailedWithError:error
                                              forActionType:actionType
                                               forClassName:className];
                      }
               successBatchHandler:^(NSArray *operations) {
                   [self receivedAttendanceOps:operations
                                 forActionType:actionType
                                  forClassName:className
                    ];
               }
     ];
    
}



#pragma mark User Ops


- (void)updateUser:(User *)user withUserType:(UserTypes)userType {
    ActionTypes actionType = Fetch;
    
    NSString *className = nil;
    
    switch (userType) {
        case Member:
            className = @"Member";
            break;
        case Guest:
            className = @"Guest";
        default:
            break;
    }

    [communicator updateUser:(User*)user
                           forClassName:className
                           errorHandler:^(NSError * error){
                               
                               [self executingOpsFailedWithError:error
                                                   forActionType:actionType
                                                    forClassName:className];
                           }
         successBatchHandler:^(NSArray *operations) {
             [self receivedUserOps:operations
                       withEventId:nil
                     forActionType:actionType
                       forUserType:userType
                      forClassName:className
              ];
         }
     ];
    
}

- (void)fetchUsersForEvent:(Event *)event
              forUserType:(UserTypes)userType;
{
    
    ActionTypes actionType = Fetch;
    
    NSString *className = nil;
    
    switch (userType) {
        case Member:
            className = @"Member";
            break;
        case Guest:
            className = @"Guest";
        default:
            break;
    }

    
    [communicator downloadUsersForEvent:(Event*)event
                           forActionType:actionType
                          forClassName:className
                             errorHandler:^(NSError * error){
                
                                 [self executingOpsFailedWithError:error
                                                    forActionType:actionType
                                                    forClassName:className];
                             }
                      successBatchHandler:^(NSArray *operations) {
                          [self receivedUserOps:operations
                                            withEventId:[event objectId]
                                          forActionType:actionType
                                        forUserType:userType
                           forClassName:className
                                           ];
                      }
     ];
}

- (void)receivedUserOps:(NSArray *)operations
                 withEventId:(NSString *)eventId
               forActionType:(ActionTypes) actionType
                 forUserType:(UserTypes)userType
                forClassName:(NSString *)className
{
    switch (actionType) {
        case Insert:
            [parseDotComDelegate didInsertUserForUserType:userType];
            break;
        case Update:
            [parseDotComDelegate didUpdateUserForUserType:userType];
            break;
        case Fetch:
            [self receivedUserOps:operations withEventId:eventId forActionType:actionType forUserType:userType forClassName:className];
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
                 forClassName:(NSString *)className
                    {
    NSError *error = nil;
    NSArray *members;
                        
    __block NSDictionary *memberDict;
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
                memberDict = jsonObject;
            }
        } 
        //NSLog(@"jsonObject is %@",jsonObject);
    }];
    
    
    
    if (memberDict && attendanceDict) {
        members = [memberBuilder membersFromJSON:memberDict withAttendance:attendanceDict withEventId:eventId error:&error];
    } else if (memberDict && !attendanceDict){
        members = [memberBuilder membersFromJSON:memberDict withAttendance:nil withEventId:eventId error:&error];
    } else if (!memberDict && !attendanceDict){
        members = [memberBuilder membersFromJSON:nil withAttendance:nil withEventId:eventId error:&error];
    }

                        
    if (!members ) {
        [self tellDelegateAboutExecutedOpsError:error forActionType:actionType forClassName:className];
    }
    else {
        [parseDotComDelegate didFetchUsersForUserType:userType];
        
    }
}


#pragma mark Attendence Ops

-(void)receivedAttendanceOps:operations
             forActionType:(ActionTypes)actionType
              forClassName:(NSString*)className {
    
    switch (actionType) {
        case Insert:
            [parseDotComDelegate didInsertAttendance];
            break;
        case Update:
            [parseDotComDelegate didUpdateAttendance];
            break;
        case Fetch:
            [parseDotComDelegate didFetchAttendance];
            break;
        case Delete:
            [parseDotComDelegate didDeleteAttendance];
            break;
        default:
            break;
    }

}

#pragma mark Event Ops


- (void)fetchEventsForGroupName:(NSString *)groupName withStatus:(NSString *)status
{
    
    ActionTypes actionType = Fetch;
    NSString *className = @"Event";
    
    
    [communicator downloadEventsForGroupName:groupName
                                  withStatus:status
                               forActionType: actionType
                                forClassName: className
                                errorHandler:^(NSError * error){
                                    [self executingOpsFailedWithError:error
                                                        forActionType:actionType
                                                         forClassName:className];
                                }
                         successBatchHandler:^(NSArray *operations) {
                             [self receivedEventsFetchOps:operations
                                            forActionType:actionType
                                             forClassName:className];
                         }
     ];
}


- (void)receivedEventsFetchOps:(NSArray *)operations
             forActionType:(ActionTypes) actionType
              forClassName:(NSString *)className{
    
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
        [self tellDelegateAboutExecutedOpsError:error forActionType:actionType forClassName:className];
    }
    else {
        [eventDelegate didReceiveEvents: events];
    }
}




- (void)fetchingEventsFailedWithError:(NSError *)error
                        forActionType:(ActionTypes) actionType
                         forClassName:(NSString *)className{

    [self tellDelegateAboutExecutedOpsError:error forActionType:actionType forClassName:className];
}




#pragma mark Class Continuation

- (void)executingOpsFailedWithError:(NSError *)error
                      forActionType:(ActionTypes) actionType
                       forClassName:(NSString *)className{
    [self tellDelegateAboutExecutedOpsError: error
                              forActionType:(ActionTypes) actionType
                               forClassName:(NSString *)className];
}

- (void)tellDelegateAboutExecutedOpsError:(NSError *)underlyingError
                            forActionType:(ActionTypes) actionType
                             forClassName:(NSString *)className {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [parseDotComDelegate executedOpsFailedWithError:reportableError
                                      forActionType:(ActionTypes) actionType
                                       forClassName:(NSString *)className];
}





@end

NSString *ParseDotComManagerError = @"ParseDotComManagerError";
