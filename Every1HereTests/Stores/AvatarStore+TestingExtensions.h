//
//  AvatarStore+TestingExtensions.h
//  E1H
//
//  Created by Ger O'Sullivan on 2/12/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvatarStore.h"

@interface AvatarStore (TestingExtensions)

- (void)setData: (NSData *)data forLocation: (NSString *)location;
- (NSUInteger)dataCacheSize;
- (NSDictionary *)communicators;
- (NSNotificationCenter *)notificationCenter;

@end
