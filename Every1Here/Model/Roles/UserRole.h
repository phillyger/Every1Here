//
//  UserRole.h
//  Anseo
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoleDelegate.h"
#import "EffectiveDateRange.h"

@class User;

@interface UserRole : NSObject <RoleDelegate>
{
    //id <RoleDelegate> delegate;
    User *user;
    EffectiveDateRange *effective;
}

- (id)initWithUser:(User *)aUser effective:(EffectiveDateRange *)anEffectiveDateRange;
- (id)initWithUser:(User *)aUser;

- (EffectiveDateRange *)effective;

@end
