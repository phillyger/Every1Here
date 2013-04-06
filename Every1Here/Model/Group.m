//
//  Group.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "Group.h"

@implementation Group
@synthesize name, urlName, groupId, objectId;

// Designated Initializer
- (id)initWithName:(NSString *)aName
           urlName:(NSString *)aUrlName
           groupId:(NSNumber *)aGroupId
{

    if ((self = [super init])) {
        name = [aName copy];
        urlName = [aUrlName copy];
        groupId = [aGroupId copy];
//        objectId = [anObjectId copy];
//        aName = nil;
//        aGroupId = nil;
//        aUrlName = nil;
//        anObjectId = nil;
    }
    return self;

}

- (id)initWithName:(NSString *)aName urlName:(NSString *)aUrlName
{
    return [self initWithName:aName urlName:aUrlName groupId:nil];
}

- (id)initWithName:(NSString *)aName
{
    return [self initWithName:aName urlName:nil];
}

// Overidden inherited Designated Initializer
- (id)init
{
    return [self initWithName:nil];
}




@end
