//
//  Person.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize firstName, lastName;

// Overidden inherited Designated Initializer
- (id)init
{
    return [self initWithFirstName:nil lastName:nil];
}

// Designated Initializer
- (id)initWithFirstName:(NSString *)aFirstName
               lastName:(NSString *)aLastName
{
    if ((self = [super init])) {
        firstName = [aFirstName copy];
        lastName = [aLastName copy];
        aFirstName = nil;
        aLastName = nil;
       
    }
    return self;
}

@end
