//
//  RoleDelegate.h
//  Anseo
//
//  Created by Ger O'Sullivan on 1/24/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EffectiveDateRange;

@protocol RoleDelegate <NSObject>

/*
 *  Roel Object Pattern
 *  http://hillside.net/plop/plop97/Proceedings/riehle.pdf
 */

@required
- (id)getRole:(NSString *)aSpec;
- (void)addRole:(NSString *)aSpec;
- (BOOL)hasRole:(NSString *)aSpec;
- (void)removeRole:(NSString *)aSpec;


/*
 *  Effectivity Pattern 
 *  http://martinfowler.com/eaaDev/Effectivity.html
 */

@optional
- (BOOL)isEffectiveOn:(NSDate *)aDate;
- (void)addEffectiveDateRangeStart:(NSDate *)aStartDate end:(NSDate *)anEndDate;
- (void)addRoleWithName:(NSString *)aSpec effectiveDateRangeStart:(NSDate *)effectiveStart effectiveDateRangeEnd:(NSDate *)effectiveEnd;
- (BOOL)hasEffectiveDateRange:(NSString *)aSpec;
- (void)removeEffectiveDateRange;

@end
