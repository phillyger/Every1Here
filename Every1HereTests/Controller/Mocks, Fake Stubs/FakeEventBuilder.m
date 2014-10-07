//
//  FakeEventBuilder.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "FakeEventBuilder.h"

@implementation FakeEventBuilder
@synthesize JSON;
@synthesize arrayToReturn;
@synthesize errorToSet;
@synthesize event;

- (NSArray *)eventsFromJSON:(NSDictionary *)objectNotation error:(NSError *__autoreleasing *)error {
    self.JSON = objectNotation;
    if (error) {
        *error = errorToSet;
    }
    return arrayToReturn;
}
@end
