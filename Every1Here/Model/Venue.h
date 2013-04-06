//
//  Venue.h
//  Anseo
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Address;

@interface Venue : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, retain)Address *address;
@property (nonatomic, copy)NSNumber *venueId;

- (id)initWithName:(NSString*)name address:(Address *)address;

- (id)initWithName:(NSString*)name address:(Address *)address venueId:(NSNumber *)venueId;

@end
