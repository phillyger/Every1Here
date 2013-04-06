//
//  Venue.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "Venue.h"
#import "Address.h"

@implementation Venue
@synthesize name, address, venueId;

// Designated Initializer
- (id)initWithName:(NSString *)aName address:(Address *)anAddress venueId:(NSNumber *)aVenueId
{

    if (self = [super init]) {
        name = [aName copy];
        address = anAddress;
        venueId = [aVenueId copy];
        aName = nil;
        anAddress = nil;
        aVenueId = nil;
    }
    
    return self;

}

- (id)initWithName:(NSString *)aName address:(Address *)anAddress
{
    
    return [self initWithName:aName address:anAddress venueId:nil];
    
}

- (id)init
{
    return [self initWithName:nil address:nil venueId:nil];
}


@end
