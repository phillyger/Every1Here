//
//  EventRoleReceptionist.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/1/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventRoleReceptionist.h"

@implementation EventRoleReceptionist

+ (id)receptionistForKeyPath:(NSString *)path object:(id)obj queue:(NSOperationQueue *)queue task:(EventRoleTaskBlock)task {
    EventRoleReceptionist *receptionist = [EventRoleReceptionist new];
    receptionist->task = [task copy];
    receptionist->observedKeyPath = [path copy];
    receptionist->observedObject = obj;
    receptionist->queue = queue;
    [obj addObserver:receptionist forKeyPath:path
             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:0];
    return receptionist;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
 //   
    [queue addOperationWithBlock:^{
//    [queue waitUntilAllOperationsAreFinished];
        task(keyPath, object, change);
    }];
}

@end
