//
//  UserBuilderTests.h
//  E1H
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
@class MemberBuilder;
@class GuestBuilder;
@class User;

@interface UserBuilderTests : SenTestCase
{
    MemberBuilder *memberBuilder;
    GuestBuilder *guestBuilder;
    User *userMember;
    User *userGuest;
}
@end
