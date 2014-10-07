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
@synthesize RESTApiOpsInProgress = _RESTApiOpsInProgress;
@synthesize RESTApiOpsQueue = _RESTApiOpsQueue;

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

- (NSMutableDictionary *)RESTApiOpsInProgress {
    if (!_RESTApiOpsInProgress) {
        _RESTApiOpsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _RESTApiOpsInProgress;
}

- (NSOperationQueue *)RESTApiOpsQueue {
    if (!_RESTApiOpsQueue) {
        _RESTApiOpsQueue = [[NSOperationQueue alloc] init];
        _RESTApiOpsQueue.name = @"REST API Queue";
        _RESTApiOpsQueue.maxConcurrentOperationCount = 1;
    }
    return _RESTApiOpsQueue;
}

@end
