//
//  RESTApiPropertyList.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/5/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AFParseDotComAPIClient.h"

@interface RESTApiOperation : NSObject


@property (nonatomic, copy) NSString *uriMethod;
@property (nonatomic, copy) NSString* uriPath;
@property (nonatomic) NSDictionary *data;

- (id)initWithUriMethod:(NSString *)aUriMethod
                uriPath:(NSString *)aUriPath
                   data:(NSDictionary *)newData;

- (id)init;

@end
