//
//  GuestBuilder.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/25/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestBuilder.h"
#import "User.h"
#import "UserBuilder.h"

@implementation GuestBuilder

- (NSArray *)guestsFromJSON:(NSDictionary *)objectNotation socialNetworkType:(SocialNetworkType)slType error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(objectNotation != nil);
//    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
    NSError *localError = nil;
//    id jsonObject = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0 error: &localError];
    NSDictionary *parsedObject = (id)objectNotation;
    if (parsedObject == nil) {
        if (error != NULL) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
            if (localError != nil) {
                [userInfo setObject: localError forKey: NSUnderlyingErrorKey];
            }
            *error = [NSError errorWithDomain:GuestBuilderErrorDomain code: GuestBuilderInvalidJSONError userInfo: userInfo];
        }
        return nil;
    }
    
    NSArray *guests = nil;
    switch (slType) {
        case Meetup:
            guests = [self guestsFromMeetupJSON:parsedObject error:error];
            break;
        case Twitter:
            guests = [self guestsFromTwitterJSON:parsedObject error:error];
        default:
            break;
    }
    
//    NSArray *guests = [parsedObject objectForKey: @"results"];
    
    
    if (guests == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:GuestBuilderErrorDomain code: GuestBuilderMissingDataError userInfo:nil];
        }
        return nil;
    }
    
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity: [guests count]];
    for (NSDictionary *guest in guests) {
        User *user = [[User alloc] init];
        user = [UserBuilder guestFromDictionary:guest socialNetworkType:slType];
        
        [user addRole:@"GuestRole"];
        
        [results addObject: user];
    }
    return [results copy];
    
}

- (NSArray *)guestsFromMeetupJSON:(NSDictionary *)parsedObject error:(NSError *__autoreleasing *)error
{
    return (NSArray *)[parsedObject objectForKey: @"results"];
}

- (NSArray *)guestsFromTwitterJSON:(NSDictionary *)parsedObject error:(NSError *__autoreleasing *)error
{
    return (NSArray *)[parsedObject objectForKey: @"users"];
}


@end

NSString *GuestBuilderErrorDomain = @"GuestBuilderErrorDomain";