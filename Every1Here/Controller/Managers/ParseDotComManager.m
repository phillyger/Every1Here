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
#import "E1HOperationFactory.h"

@interface ParseDotComManager ()

- (void)tellDelegateAboutMemberFetchError: (NSError *)underlyingError;
- (void)tellDelegateAboutNewUserInsertError: (NSError *)underlyingError;
- (void)tellDelegateAboutNewMemberInsertError: (NSError *)underlyingError;
- (void)tellDelegateAboutExistingUserUpdateError: (NSError *)underlyingError;

- (void)tellDelegateAboutEventFetchError: (NSError *)underlyingError;
- (void)tellDelegateAboutNewEventInsertError: (NSError *)underlyingError;

- (void)tellDelegateAboutNewAttendanceInsertError: (NSError *)underlyingError;

- (void)tellDelegateAboutExistingMemberUpdateError: (NSError *)underlyingError;

- (void)tellDelegateAboutExistingAttendanceUpdateError: (NSError *)underlyingError;
- (void)tellDelegateAboutExistingAttendanceDeleteError: (NSError *)underlyingError;
- (void)tellDelegateAboutOpsInsertError: (NSError *)underlyingError;



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
                                     [self executeOpsFailedWithError:error
                                                forActionType:actionType
                                                forClassName:className];
                                 }
                          successBatchHandler:^(NSArray *operations) {
                              [self executedOps:operations
                                  forActionType:actionType
                                   forClassName:className];
                          }
     ];
}

#pragma mark Members

//- (void)fetchMembersForGroup:(Group *)group
//{
//    [communicator downloadMembersForGroupName:[group name]
//                                  errorHandler:^(NSError * error){
//                                      [self fetchingMembersFailedWithError:error];
//                                  }
//                                successHandler:^(NSDictionary *objectNotation) {
//                                    [self receivedMembersJSON:objectNotation];
//                                }
//     ];
//}
//
//- (void)fetchMembersForGroupName:(NSString *)groupName
//{
//    [communicator downloadMembersForGroupName:groupName
//                                  errorHandler:^(NSError * error){
//                                      [self fetchingMembersFailedWithError:error];
//                                  }
//                                successHandler:^(NSDictionary *objectNotation) {
//                                    [self receivedMembersJSON:objectNotation];
//                                }
//     ];
//}

- (void)fetchMembersForEvent:(Event *)event
{
    [communicator downloadMembersForGroupName:[[event group] name]
                                  withEventId:[event objectId]
                                  errorHandler:^(NSError * error){
                                      [self fetchingMembersFailedWithError:error];
                                  }
                                successBatchHandler:^(NSArray *operations) {
                                    [self receivedMembersFetchOps:operations withEventId:[event objectId]];
                                }
     ];
}

- (void)fetchGuestsForEvent:(Event *)event
{
    [communicator downloadGuestsForGroupName:[[event group] name]
                                  withEventId:[event objectId]
                                 errorHandler:^(NSError * error){
                                     [self fetchingGuestsFailedWithError:error];
                                 }
                          successBatchHandler:^(NSArray *operations) {
                              [self receivedGuestsFetchOps:operations];
                          }
     ];
}



- (void)receivedMembersFetchOps:(NSArray *)operations withEventId:(NSString *)eventId {
    NSError *error = nil;
    NSArray *members;
    
//    __block BOOL hasNoDictOp = false;
//    __block NSUInteger noDictOpCount = 0;
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
        [self tellDelegateAboutMemberFetchError: error];
    }
    

    else {
        [memberDelegate didReceiveMembers: members];
    }
}

- (void)executedOps:(NSArray *)operations
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


- (void)receivedGuestsFetchOps:(NSArray *)operations {
    NSError *error = nil;
    NSArray *guests;
    
    //    __block BOOL hasNoDictOp = false;
    //    __block NSUInteger noDictOpCount = 0;
    __block NSDictionary *guestDict;
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
                guestDict = jsonObject;
            }
        }
        //NSLog(@"jsonObject is %@",jsonObject);
    }];
    
    
    
