//
//  E1HRESTApiOperationFetch.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/11/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "E1HRESTApiOperationFetch.h"
#import "RESTApiOperation.h"
#import "CommonUtilities.h"

@implementation E1HRESTApiOperationFetch

-(RESTApiOperation *)createOperationWithObj:(id)obj forNamedClass:(NSString *)aNamedClass withKey:(NSString *)aKey {
    
    return nil;
}

- (RESTApiOperation *)createOperationWithDict:(NSDictionary *)aDataDict forNamedClass:(NSString *)aNamedClass {
    
    return nil;
    
}

- (RESTApiOperation *)createOperationWithId:(NSString *)anId forNamedClass:(NSString *)aNamedClass {
    
    return nil;
    
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery {
    
    NSMutableDictionary *thisDataDict = [[NSMutableDictionary alloc] init];
    
    if (aQuery != nil) {
//        thisDataDict = @{@"where" : [CommonUtilities serializeRequestParmetersWithDictionary:aQuery]};
    [thisDataDict addEntriesFromDictionary:@{@"where" : [CommonUtilities serializeRequestParmetersWithDictionary:aQuery]}];
    }

    NSMutableString *thisUriEndPoint = [[CommonUtilities fetchUriEndPointFromPListForNamedClass:aNamedClass] mutableCopy];
    
    NSLog(@"%@", thisDataDict);
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"GET" uriPath:thisUriEndPoint data:thisDataDict];
    
    return newRESTApiOperation;
}


-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withOrder:(NSString*)orderFieldName {
    
    NSMutableDictionary *thisDataDict = [[NSMutableDictionary alloc] init];
    
    if (aQuery != nil) {
//        thisDataDict = [@{@"where" : [CommonUtilities serializeRequestParmetersWithDictionary:aQuery]} mutableCopy];
        [thisDataDict addEntriesFromDictionary:@{@"where" : [CommonUtilities serializeRequestParmetersWithDictionary:aQuery]}];
    }
    
    if (orderFieldName !=nil) {
        NSDictionary *orderDict = @{@"order":orderFieldName};
        
        [thisDataDict addEntriesFromDictionary:orderDict];
//        thisDataDict = [[CommonUtilities serializeRequestParmetersWithDictionary:orderDict] mutableCopy];
        
        
    }
    
    NSMutableString *thisUriEndPoint = [[CommonUtilities fetchUriEndPointFromPListForNamedClass:aNamedClass] mutableCopy];
    
    NSLog(@"%@", thisDataDict);
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"GET" uriPath:thisUriEndPoint data:thisDataDict];
    
    return newRESTApiOperation;
}


-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withIncludes:(NSArray *)includes {
    
    NSDictionary *thisDataDict = [[NSDictionary alloc] init];
    
    if (aQuery != nil) {
        thisDataDict = @{@"where" : [CommonUtilities serializeRequestParmetersWithDictionary:aQuery],
                         @"include": [includes componentsJoinedByString:@","]};
    }

//    NSDictionary *thisDataDict = @{@"include": @"groupdId"};
    
    NSMutableString *thisUriEndPoint = [[CommonUtilities fetchUriEndPointFromPListForNamedClass:aNamedClass] mutableCopy];
    
    NSLog(@"%@", thisDataDict);
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"GET" uriPath:thisUriEndPoint data:thisDataDict];
    
    return newRESTApiOperation;
    
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withKey:(NSString *)aKey
{
    return nil;
}

@end
