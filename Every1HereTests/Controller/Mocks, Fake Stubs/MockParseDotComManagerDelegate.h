//
//  MockParseDotComManagerDelegate.h
//  E1H
//
//  Created by Ger O'Sullivan on 2/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventManagerDelegate.h"
#import "MemberManagerDelegate.h"

@class Event;

@interface MockParseDotComManagerDelegate : NSObject <EventManagerDelegate, MemberManagerDelegate>

@property (strong) NSError *fetchError;
@property (strong) NSArray *fetchedMembers;
@property (strong) NSArray *fetchedEvents;
@property (strong) Event *successEvent;

@end
