//
//  Receptionist.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/9/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ReceptionistTaskBlock)(NSString *keyPath, id object, NSDictionary *change);

@interface Receptionist : NSObject

{
    id observedObject;
    NSString *observedKeyPath;
    ReceptionistTaskBlock task;
    NSOperationQueue *queue;
}

+ (id)receptionistForKeyPath:(NSString *)path
                      object:(id)obj
                       queue:(NSOperationQueue *)queue
                        task:(ReceptionistTaskBlock)task;

@end
