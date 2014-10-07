//
//  EffectiveDateRange.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/25/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EffectiveDateRange : NSObject


@property (nonatomic, strong)NSDate *start;
@property (nonatomic, strong)NSDate *end;

- (id)initWithStartDate:(NSDate *)aStartDate endDate:(NSDate *)anEndDate;

@end
