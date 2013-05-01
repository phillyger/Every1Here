//
//  FakeURLResponse.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/7/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "FakeURLResponse.h"

@implementation FakeURLResponse
- (id)initWithStatusCode:(NSInteger)code {
    if ((self = [super init])) {
        statusCode = code;
    }
    return self;
}

- (NSInteger)statusCode {
    return statusCode;
}
@end
