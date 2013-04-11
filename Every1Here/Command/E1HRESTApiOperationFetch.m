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

-(RESTApiOperation *)createOperationWithObj:(id)obj forClassName:(NSString *)aClassName withKey:(NSString *)aKey {
    
    return nil;
}

- (RESTApiOperation *)createOperationWithDict:(NSDictionary *)aDataDict forClassName:(NSString *)aClassName {
    
    return nil;
    
}

- (RESTApiOperation *)createOperationWithId:(NSString *)anId forClassName:(NSString *)aClassName {
    
    return nil;
    
}

-(RESTApiOperation *)createOperationWithObj:(id)anObject forClassName:(NSString *)aClassName withQuery:(NSDictionary *)aQuery {
    
    NSDictionary *thisDataDict = @{@"where" : [CommonUtilities serializeRequestParmetersWithDictionary:aQuery]};
    NSMutableString *thisUriEndPoint = [[CommonUtilities fetchUriEndPointFromPListForClassName:aClassName] mutableCopy];
    
    NSLog(@"%@", thisDataDict);
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"GET" uriPath:thisUriEndPoint data:thisDataDict];
    
    return newRESTApiOperation;
}

@end
