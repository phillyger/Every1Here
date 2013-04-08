//
//  DisplayNameReceptionist.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/1/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DisplayNameTaskBlock)(NSString *keyPath, id object, NSDictionary *change);


@interface DisplayNameReceptionist : NSObject
{
    id observedObject;
    NSString *observedKeyPath;
    DisplayNameTaskBlock task;
    NSOperationQueue *queue;
}

+ (id)receptionistForKeyPath:(NSString *)path
                      object:(id)obj
                       queue:(NSOperationQueue *)queue
                        task:(DisplayNameTaskBlock)task;

@end
