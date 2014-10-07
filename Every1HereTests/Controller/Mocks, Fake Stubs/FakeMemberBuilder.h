//
//  FakeMemberBuilder.h
//  E1H
//
//  Created by Ger O'Sullivan on 2/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberBuilder.h"

@class User;

@interface FakeMemberBuilder : MemberBuilder
@property (copy) NSDictionary *JSON;
@property (copy) NSArray *arrayToReturn;
@property (copy) NSError *errorToSet;
@property (strong) User *member;
@end
