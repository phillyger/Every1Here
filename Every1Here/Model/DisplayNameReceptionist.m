//
//  DisplayNameReceptionist.m
//  Anseo
//
//  Created by Ger O'Sullivan on 4/1/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "DisplayNameReceptionist.h"

@implementation DisplayNameReceptionist

+ (id)receptionistForKeyPath:(NSString *)path object:(id)obj queue:(NSOperationQueue *)queue task:(DisplayNameTaskBlock)task {
    DisplayNameReceptionist *receptionist = [DisplayNameReceptionist new];
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
