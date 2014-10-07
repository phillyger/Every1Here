//
//  Attendance.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attendance : NSObject

@property (nonatomic, strong)NSString *eventId;
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSNumber *guestCount;
@property (nonatomic, strong)NSNumber *eventRoles;

- (id)initWithEventId:(NSString*)anEventId
               userId:(NSString*)aUserId
           guestCount:(NSNumber*)guestCount
           eventRoles:(NSNumber*)eventRoles;
@end
