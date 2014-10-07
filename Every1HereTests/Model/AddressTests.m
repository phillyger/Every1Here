//
//  AddressTests.m
//  E1H
//
//  Created by Ger O'Sullivan on 1/28/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AddressTests.h"
#import "Address.h"

@implementation AddressTests

- (void)setUp {
    address = [[Address alloc] init];
    address.address1 = @"123 Washington St";
    address.city = @"Philadelphia";
    address.state = @"PA";
    address.zip = @"19146";
    address.country = @"us";
    address.lat = @0.0;
    address.lon = @0.0;
    
}

- (void)tearDown {
    address = nil;
}



@end
