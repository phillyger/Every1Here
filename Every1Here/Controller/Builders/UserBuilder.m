//
//  UserBuilder.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "UserBuilder.h"
#import "User.h"
#import "GuestCommunicatorDelegate.h"

@implementation UserBuilder


/*
 *  Data coming from PARSE.com via RESTful API
 */
+ (User *)memberFromDictionary:(NSDictionary *)memberValues {
    NSString *userId;
    NSString *firstName = [memberValues objectForKey: @"firstName"];
    NSString *lastName = [memberValues objectForKey: @"lastName"];
    NSString *objectId = [memberValues objectForKey:@"objectId"];
    if ([memberValues objectForKey:@"userId"]!=nil) {
        userId = [memberValues objectForKey:@"userId"];
    }
    NSString *primaryEmail = [memberValues objectForKey:@"primaryEmail"];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
//    NSDictionary *memberSinceDict = [memberValues objectForKey:@"memberSince"];
//    NSString *memberSinceString = [memberSinceDict objectForKeyedSubscript:@"iso"];
//    NSDate *memberSince = [dateFormatter dateFromString:memberSinceString];

//    NSString *avatarURL = [NSString stringWithFormat: @"http://www.gravatar.com/avatar/%@", [ownerValues objectForKey: @"email_hash"]];

    User *user = [[User alloc] initWithFirstName:firstName
                                        lastName:lastName
                                primaryEmailAddr:primaryEmail
                              secondaryEmailAddr:nil
                                  avatarLocation:nil
                                        objectId:objectId
                                          userId:userId
                                          slType:NONE];
    return user;
}

/*
 *  Data coming from variety of different Services - Meetup.com/LinkedIn/FB/Twitter
 */

//+ (User *)guestFromDictionary:(NSDictionary *)guestValues {
//    NSString *displayName = [guestValues objectForKey: @"name"];
//    NSString *avatarURL = guestValues[@"photo"][@"thumb_link"];
//    User *user = [[User alloc] initWithDisplayName:displayName avatarLocation:avatarURL];
//    return user;
//}

+ (User *)guestFromDictionary:(NSDictionary *)guestValues socialNetworkType:(SocialNetworkType)aSlType {

    User *user = nil;
    
    switch (aSlType) {
        case Meetup:
            user = [self guestFromMeetupDictionary:guestValues socialNetworkType:(SocialNetworkType)aSlType];
            break;
        case Twitter:
            user = [self guestFromTwitterDictionary:guestValues socialNetworkType:(SocialNetworkType)aSlType];
            break;
        default:
            break;
    }
    return user;
}



+ (User *)guestFromTwitterDictionary:(NSDictionary *)guestValues socialNetworkType:(SocialNetworkType)aSlType {
    NSString *displayName = [guestValues objectForKey: @"name"];
    NSString *avatarURL = guestValues[@"profile_background_image_url"];
    User *user = [[User alloc] initWithDisplayName:displayName avatarLocation:avatarURL slType:aSlType];
    return user;
}


+ (User *)guestFromMeetupDictionary:(NSDictionary *)guestValues socialNetworkType:(SocialNetworkType)aSlType {
    NSString *displayName = [guestValues objectForKey: @"name"];
    NSString *avatarURL = guestValues[@"photo"][@"thumb_link"];
    User *user = [[User alloc] initWithDisplayName:displayName avatarLocation:avatarURL slType:aSlType];
    return user;
}


@end
