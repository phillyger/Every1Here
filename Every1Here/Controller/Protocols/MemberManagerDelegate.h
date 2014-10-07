//
//  MemberManagerDelegate.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/20/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;
@class User;

@protocol MemberManagerDelegate <NSObject>

- (void)userDidSelectMemberListNotification: (NSNotification *)note;

@end
