//
//  UserBuilder.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuestCommunicatorDelegate.h"
#import "User.h"


/**
 * Construct User objects from an external representation.
 * @note The format of the JSON is driven by the Meetup 2.0 API.
 * @see Event
 */

@interface UserBuilder : NSObject {
}
    
/**
* Given a dictionary that describes a person on Stack Overflow, create
* a Person object with the supplied properties.
*/
+ (User *) userFromDictionary:(NSDictionary *) userValues forUserType:(UserTypes)userType;

/**
 * Given a dictionary that describes a person on Stack Overflow, create
 * a Person object with the supplied properties.
 */
+ (User *) userFromDictionary:(NSDictionary *)guestValues socialNetworkType:(SocialNetworkType)slType forUserType:(UserTypes)userType;

@end