//    if (guestDict && attendanceDict) {
//        guests = [guestBuilder guestsFromJSON:guestDict withAttendance:nil error:&error];
//    } else if (memberDict && !attendanceDict){
//        guests = [guestBuilder guestsFromJSON:guestDict withAttendance:nil error:&error];
//    } else if (!memberDict && !attendanceDict){
//       guests = [guestBuilder guestsFromJSON:nil withAttendance:nil error:&error];    }
//    
//    if (!members ) {
//        [self tellDelegateAboutMemberFetchError: error];
//    }else {
//        [memberDelegate didReceiveGuests: members];
//    }
}


- (void)fetchingMembersFailedWithError:(NSError *)error {
    [self tellDelegateAboutMemberFetchError: error];
}


- (void)fetchingGuestsFailedWithError:(NSError *)error {
//    [self tellDelegateAboutMemberFetchError: error];
}


#pragma mark - CRUD methods for Parse Users

- (void)createNewUser:(User *)selectedMember
            withEvent: (Event *)selectedEvent{
    [communicator insertNewUser:selectedMember
                   errorHandler:^(NSError * error) {
                       [self insertingNewUserFailedWithError:error];
                   }
                 successHandler:^(NSDictionary *objectNotation) {
                     [self createdNewUserJSONResponse:objectNotation withUser:(User *)selectedMember withEvent: (Event *)selectedEvent];
                }
     ];
}



- (void)createNewMember:(User *)selectedMember
              withEvent: (Event *)selectedEvent {
    [communicator insertNewMember:selectedMember
                   errorHandler:^(NSError * error) {
                       [self insertingNewMemberFailedWithError:error];
                   }
                 successHandler:^(NSDictionary *objectNotation) {
                     [self createdNewMemberJSONResponse:objectNotation withUser:(User *)selectedMember withEvent: (Event *)selectedEvent];
                 }
     ];
}

- (void)createNewGuest:(User *)selectedGuest
             withEvent:(id)selectedEvent {
    [communicator insertNewGuest:selectedGuest
                     errorHandler:^(NSError * error) {
                         [self insertingNewGuestFailedWithError:error];
                     }
                   successHandler:^(NSDictionary *objectNotation) {
                       [self createdNewGuestJSONResponse:objectNotation withUser:(User *)selectedGuest withEvent: (Event *)selectedEvent];
                   }
     ];
}


- (void)updateExistingUser:(User *)selectedUser
             withClassType:(NSString *)classType{
    [communicator updateExistingUser:selectedUser
                         withClassType:(NSString *)classType
                     errorHandler:^(NSError * error) {
                         [self updatingExistingUserFailedWithError:error];
                     }
                   successBatchHandler:^(NSArray *operations) {
                       [self updateExistingUserOps:operations withUser:selectedUser];
                   }
     ];
}


- (void)createNewAttendanceWithUser:(User *)selectedUser
                          withEvent:(Event *)selectedEvent {
    [communicator insertNewAttendanceWithUser:selectedUser
                                withEvent:selectedEvent 
                     errorHandler:^(NSError * error) {
                         [self insertingNewAttendanceFailedWithError:error];
                     }
                   successHandler:^(NSDictionary *objectNotation) {
                       [self createdNewAttendanceJSONResponse:objectNotation withUser:(User *)selectedUser withEvent:(Event *)selectedEvent];
                   }
     ];
}


- (void)updateAttendanceWithUser:(User *)selectedUser
                          withEvent:(Event *)selectedEvent {
    [communicator updateAttendanceWithUser:selectedUser
                                    withEvent:selectedEvent
                                 errorHandler:^(NSError * error) {
                                     [self updatingAttendanceFailedWithError:error];
                                 }
                               successHandler:^(NSDictionary *objectNotation) {
                                   [self updatedAttendanceJSONResponse:objectNotation withUser:(User *)selectedUser withEvent:(Event *)selectedEvent];
                               }
     ];
}


- (void)deleteAttendanceForUser:(User *)selectedUser{
    [communicator deleteAttendanceForUser:selectedUser
                            errorHandler:^(NSError * error) {
                                  [self deletingAttendanceFailedWithError:error];
                              }
                            successHandler:^(NSDictionary *objectNotation) {
                                [self deletingAttendanceJSONResponse:objectNotation forUser:(User *)selectedUser];
                            }
     ];
}


- (void)executeOpsFailedWithError:(NSError *)error
                    forActionType:(ActionTypes) actionType
                     forClassName:(NSString *)className{
    [self tellDelegateAboutExecutedOpsError: error
                            forActionType:(ActionTypes) actionType
                             forClassName:(NSString *)className];
}

