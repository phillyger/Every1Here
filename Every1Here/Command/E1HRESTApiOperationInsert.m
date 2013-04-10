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


-(RESTApiOperation *)createOperationWithObj:(id)obj forClassName:(NSString *)aClassName withKey:(NSString *)aKey {

    
    NSDictionary *thisDataDict = [CommonUtilities generateValueDictWithObject:obj forClassName:aClassName];
    NSString *thisUriEndPoint = [CommonUtilities fetchUriEndPointFromPListForClassName:aClassName];
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"POST" uriPath:thisUriEndPoint data:thisDataDict];

    return newRESTApiOperation;
    
}

- (RESTApiOperation *)createOperationWithDict:(NSDictionary *)aDataDict forClassName:(NSString *)aClassName {
    
    NSString *thisUriEndPoint = [CommonUtilities fetchUriEndPointFromPListForClassName:aClassName];
    
    RESTApiOperation *newRESTApiOperation = [[RESTApiOperation alloc] initWithUriMethod:@"POST" uriPath:thisUriEndPoint data:aDataDict];
    
    return newRESTApiOperation;
    
}

- (RESTApiOperation *)createOperationWithId:(NSString *)anId forClassName:(NSString *)aClassName {
    return nil;
}





@end
