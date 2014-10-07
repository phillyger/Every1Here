//
//  GuestListSection.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuestAttendeeListSection : NSObject

@property (nonatomic, strong, readonly) NSArray *users;

- (id)initWithArray:(NSArray *)array;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;


@end
