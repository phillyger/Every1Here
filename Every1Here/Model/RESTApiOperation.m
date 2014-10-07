//
//  RESTApiPropertyList.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/5/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "RESTApiOperation.h"

@implementation RESTApiOperation
@synthesize uriMethod;
@synthesize uriPath;
@synthesize data;



- (id)initWithUriMethod:(NSString *)aUriMethod
                uriPath:(NSString *)aUriPath
                   data:(NSDictionary *)newData {
    if (self = [super init]) {
        uriPath = [aUriPath copy];
        uriMethod = [aUriMethod copy];
        data = [newData copy];
    }
    return self;

}


- (id)init {
    
    return [self initWithUriMethod:nil uriPath:nil data:nil];
}



@end
