//
//  Group.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject 


@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *urlName;
@property (nonatomic, strong)NSNumber *groupId;
@property (nonatomic, strong)NSString *objectId;  //parse.com primary id. 

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name urlName:(NSString *)urlName;
- (id)initWithName:(NSString *)name urlName:(NSString *)urlName groupId:(NSNumber *)groupId objectId:(NSString *)anObjectId;

@end
