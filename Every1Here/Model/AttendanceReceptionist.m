//
//  AttendanceReceptionist.m
//  Anseo
//
//  Created by Ger O'Sullivan on 3/31/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AttendanceReceptionist.h"

@implementation AttendanceReceptionist

+ (id)receptionistForKeyPath:(NSString *)path object:(id)obj queue:(NSOperationQueue *)queue task:(AttendanceTaskBlock)task {
    AttendanceReceptionist *receptionist = [AttendanceReceptionist new];
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
    [queue addOperationWithBlock:^{
        task(keyPath, object, change);
         
    }];

}

@end
