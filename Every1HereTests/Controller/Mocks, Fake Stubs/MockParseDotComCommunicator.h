//
//  MockParseDotComCommunicator.h
//  Anseo
//
//  Created by Ger O'Sullivan on 1/30/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "ParseDotComCommunicator.h"


@interface MockParseDotComCommunicator : ParseDotComCommunicator


- (BOOL)wasAskedToFetchMembers;
- (BOOL)wasAskedToFetchPastEvents;



@end
