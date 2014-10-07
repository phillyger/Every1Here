//
//  EIHRESTApiInsertOperation.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/5/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "E1HRESTApiOperationInsert.h"
#import "RESTApiOperation.h"
#import "CommonUtilities.h"


@implementation E1HRESTApiOperationInsert


-(RESTApiOperation *)createOperationWithObj:(id)obj forNamedClass:(NSString *)aNamedClass withKey:(NSString *)aKey {

    
    NSDictionary *thisDataDict = [CommonUtilities generateValueDictWithObject:obj forNamedClass:aNamedClass];
    NSString *thisUriEndPoint = [CommonUtilities fetchUriEndPointFromPListForNamedClass:aNamedClass];
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"POST" uriPath:thisUriEndPoint data:thisDataDict];

    return newRESTApiOperation;
    
}

- (RESTApiOperation *)createOperationWithDict:(NSDictionary *)aDataDict forNamedClass:(NSString *)aNamedClass {
    
    NSString *thisUriEndPoint = [CommonUtilities fetchUriEndPointFromPListForNamedClass:aNamedClass];
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"POST" uriPath:thisUriEndPoint data:aDataDict];
    
    return newRESTApiOperation;
    
}

- (RESTApiOperation *)createOperationWithId:(NSString *)anId forNamedClass:(NSString *)aNamedClass {
    return nil;
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery {
    return nil;
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withIncludes:(NSArray *)includes {
    return nil;
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withOrder:(NSString*)orderFieldName
{
    return nil;
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withKey:(NSString *)aKey
{
    return nil;
}

@end
