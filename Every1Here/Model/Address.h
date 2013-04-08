//
//  Addresss.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/28/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, strong)NSString *address1;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *state;
@property (nonatomic, strong)NSString *zip;
@property (nonatomic, strong)NSString *country;
@property (nonatomic, strong)NSNumber *lat;
@property (nonatomic, strong)NSNumber *lon;

- (id)initWithAddress:(NSString*)address1
                 city:(NSString*)city
                state:(NSString*)state
                  zip:(NSString*)zip
              country:(NSString*)country
                  lat:(NSNumber *)lat
                  lon:(NSNumber *)lon;

@end
