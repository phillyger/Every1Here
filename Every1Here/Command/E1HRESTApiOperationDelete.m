//
//  E1HRESTApiOperationDelete.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/9/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "E1HRESTApiOperationDelete.h"
#import "RESTApiOperation.h"
#import "CommonUtilities.h"

@implementation E1HRESTApiOperationDelete


-(RESTApiOperation *)createOperationWithObj:(id)obj forNamedClass:(NSString *)aNamedClass withKey:(NSString *)aKey {
    
    NSDictionary *thisDataDict = [CommonUtilities generateValueDictWithObject:obj forNamedClass:aNamedClass];
    NSMutableString *thisUriEndPoint = [[CommonUtilities fetchUriEndPointFromPListForNamedClass:aNamedClass] mutableCopy];

    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:@"/"] copy];
    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:[obj valueForKeyPath:aKey]] copy];
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"DELETE" uriPath:thisUriEndPoint data:thisDataDict];
    
    return newRESTApiOperation;
}

- (RESTApiOperation *)createOperationWithDict:(NSDictionary *)aDataDict forNamedClass:(NSString *)aNamedClass {
    
    return nil;
    
}

- (RESTApiOperation *)createOperationWithId:(NSString *)anId forNamedClass:(NSString *)aNamedClass {
    
    
    NSMutableString *thisUriEndPoint = [[CommonUtilities fetchUriEndPointFromPListForNamedClass:aNamedClass] mutableCopy];
    
    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:@"/"] copy];
    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:anId] copy];
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"DELETE" uriPath:thisUriEndPoint data:nil];
    
    return newRESTApiOperation;
    
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery {
    return nil;
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withIncludes:(NSArray *)includes {
    return nil;
}

@end
