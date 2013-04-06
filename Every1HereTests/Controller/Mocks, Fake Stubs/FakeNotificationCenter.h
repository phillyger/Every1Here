//
//  FakeNotificationCenter.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/12/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeNotificationCenter : NSObject


- (void)addObserver: (id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
- (void)removeObserver: (id)observer;
- (void)postNotification: (NSNotification *)notification;
- (void)removeObserver: (id)observer name: (NSString *)aName object: (id)obj;
- (BOOL)hasObject: (id)observer forNotification: (NSString *)aName;
- (BOOL)didReceiveNotification: (NSString *)name fromObject: (id)obj;


@end
