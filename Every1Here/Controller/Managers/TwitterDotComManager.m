//
//  TwitterDotComManager.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/23/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "TwitterDotComManager.h"
#import "TwitterDotComCommunicator.h"
#import "GuestBuilder.h"

#define kURLToFetchMembers @"2/members?" 

@interface TwitterDotComManager ()

- (void)tellDelegateAboutGuestFetchError: (NSError *)underlyingError;

@end

@implementation TwitterDotComManager
@synthesize guestDelegate;
@synthesize communicator;
@synthesize guestBuilder;


- (void)setGuestDelegate:(id<GuestManagerDelegate>)newDelegate {
    if (newDelegate && ![newDelegate conformsToProtocol: @protocol(GuestManagerDelegate)]) {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    guestDelegate = newDelegate;
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
//    NSArray *guests = [guestBuilder usersFromJSON:objectNotation socialNetworkType:slType error:&error];
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
    NSError *reportableError = [NSError errorWithDomain: TwitterDotComManagerError code: TwitterDotComManagerErrorGuestFetchCode userInfo: errorInfo];
    [guestDelegate retrievingGuestsFailedWithError:reportableError];
}


@end

NSString *TwitterDotComManagerError = @"TwitterDotComManagerError";
