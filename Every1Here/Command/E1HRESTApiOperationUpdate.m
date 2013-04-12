//
//  E1HRESTApiOperationUpdate.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/9/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "E1HRESTApiOperationUpdate.h"
#import "RESTApiOperation.h"
#import "CommonUtilities.h"

@implementation E1HRESTApiOperationUpdate


-(RESTApiOperation *)createOperationWithObj:(id)obj forNamedClass:(NSString *)aNamedClass withKey:(NSString *)aKey {
    
    NSDictionary *thisDataDict = [CommonUtilities generateValueDictWithObject:obj forNamedClass:aNamedClass];
    NSMutableString *thisUriEndPoint = [[CommonUtilities fetchUriEndPointFromPListForNamedClass:aNamedClass] mutableCopy];
    
    
    
    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:@"/"] copy];
    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:[obj valueForKeyPath:aKey]] copy];
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"PUT" uriPath:thisUriEndPoint data:thisDataDict];
    
    return newRESTApiOperation;
}

- (RESTApiOperation *)createOperationWithDict:(NSDictionary *)aDataDict forNamedClass:(NSString *)aNamedClass {
    
    return nil;
    
}

- (RESTApiOperation *)createOperationWithId:(NSString *)anId forNamedClass:(NSString *)aNamedClass {
    
    return nil;
    
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery {
    return nil;
}

@end
