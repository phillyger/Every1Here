//
//  MeetupDotComManager.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/31/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MeetupDotComManager.h"
#import "MeetupDotComCommunicator.h"
#import "GuestBuilder.h"
#import "EventBuilder.h"
#import "Event.h"
#import "Group.h"

@interface MeetupDotComManager ()

- (void)tellDelegateAboutGuestFetchError: (NSError *)underlyingError;
- (void)tellDelegateAboutEventFetchError: (NSError *)underlyingError;

@end

@implementation MeetupDotComManager
@synthesize eventDelegate;
@synthesize guestDelegate;
@synthesize communicator;
@synthesize eventBuilder;
@synthesize guestBuilder;
@synthesize eventToFill;

- (void)setEventDelegate:(id<EventManagerDelegate>)newDelegate {
    if (newDelegate && ![newDelegate conformsToProtocol: @protocol(EventManagerDelegate)]) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    eventDelegate = newDelegate;
}

- (void)setGuestDelegate:(id<GuestManagerDelegate>)newDelegate {
    if (newDelegate && ![newDelegate conformsToProtocol: @protocol(GuestManagerDelegate)]) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    guestDelegate = newDelegate;
}

#pragma mark Guests

- (void)fetchGuestsForEvent:(Event *)event {
    [communicator downloadGuestsForGroupName:[[event group] urlName]
                                  errorHandler:^(NSError * error){
                                      [self fetchingGuestsFailedWithError:error];
                                  }
                                successHandler:^(NSDictionary *objectNotation, SocialNetworkType slType) {
                                    [self receivedGuestsJSON:objectNotation socialNetworkType:slType];
                                }
     ];
}


- (void)fetchGuestsForGroup:(Group *)group
{
    [communicator downloadGuestsForGroupName:[group urlName]
                                errorHandler:^(NSError *error) {
                                    [self fetchingGuestsFailedWithError:error];
                                }
                              successHandler:^(NSDictionary *objectNotation, SocialNetworkType slType) {
                                  [self receivedGuestsJSON:objectNotation socialNetworkType:slType];
                              }];
}

- (void)fetchGuestsForGroupName:(NSString *)groupUrlName
{
    [communicator downloadGuestsForGroupName:groupUrlName
                                   errorHandler:^(NSError *error) {
                                       [self fetchingGuestsFailedWithError:error];
                                   }
                                 successHandler:^(NSDictionary *objectNotation, SocialNetworkType slType) {
                                     [self receivedGuestsJSON:objectNotation socialNetworkType:slType];
                                 }];
}

- (void)receivedGuestsJSON:(NSDictionary *)objectNotation socialNetworkType:(SocialNetworkType)slType {
    NSError *error = nil;
//    NSArray *guests = [guestBuilder guestsFromJSON:objectNotation socialNetworkType:slType error:&error];
    NSArray *guests = [guestBuilder usersFromJSON:objectNotation withAttendance:nil withEventId:nil withEventCode:nil socialNetworkType:slType error:&error];
    if (!guests) {
        [self fetchingGuestsFailedWithError: error];
    }
    else {
        [guestDelegate didReceiveGuests: guests];
    }
}



- (void)fetchingGuestsFailedWithError:(NSError *)error {
    [self tellDelegateAboutGuestFetchError: error];
}



#pragma mark Class Continuation
- (void)tellDelegateAboutGuestFetchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: MeetupDotComManagerError code: MeetupDotComManagerErrorGuestFetchCode userInfo: errorInfo];
    [guestDelegate retrievingGuestsFailedWithError:reportableError];
}

- (void)tellDelegateAboutEventFetchError:(NSError *)underlyingError {
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: MeetupDotComManagerError code: MeetupDotComManagerErrorUpcomingFetchCode userInfo: errorInfo];
    [eventDelegate retrievingEventsFailedWithError:reportableError];
}

@end

NSString *MeetupDotComManagerError = @"MeetupDotComManagerError";