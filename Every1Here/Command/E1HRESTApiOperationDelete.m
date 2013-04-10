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


-(RESTApiOperation *)createOperationWithObj:(id)obj forClassName:(NSString *)aClassName withKey:(NSString *)aKey {
    
    return nil;
}

- (RESTApiOperation *)createOperationWithDict:(NSDictionary *)aDataDict forClassName:(NSString *)aClassName {
    
    return nil;
    
}

- (RESTApiOperation *)createOperationWithId:(NSString *)anId forClassName:(NSString *)aClassName {
    
    
    NSMutableString *thisUriEndPoint = [[CommonUtilities fetchUriEndPointFromPListForClassName:aClassName] mutableCopy];
    
    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:@"/"] copy];
    thisUriEndPoint = [[thisUriEndPoint stringByAppendingString:anId] copy];
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"DELETE" uriPath:thisUriEndPoint data:nil];
    
    return newRESTApiOperation;
    
}

@end
