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
+ (User *)userFromDictionary:(NSDictionary *)userValues forUserType:(UserTypes)userType {

    User *user = nil;
    
    NSString *firstName = [userValues valueForKeyPath:@"firstName"];
    NSString *lastName = [userValues valueForKeyPath: @"lastName"];
    NSString *objectId = [userValues valueForKeyPath:@"objectId"];
    
    //-------------------------------------------------------
    // userId column is a pointer data type in Parse.
    // "userId": [
    //            {
    //                "__type": "Pointer",
    //                "className": "_User",
    //                "objectId": "Ed1nuqPvc"
    //            }
    //-------------------------------------------------------
    NSString *userId = [userValues valueForKeyPath:@"userId.objectId"];
    NSString *displayName = [userValues valueForKeyPath:@"displayName"];
    

    NSString *primaryEmail = [userValues valueForKeyPath:@"primaryEmail"];
    NSString *eventId = [userValues valueForKeyPath:@"eventId"];
    NSString *avatarLocation = [userValues valueForKeyPath:@"avatarURL"];

    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
//    NSDictionary *memberSinceDict = [memberValues objectForKey:@"memberSince"];
//    NSString *memberSinceString = [memberSinceDict objectForKeyedSubscript:@"iso"];
//    NSDate *memberSince = [dateFormatter dateFromString:memberSinceString];

//    NSString *avatarURL = [NSString stringWithFormat: @"http://www.gravatar.com/avatar/%@", [ownerValues objectForKey: @"email_hash"]];

    if (userType == Member) {

       user = [[User alloc] initWithFirstName:firstName
                                            lastName:lastName
                                    primaryEmailAddr:primaryEmail
                                  secondaryEmailAddr:nil
                                      avatarLocation:avatarLocation
                                            objectId:objectId
                                              userId:userId
                                            eventId:eventId
                                              slType:NONE];
        
    } else {
        
        NSNumber *slTypeNumObj = [userValues valueForKey:@"socialNetwork"];
        NSUInteger slTypeUInteger = [slTypeNumObj unsignedIntegerValue];
        SocialNetworkType slType = [SocialNetworkUtilities formatIntegerToType:slTypeUInteger];
        
        // set the value of userId to that on objectId for the purpose of tracking transient attendance such as Guests
        // There shouldn't be a need to add a User object for transient objects.
        userId = [objectId copy];
        
        user = [[User alloc] initWithDisplayName:displayName
                                 avatarLocation:avatarLocation
                                       objectId:objectId
                                         userId:userId
                                        eventId:eventId
                                         slType:slType];
    }
    
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

+ (User *)userFromDictionary:(NSDictionary *)guestValues socialNetworkType:(SocialNetworkType)aSlType forUserType:(UserTypes)userType {

    User *user = nil;
    
    switch (aSlType) {
        case NONE:
            user = (User*)[self userFromDictionary:guestValues forUserType:Guest];
            break;
        case Meetup:
            user = [self guestFromMeetupDotCom:guestValues];
            break;
        case Twitter:
            user = [self guestFromTwitterDotCom:guestValues];
            break;

        default:
            break;
    }
    return user;
}





+ (User *)guestFromTwitterDotCom:(NSDictionary *)guestValues {
    NSString *displayName = [guestValues valueForKeyPath: @"name"];
    NSString *avatarURL = [guestValues valueForKeyPath:@"profile_background_image_url"];
    NSString *eventId = [guestValues valueForKeyPath:@"eventId"];
    User *user = [[User alloc] initWithDisplayName:displayName avatarLocation:avatarURL objectId:nil userId:nil eventId:eventId slType:Twitter];
    return user;
}


+ (User *)guestFromMeetupDotCom:(NSDictionary *)guestValues {
    NSString *displayName = [guestValues valueForKeyPath: @"name"];
    NSString *avatarURL = [guestValues valueForKeyPath:@"photo.thumb_link"];
    NSString *eventId = [guestValues valueForKeyPath:@"eventId"];
    User *user = [[User alloc] initWithDisplayName:displayName avatarLocation:avatarURL objectId:nil userId:nil eventId:eventId slType:Meetup];
    return user;
}


@end
