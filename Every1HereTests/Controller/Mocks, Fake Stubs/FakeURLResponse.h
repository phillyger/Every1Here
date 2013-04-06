//
//  FakeURLResponse.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/7/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeURLResponse : NSObject  {
    NSInteger statusCode;
}

- (id)initWithStatusCode: (NSInteger)code;
- (NSInteger)statusCode;


@end
