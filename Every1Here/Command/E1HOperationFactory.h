//
//  E1HOperationFactory.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E1HRESTApiOperationFactory.h"


typedef NS_ENUM(NSUInteger, ActionTypes)  {
    Insert,
    Update,
    Fetch,
    Delete
};


@interface E1HOperationFactory : NSObject

+ (id<E1HRESTApiOperationFactory>) create: (ActionTypes) type;

@end
