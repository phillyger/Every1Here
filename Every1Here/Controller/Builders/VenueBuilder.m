//
//  VenueBuilder.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "VenueBuilder.h"
#import "Venue.h"
#import "Address.h"
#import "Event.h"

@implementation VenueBuilder


+ (Venue *) venueFromDictionary: (NSDictionary *) venueValues  {
    
    NSString *name = venueValues[@"name"];
    
    NSString *address_1 = venueValues[@"address_1"];
    NSString *city = venueValues[@"city"];
    NSString *state = venueValues[@"state"];
    NSString *zip = venueValues[@"zip"];
    NSString *country = venueValues[@"country"];
    NSNumber *venueId = [NSNumber numberWithInteger:[venueValues[@"id"] integerValue]];
    
    NSNumber *lat = [NSNumber numberWithDouble:
                     [venueValues[@"lat"] doubleValue]];
    
    NSNumber *lon = [NSNumber numberWithDouble:
                     [venueValues[@"lon"] doubleValue]];
    
    Address *address = [[Address alloc] initWithAddress:address_1 city:city state:state zip:zip country:country lat:lat lon:lon];
    Venue *venue = [[Venue alloc] initWithName: name address:address venueId:venueId];

    
    return venue;
}
@end