- (void)insertingNewUserFailedWithError:(NSError *)error {
    [self tellDelegateAboutNewUserInsertError: error];
}

- (void)insertingNewMemberFailedWithError:(NSError *)error {
    [self tellDelegateAboutNewMemberInsertError: error];
}

- (void)insertingNewGuestFailedWithError:(NSError *)error {
    [self tellDelegateAboutNewMemberInsertError: error];
}

- (void)insertingNewAttendanceFailedWithError:(NSError *)error {
    [self tellDelegateAboutNewAttendanceInsertError: error];
}

- (void)updatingAttendanceFailedWithError:(NSError *)error {
    [self tellDelegateAboutExistingAttendanceUpdateError: error];
}

- (void)deletingAttendanceFailedWithError:(NSError *)error {
    [self tellDelegateAboutExistingAttendanceDeleteError: error];
}

- (void)updatingExistingUserFailedWithError:(NSError *)error {
    [self tellDelegateAboutExistingMemberUpdateError: error];
}


- (void)createdNewUserJSONResponse:(NSDictionary *)objectNotation
                          withUser:(User *)selectedMember
                         withEvent: (Event *)selectedEvent{
    [objectNotation enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key %@ has a value of %@", key, obj);
    }];
    [selectedMember setUserId:[objectNotation objectForKey:@"objectId"]];   // we set objectId from User table to a field in the Member/Guest table.
    [parseDotComDelegate didInsertNewUser:(User *)selectedMember withEvent: (Event *)selectedEvent];
}





- (void)createdNewMemberJSONResponse:(NSDictionary *)objectNotation
                            withUser:(User *)selectedMember
                           withEvent: (Event *)selectedEvent{
    [selectedMember setObjectId:[objectNotation objectForKey:@"objectId"]];
    [memberDelegate didInsertNewMember:(User *)selectedMember withEvent: (Event *)selectedEvent];
}

- (void)createdNewGuestJSONResponse:(NSDictionary *)objectNotation
                            withUser:(User *)selectedUser
                           withEvent: (Event *)selectedEvent{
    [selectedUser setObjectId:[objectNotation objectForKey:@"objectId"]];
    [parseDotComDelegate didInsertNewGuest:(User *)selectedUser withEvent: (Event *)selectedEvent];
}

- (void)createdNewAttendanceJSONResponse:(NSDictionary *)objectNotation
                                    withUser:(User *)selectedUser
                                   withEvent:(Event *)selectedEvent {
    
    [selectedUser setAttendanceId:[objectNotation objectForKey:@"objectId"]];   // we set objectId from Attendance table to a field in the Member/Guest table.
    [parseDotComDelegate didInsertNewAttendanceWithUser:(User *)selectedUser
                                         withEvent:(Event *)selectedEvent];
    
}

- (void)updatedAttendanceJSONResponse:(NSDictionary *)objectNotation
                                withUser:(User *)selectedUser
                               withEvent:(Event *)selectedEvent {
    
    [parseDotComDelegate didUpdateAttendanceWithUser:(User *)selectedUser
                                         withEvent:(Event *)selectedEvent];
    
}

- (void)deletingAttendanceJSONResponse:(NSDictionary *)objectNotation
                             forUser:(User *)selectedUser {
    
    [parseDotComDelegate didDeleteAttendanceForUser:(User *)selectedUser];
    
}

- (void)updateExistingUserOps:(NSArray *)operations withUser:(User *)selectedUser{
    
//    
//    __block NSDictionary *memberDict;
//    __block NSDictionary *userDict;
//    
//    [operations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        AFHTTPRequestOperation *ro = obj;
//        NSData *jsonData = [ro responseData];
//        NSDictionary *jsonObject=[NSJSONSerialization
//                                  JSONObjectWithData:jsonData
//                                  options:NSJSONReadingMutableLeaves
//                                  error:nil];
//        
//        NSArray *results = (NSArray*)[jsonObject objectForKey:@"results"];
//        NSLog(@"jsonObject is %@",jsonObject);
//                            
//        if (results.count > 0) {
//            if ([results[0] objectForKey:@"username"]) {
//                // contains attendance key
//                userDict = jsonObject;
//            } else {
//                // contains member key
//                memberDict = jsonObject;
//            }
//        }
//                            
//        }];
    

    
    [parseDotComDelegate didUpdateExistingUser:(User *)selectedUser];
}

