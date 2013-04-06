//
//  TestObjectConfiguration.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/14/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "TestObjectConfiguration.h"

@implementation TestObjectConfiguration

@synthesize objectToReturn;

- (ParseDotComManager *)parseDotComManager {
    return (ParseDotComManager *)self.objectToReturn;
}

- (MeetupDotComManager *)meetupDotComManager {
    return (MeetupDotComManager *)self.objectToReturn;
}

@end
