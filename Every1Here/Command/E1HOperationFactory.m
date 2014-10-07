//
//  E1HOperationFactory.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "E1HOperationFactory.h"
#import "E1HRESTApiOperationInsert.h"
#import "E1HRESTApiOperationUpdate.h"
#import "E1HRESTApiOperationFetch.h"
#import "E1HRESTApiOperationDelete.h"

@implementation E1HOperationFactory


+ (id<E1HRESTApiOperationFactory>) create: (ActionTypes) type {
    switch (type) {
        case Insert:
            return [[E1HRESTApiOperationInsert alloc] init];
        case Update:
            return [[E1HRESTApiOperationUpdate alloc] init];
        case Fetch:
            return [[E1HRESTApiOperationFetch alloc] init];
        case Delete:
            return [[E1HRESTApiOperationDelete alloc] init];
    }
}

@end
