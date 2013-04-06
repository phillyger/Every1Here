//
//  RESTApiPropertyList.h
//  Anseo
//
//  Created by Ger O'Sullivan on 4/5/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTApiOperation : NSObject

@property (nonatomic, copy) NSString *uriMethod;
@property (nonatomic, copy) NSString* uriPath;
@property (nonatomic) NSMutableDictionary *data;
@property (nonatomic) NSMutableArray *dependencies;

- (id)initWithUriMethod:(NSString *)aUriMethod
                uriPath:(NSString *)aUriPath
                   data:(NSDictionary *)newData
           dependencies:(NSArray *)newDependencies;

- (id)init;

@end
