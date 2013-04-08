//
//  Person.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (copy) NSString *firstName;
@property (copy) NSString *lastName;

- (id)initWithFirstName: (NSString *)aFirstName lastName:(NSString *)aLastName;

@end
