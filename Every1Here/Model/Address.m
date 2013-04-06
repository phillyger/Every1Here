//
//  Addresss.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/28/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "Address.h"



@implementation Address
@synthesize address1, city, state, zip, country, lat, lon;


// Designated Initializer
- (id)initWithAddress:(NSString*)anAddress
                 city:(NSString*)aCity
                state:(NSString*)aState
                  zip:(NSString*)aZip
              country:(NSString*)aCountry
                  lat:(NSNumber *)aLat
                  lon:(NSNumber *)aLon
{
    if (self = [super init]) {
        address1 = [anAddress copy];
        city = [aCity copy];
        state = [aState copy];
        zip = [aZip copy];
        country = [aCountry copy];
        lat = [aLat copy];
        lon = [aLon copy];

        anAddress = aCity = aState = aZip = aCountry = nil;
        aLat = aLon = nil;
     }
    return self;
}

// Overriding inherited Designated Initializer
- (id)init
{
    return [self initWithAddress:@"123 Washington St"
                            city:@"Philadelphia"
                           state:@"PA"
                             zip:@"19146"
                         country:@"us"
                             lat:@0.0
                             lon:@0.0];
}



@end
