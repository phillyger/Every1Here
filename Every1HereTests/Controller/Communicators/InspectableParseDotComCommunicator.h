//
//  InspectableParseDotComCommunicator.h
//  E1H
//
//  Created by Ger O'Sullivan on 2/7/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "ParseDotComCommunicator.h"

@interface InspectableParseDotComCommunicator : ParseDotComCommunicator {
}

- (NSString *)URLPathToFetch;
- (NSDictionary *)URLParametersToFetch;

@end
