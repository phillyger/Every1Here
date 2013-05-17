//
//  GroupBuilder.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GroupBuilder.h"
#import "Group.h"

@implementation GroupBuilder

+ (Group *)groupFromDictionary:(NSDictionary *)groupValues
{
    NSString *name = groupValues[@"name"];
    NSString *urlName = groupValues[@"groupUrlName"];
    NSString *objectId = groupValues[@"objectId"];
NSNumber *groupId = [NSNumber numberWithDouble:[groupValues[@"groupId"] doubleValue]];
    
    Group *group = [[Group alloc] initWithName:name urlName:urlName groupId:groupId objectId:objectId];
    
    return group;
}

+ (NSArray *)groupsFromJSON:(NSDictionary *)objectNotation error: (NSError **)error;
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
            *error = [NSError errorWithDomain:GroupBuilderErrorDomain code: GroupBuilderInvalidJSONError userInfo: userInfo];
        }
        return nil;
    }
    NSArray *groups = [parsedObject objectForKey: @"results"];
    if (groups == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:GroupBuilderErrorDomain code: GroupBuilderMissingDataError userInfo:nil];
        }
        return nil;
    }
    NSMutableArray *results = [NSMutableArray arrayWithCapacity: [groups count]];
    for (NSDictionary *parsedGroup in groups) {
        Group *thisGroup = [[Group alloc] init];
        thisGroup.groupId = parsedGroup[@"id"];
        thisGroup.name = parsedGroup[@"name"];
        thisGroup.urlName = parsedGroup[@"urlname"];
        thisGroup.objectId = parsedGroup[@"objectId"];  //parse.com primary id.

        
        [results addObject: thisGroup];
    }
    return [results copy];
}



@end


NSString *GroupBuilderErrorDomain = @"GroupBuilderErrorDomain";
