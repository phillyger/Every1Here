//
//  EventRoleReceptionist.h
//  Anseo
//
//  Created by Ger O'Sullivan on 4/1/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EventRoleTaskBlock)(NSString *keyPath, id object, NSDictionary *change);


@interface EventRoleReceptionist : NSObject
{
    id observedObject;
    NSString *observedKeyPath;
    EventRoleTaskBlock task;
    NSOperationQueue *queue;
}

+ (id)receptionistForKeyPath:(NSString *)path
                      object:(id)obj
                       queue:(NSOperationQueue *)queue
                        task:(EventRoleTaskBlock)task;

@end
