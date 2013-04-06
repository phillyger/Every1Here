//
//  MeetupDotComCommunicator.h
//  Anseo
//
//  Created by Ger O'Sullivan on 1/31/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetupDotComCommunicatorDelegate.h"
#import "EventCommunicatorDelegate.h"
#import "GuestCommunicatorDelegate.h"

typedef void (^MeetupDotComObjectNotationBlock)(NSDictionary *, SocialNetworkType);
typedef void (^MeetupDotComErrorBlock)(NSError *);

@interface MeetupDotComCommunicator : NSObject <NSURLConnectionDataDelegate> {
@protected
    NSString *fetchingURLPath;
//    NSString *fetchingURLMethod;
    NSDictionary *fetchingURLParameters;
    NSURLConnection *fetchingConnection;
//    NSMutableData *receivedData;
    
@private
    id <EventCommunicatorDelegate, GuestCommunicatorDelegate> __weak delegate;
    void (^errorHandler)(NSError *);
    void (^successHandler)(NSDictionary *, SocialNetworkType);
}


@property (weak) id <EventCommunicatorDelegate, GuestCommunicatorDelegate> delegate;

- (void)downloadUpcomingEventsForGroupName:(NSString *)groupUrlName
                              errorHandler:(MeetupDotComErrorBlock)errorBlock
                            successHandler:(MeetupDotComObjectNotationBlock)successBlock;

- (void)downloadGuestsForGroupName:(NSString *)groupUrlName
                      errorHandler:(MeetupDotComErrorBlock)errorBlock
                    successHandler:(MeetupDotComObjectNotationBlock)successBlock;


@end


extern NSString *MeetupDotComCommunicatorErrorDomain;
