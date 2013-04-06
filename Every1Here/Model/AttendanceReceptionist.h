//
//  AttendanceReceptionist.h
//  Anseo
//
//  Created by Ger O'Sullivan on 3/31/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AttendanceTaskBlock)(NSString *keyPath, id object, NSDictionary *change);

@interface AttendanceReceptionist : NSObject
{
    id observedObject;
    NSString *observedKeyPath;
    AttendanceTaskBlock task;
    NSOperationQueue *queue;
}

+ (id)receptionistForKeyPath:(NSString *)path
                      object:(id)obj
                       queue:(NSOperationQueue *)queue
                        task:(AttendanceTaskBlock)task;

@end
