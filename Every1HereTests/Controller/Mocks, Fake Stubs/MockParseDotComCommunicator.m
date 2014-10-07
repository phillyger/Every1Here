//
//  MockParseDotComCommunicator.m
//  E1H
//
//  Created by Ger O'Sullivan on 1/30/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MockParseDotComCommunicator.h"
#import "Event.h"

@implementation MockParseDotComCommunicator
{
    BOOL wasAskedToFetchMembers;
    BOOL wasAskedToFetchPastEvents;
}


- (BOOL)wasAskedToFetchMembers {
    return wasAskedToFetchMembers;
}

- (BOOL)wasAskedToFetchPastEvents {
    return wasAskedToFetchPastEvents;
}

- (void)downloadMembersWithGroupName:(NSString *)groupName
                       errorHandler:(ParseDotComErrorBlock)errorBlock
                      successHandler:(ParseDotComObjectNotationBlock)successBlock {
    wasAskedToFetchMembers = YES;
}

- (void)downloadPastEventsForGroupName:(NSString *)groupName
                          errorHandler:(ParseDotComErrorBlock)errorBlock
                        successHandler:(ParseDotComObjectNotationBlock)successBlock {
    wasAskedToFetchPastEvents = YES;
}



@end
