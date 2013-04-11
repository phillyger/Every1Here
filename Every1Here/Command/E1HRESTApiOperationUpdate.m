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


-(RESTApiOperation *)createOperationWithObj:(id)obj forClassName:(NSString *)aClassName withKey:(NSString *)aKey {
    
    NSDictionary *thisDataDict = [CommonUtilities generateValueDictWithObject:obj forClassName:aClassName];
    NSMutableString *thisUriEndPoint = [[CommonUtilities fetchUriEndPointFromPListForClassName:aClassName] mutableCopy];
    
    
    
    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:@"/"] copy];
    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:[obj valueForKeyPath:aKey]] copy];
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"PUT" uriPath:thisUriEndPoint data:thisDataDict];
    
    return newRESTApiOperation;
}

- (RESTApiOperation *)createOperationWithDict:(NSDictionary *)aDataDict forClassName:(NSString *)aClassName {
    
    return nil;
    
}

- (RESTApiOperation *)createOperationWithId:(NSString *)anId forClassName:(NSString *)aClassName {
    
    return nil;
    
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forClassName:(NSString *)aClassName withQuery:(NSDictionary *)aQuery {
    return nil;
}

@end
