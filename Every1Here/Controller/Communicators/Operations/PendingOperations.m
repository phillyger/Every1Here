//
//  PendingOperations.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/25/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "PendingOperations.h"

@implementation PendingOperations

@synthesize twitterApiOpsInProgress = _twitterApiOpsInProgress;
@synthesize twitterApiOpsQueue = _twitterApiOpsQueue;


- (NSMutableDictionary *)twitterApiOpsInProgress {
    if (!_twitterApiOpsInProgress) {
        _twitterApiOpsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _twitterApiOpsInProgress;
}

- (NSOperationQueue *)twitterApiOpsQueue {
    if (!_twitterApiOpsQueue) {
        _twitterApiOpsQueue = [[NSOperationQueue alloc] init];
        _twitterApiOpsQueue.name = @"Twitter API Queue";
        _twitterApiOpsQueue.maxConcurrentOperationCount = 1;
    }
    return _twitterApiOpsQueue;
}

@end
