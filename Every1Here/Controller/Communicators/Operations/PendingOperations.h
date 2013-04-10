//
//  PendingOperations.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/25/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingOperations : NSObject

@property (nonatomic, strong) NSMutableDictionary *twitterApiOpsInProgress;
@property (nonatomic, strong) NSOperationQueue *twitterApiOpsQueue;

//@property (nonatomic, strong) NSMutableDictionary *facebookApiOpsInProgress;
//@property (nonatomic, strong) NSOperationQueue *facebookApiOpsQueue;

@property (nonatomic, strong) NSMutableDictionary *RESTApiOpsInProgress;
@property (nonatomic, strong) NSOperationQueue *RESTApiOpsQueue;

@end
