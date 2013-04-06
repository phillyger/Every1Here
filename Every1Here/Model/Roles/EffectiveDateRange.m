//
//  EffectiveDateRange.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/25/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EffectiveDateRange.h"

@implementation EffectiveDateRange
@synthesize start, end;

// Designated Initializer
- (id)initWithStartDate:(NSDate *)aStartDate endDate:(NSDate *)anEndDate
{
    if (self = [super init]) {
        start = [aStartDate copy];
        end = [aStartDate copy];
        aStartDate = nil;
        anEndDate = nil;
    }
    return  self;

}

// Overridden inherited Designated Initializer
- (id)init
{
    return [self initWithStartDate:nil endDate:nil];
}

@end
