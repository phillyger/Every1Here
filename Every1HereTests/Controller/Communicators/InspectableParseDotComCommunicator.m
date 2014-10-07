//
//  InspectableParseDotComCommunicator.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/7/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "InspectableParseDotComCommunicator.h"

@implementation InspectableParseDotComCommunicator

- (NSString *)URLPathToFetch {
    return fetchingURLPath;
}

- (NSDictionary *)URLParametersToFetch {
    return fetchingURLParameters;
}

@end
