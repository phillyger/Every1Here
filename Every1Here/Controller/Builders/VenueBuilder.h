//
//  VenueBuilder.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Venue;

/**
 * Construct Person instances from dictionaries describing them.
 * @see Venue
 */

@interface VenueBuilder : NSObject

/**
 * Given a dictionary that describes a person on Stack Overflow, create
 * a Person object with the supplied properties.
 */
+ (Venue *) venueFromDictionary: (NSDictionary *) venueValues;



@end

