//
//  Every1HereObjectConfiguration.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ParseDotComManager;
@class MeetupDotComManager;
@class TwitterDotComManager;
@class AvatarStore;

@interface E1HObjectConfiguration : NSObject

/**
 * A fully configured ParseDotComManager instance.
 */
- (ParseDotComManager *)parseDotComManager;


/**
 * A fully configured ParseDotComManager instance.
 */
- (MeetupDotComManager *)meetupDotComManager;


/**
 * A fully configured ParseDotComManager instance.
 */
- (TwitterDotComManager *)twitterDotComManager;


/**
 * A fully configured AvatarStore instance.
 */
- (AvatarStore *)avatarStore;

@end
