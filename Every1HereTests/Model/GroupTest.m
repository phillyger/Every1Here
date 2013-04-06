//
//  GroupTest.m
//  Anseo
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GroupTest.h"
#import "Group.h"

@implementation GroupTest

- (void)setUp
{

    /* Group setup */
    group=[[Group alloc] initWithName:@"Panorama Toastmasters" urlName:@"Panorama+Toastmasters" groupId:@5358342];

//    group.name = [@"Panorama Toastmasters" copy];
//    group.urlName = @"Panorama+Toastmasters";
//    group.groupID = @5358342;

}

- (void)tearDown
{
    group = nil;
}

- (void)testGroupHasAName
{
    STAssertEqualObjects(group.name, @"Panorama Toastmasters", @"Groups need to have a name.");
}

- (void)testGroupHasAMeetupID
{
    STAssertEqualObjects(group.groupId, @5358342, @"Groups need to have a meetupID.");
}

- (void)testGroupHasAMeetupUrlName
{
    STAssertEqualObjects(group.urlName, @"Panorama+Toastmasters", @"Groups need to have a meetupUrlName.");
}


@end
