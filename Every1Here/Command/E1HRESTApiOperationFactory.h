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

-(RESTApiOperation *)createOperationWithObj:(id)obj forClassName:(NSString *)className;

@end
