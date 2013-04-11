//
//  AnseoObjectConfigurationTests.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/14/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "E1HObjectConfigurationTests.h"
#import "AnseoObjectConfiguration.h"
#import "ParseDotComManager.h"
#import "ParseDotComCommunicator.h"
#import "MeetupDotComManager.h"
#import "MeetupDotComCommunicator.h"
#import "AvatarStore.h"
#import "AvatarStore+TestingExtensions.h"

@implementation E1HObjectConfigurationTests

{
    AnseoObjectConfiguration *configuration;
}

- (void)setUp {
    configuration = [[AnseoObjectConfiguration alloc] init];
}

- (void)tearDown {
    configuration = nil;
}

- (void)testConfigurationOfCreatedSParseDotComManager {
    ParseDotComManager *manager = [configuration parseDotComManager];
    STAssertNotNil(manager, @"The StackOverflowManager should exist");
    STAssertNotNil(manager.communicator, @"Manager should have a StackOverflowCommunicator");
    STAssertNotNil(manager.memberBuilder, @"Manager should have a member builder");
    STAssertEqualObjects(manager.communicator.delegate, manager, @"The manager is the communicator's delegate");
}

//- (void)testConfigurationOfCreatedAvatarStore {
//    AvatarStore *store = [configuration avatarStore];
//    STAssertEqualObjects([store notificationCenter], [NSNotificationCenter defaultCenter], @"Configured AvatarStore posts notifications to the default center");
//}

- (void)testSameAvatarStoreAlwaysReturned {
    AvatarStore *store1 = [configuration avatarStore];
    AvatarStore *store2 = [configuration avatarStore];
    STAssertEqualObjects(store1, store2, @"The same store should always be used");
}

@end
