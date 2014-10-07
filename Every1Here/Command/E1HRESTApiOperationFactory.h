//
//  E1HRESTApiOperationFactory.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/5/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RESTApiOperation;

@protocol E1HRESTApiOperationFactory <NSObject>

-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withKey:(NSString *)aKey;
-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withKey:(NSString *)aKey;

-(RESTApiOperation *)createOperationWithDict:(NSDictionary *)aDict forNamedClass:(NSString *)aNamedClass;
-(RESTApiOperation *)createOperationWithId:(NSString *)anId forNamedClass:(NSString *)aNamedClass;
-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery;
-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withIncludes:(NSArray *)includes;
-(RESTApiOperation *)createOperationWithObj:(id)anObject forNamedClass:(NSString *)aNamedClass withQuery:(NSDictionary *)aQuery withOrder:(NSString*)orderFieldName;

@end
