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

    NSString *firstName = [memberValues valueForKey:@"firstName"];
    NSString *lastName = [memberValues valueForKey: @"lastName"];
    NSString *objectId = [memberValues valueForKey:@"objectId"];
    NSString *userId = [memberValues valueForKey:@"userId"];
    
//    if ([memberValues valueForKey:@"userId"]!=nil) {
//        userId = [memberValues valueForKey:@"userId"];
//    }
    NSString *primaryEmail = [memberValues valueForKey:@"primaryEmail"];
    NSString *eventId = [memberValues valueForKey:@"eventId"];
    NSString *avatarLocation = [memberValues valueForKey:@"avatarLocation"];
    
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
                                  avatarLocation:avatarLocation
                                        objectId:objectId
                                          userId:userId
                                        eventId:eventId
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
    NSString *eventId = guestValues[@"eventId"];
    User *user = [[User alloc] initWithDisplayName:displayName avatarLocation:avatarURL eventId:eventId slType:aSlType];
    return user;
}


+ (User *)guestFromMeetupDictionary:(NSDictionary *)guestValues socialNetworkType:(SocialNetworkType)aSlType {
    NSString *displayName = [guestValues objectForKey: @"name"];
    NSString *avatarURL = guestValues[@"photo"][@"thumb_link"];
    NSString *eventId = guestValues[@"eventId"];
    User *user = [[User alloc] initWithDisplayName:displayName avatarLocation:avatarURL eventId:eventId slType:aSlType];
    return user;
}


@end
