//
//  AvatorStore.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/3/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AvatarStore.h"

@implementation AvatarStore


- (id)init {
    self = [super init];
    if (self) {
        dataCache = [[NSMutableDictionary alloc] init];
        communicators = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (NSData *)dataForURL:(NSURL *)url {
    if (url == nil) {
        return nil;
    }
    NSData *avatarData = [dataCache objectForKey: [url absoluteString]];
    if (!avatarData) {
//        GravatarCommunicator *communicator = [[GravatarCommunicator alloc] init];
//        [communicators setObject: communicator forKey: [url absoluteString]];
//        communicator.delegate = self;
//        [communicator fetchDataForURL: url];
    }
    return avatarData;
}

- (void)didReceiveMemoryWarning: (NSNotification *)note {
    [dataCache removeAllObjects];
}

- (void)useNotificationCenter:(NSNotificationCenter *)center {
    [center addObserver: self selector: @selector(didReceiveMemoryWarning:) name: UIApplicationDidReceiveMemoryWarningNotification object: nil];
    notificationCenter = center;
}

- (void)stopUsingNotificationCenter:(NSNotificationCenter *)center {
    [center removeObserver: self];
    notificationCenter = nil;
}

- (void)communicatorGotErrorForURL:(NSURL *)url {
    [communicators removeObjectForKey: [url absoluteString]];
}

- (void)communicatorReceivedData:(NSData *)data forURL:(NSURL *)url {
    [dataCache setObject: data forKey: [url absoluteString]];
    [communicators removeObjectForKey: [url absoluteString]];
    NSNotification *note = [NSNotification notificationWithName: AvatarStoreDidUpdateContentNotification object: self];
    [notificationCenter postNotification: note];
}

@end

NSString *AvatarStoreDidUpdateContentNotification = @"AvatarStoreDidUpdateContentNotification";
