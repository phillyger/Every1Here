//
//  VenueTest.m
//  E1H
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "VenueTest.h"
#import "Venue.h"
#import "Address.h"

@implementation VenueTest


- (void)setUp
{
    address = [[Address alloc] init];
    venue = [[Venue alloc] initWithName:@"The Watermark at Logan Square" address:address];
    
}

- (void)tearDown
{
    venue = nil;
    address = nil;
    
}

@end
