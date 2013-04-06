//
//  AvatorStore.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/3/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvatarStore : NSObject
{
    NSMutableDictionary *dataCache;
    NSMutableDictionary *communicators;
    NSNotificationCenter *notificationCenter;
}

- (NSData *)dataForURL: (NSURL *)url;
- (void)didReceiveMemoryWarning: (NSNotification *)note;
- (void)useNotificationCenter: (NSNotificationCenter *)center;
- (void)stopUsingNotificationCenter: (NSNotificationCenter *)center;

@end


extern NSString *AvatarStoreDidUpdateContentNotification;