#pragma mark Events

- (void)receivedEventsJSON:(NSDictionary *)objectNotation {
    NSError *error = nil;
    NSArray *events = [eventBuilder eventsFromJSON:objectNotation error: &error];
    if (!events) {
        [self tellDelegateAboutEventFetchError: error];
    }
    else {
        [eventDelegate didReceiveEvents: events];
    }
}

- (void)fetchPastEventsForGroup:(Group *)group
{
    [communicator downloadPastEventsForGroupName:[group name]
                                    errorHandler:^(NSError * error){
                                        [self fetchingEventsFailedWithError:error];
                                    }
                                  successHandler:^(NSDictionary *objectNotation) {
                                      [self receivedEventsJSON:objectNotation];
                                  }
     ];
}

- (void)fetchPastEventsForGroupName:(NSString *)groupName
{
    [communicator downloadPastEventsForGroupName:groupName
                                    errorHandler:^(NSError * error){
                                        [self fetchingEventsFailedWithError:error];
                                    }
                                  successHandler:^(NSDictionary *objectNotation) {
                                      [self receivedEventsJSON:objectNotation];
                                  }
     ];
}

- (void)fetchEventsForGroupName:(NSString *)groupName status:(NSString *)status
{
    [communicator downloadEventsForGroupName:groupName
                                    status:status
                                    errorHandler:^(NSError * error){
                                        [self fetchingEventsFailedWithError:error];
                                    }
                                  successHandler:^(NSDictionary *objectNotation) {
                                      [self receivedEventsJSON:objectNotation];
                                  }
     ];
}


- (void)fetchingEventsFailedWithError:(NSError *)error {
    [self tellDelegateAboutEventFetchError: error];
}


#pragma mark - - CRUD methods for Parse Events

- (void)createNewEvent:(Event *)selectedEvent {
    [communicator insertNewEvent:selectedEvent
                   errorHandler:^(NSError * error) {
                       [self insertingNewEventFailedWithError:error];
                   }
                 successHandler:^(NSDictionary *objectNotation) {
                     [self createdNewEventJSONResponse:objectNotation withEvent:(Event *)selectedEvent];
                 }
     ];
}

- (void)insertingNewEventFailedWithError:(NSError *)error {
    [self tellDelegateAboutNewEventInsertError: error];
}


- (void)createdNewEventJSONResponse:(NSDictionary *)objectNotation withEvent:(Event *)selectedEvent{
    [objectNotation enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key %@ has a value of %@", key, obj);
    }];
    [selectedEvent setObjectId:[objectNotation objectForKey:@"objectId"]];
    [eventDelegate didInsertNewEvent:(Event *)selectedEvent];
}



#pragma mark Class Continuation
- (void)tellDelegateAboutEventFetchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorPastEventFetchCode userInfo: errorInfo];
    [eventDelegate retrievingEventsFailedWithError:reportableError];
}

- (void)tellDelegateAboutNewEventInsertError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [eventDelegate insertingNewEventFailedWithError:reportableError];
}


- (void)tellDelegateAboutMemberFetchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [memberDelegate retrievingMembersFailedWithError:reportableError];
}


- (void)tellDelegateAboutNewUserInsertError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [parseDotComDelegate insertingNewUserFailedWithError:reportableError];
}

- (void)tellDelegateAboutNewMemberInsertError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [memberDelegate insertingNewMemberFailedWithError:reportableError];
}


- (void)tellDelegateAboutExistingUserUpdateError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [parseDotComDelegate updatingExistingUserFailedWithError:reportableError];
}

- (void)tellDelegateAboutNewAttendanceInsertError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [parseDotComDelegate insertingNewAttendanceFailedWithError:reportableError];
}

- (void)tellDelegateAboutExistingMemberUpdateError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [parseDotComDelegate updatingExistingUserFailedWithError:reportableError];
}


- (void)tellDelegateAboutExistingAttendanceUpdateError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [parseDotComDelegate updatingExistingUserAttendanceFailedWithError:reportableError];
}

- (void)tellDelegateAboutExistingAttendanceDeleteError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: ParseDotComManagerError code: ParseDotComManagerErrorMemberFetchCode userInfo: errorInfo];
    [parseDotComDelegate deletingExistingUserAttendanceFailedWithError:reportableError];
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
