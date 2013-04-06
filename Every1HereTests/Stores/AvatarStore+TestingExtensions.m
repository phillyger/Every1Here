//
//  AvatarStore+TestingExtensions.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/12/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AvatarStore+TestingExtensions.h"


@implementation AvatarStore (TestingExtensions)

- (void)setData:(NSData *)data forLocation:(NSString *)location {
    [dataCache setObject: data forKey: location];
}

- (NSUInteger)dataCacheSize {
    return [[dataCache allKeys] count];
}

- (NSDictionary *)communicators {
    return communicators;
}

- (NSNotificationCenter *)notificationCenter {
    return notificationCenter;
}

@end
