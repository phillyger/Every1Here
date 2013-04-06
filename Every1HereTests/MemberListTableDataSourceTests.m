//
//  MemberListTableDataSourceTests.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/11/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberListTableDataSourceTests.h"
#import "MemberListTableDataSource.h"
#import "AvatarStore+TestingExtensions.h"
#import "MemberSummaryCell.h"
#import "FakeNotificationCenter.h"
#import "AvatarStore.h"
#import "ReloadDataWatcher.h"
#import "Event.h"
#import "Group.h"
#import "Venue.h"
#import "Address.h"
#import "User.h"

@implementation MemberListTableDataSourceTests
{
    MemberListTableDataSource *dataSource;
    NSIndexPath *firstCell;
    Event *ptmEvent;
    User *user1, *user2;
    AvatarStore *store;
    NSNotification *receivedNotification;
}

- (void)setUp {
    dataSource = [[MemberListTableDataSource alloc] init];
    ptmEvent = [[Event alloc] init];
    ptmEvent.group = [[Group alloc] initWithName:@"Panorama Toastmasters"];
    Address *address = [[Address alloc] initWithAddress:@"123 Main St" city:@"Philadelphia" state:@"PA" zip:@"19146" country:@"US" lat:nil lon:nil];
    ptmEvent.name = @"Regular Meeting (3rd Wednesday of Month)";
    ptmEvent.venue = [[Venue alloc] initWithName:@"The Watermark" address:address];
    ptmEvent.status = @"upcoming";
    ptmEvent.startDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:(1361406600000/1000)];
    ptmEvent.endDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:((1361406600000 + 5400000)/1000) ];
    
    dataSource.event = ptmEvent;
    
    user1 = [[User alloc] initWithFirstName:@"Ger" lastName:@"O'Sullivan"];
    [user1 addRole:@"MemberRole"];
    user2 = [[User alloc] initWithDisplayName:@"Harrry_Abbott" avatarLocation:@"http://www.gravatar.com/avatar/ee9aac143636c9e02aa52916f788d7b2" slType:Meetup];
    [user2 addRole:@"MemberRole"];
    
    firstCell = [NSIndexPath indexPathForRow:0 inSection:0];
    
    store = [[AvatarStore alloc] init];
}

- (void)didReceiveNotification: (NSNotification *)note {
    receivedNotification = note;
}

- (void)tearDown {
    ptmEvent = nil;
    user1 = nil;
    user2 = nil;
    firstCell = nil;
    store = nil;
    receivedNotification = nil;
}

- (void)testEventWithNoMembersLeadsToOneRowInTable {
    STAssertEquals([dataSource tableView:nil numberOfRowsInSection:0], (NSInteger)1, @"The table view needs a 'no data yet' placeholder cell.");
}

- (void)testEventWithMembersResultsInOneRowPerMemberInTheTable {
    [ptmEvent addMember:user1];
    [ptmEvent addMember:user2];
    STAssertEquals([dataSource tableView:nil numberOfRowsInSection:0], (NSInteger)2, @"Two members in the event means two rows in table.");
}

- (void)testContentsOfPlaceholderCell {
    UITableViewCell *placeHolderCell = [dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    STAssertEqualObjects(placeHolderCell.textLabel.text, @"There was a problem connecting to the network.", @"The placeholder cell ought to display a placeholder message");
}

- (void)testPlaceholderCellNotReturnedWhenMembersExist {
    [ptmEvent addMember:user1];
    UITableViewCell *cell = [dataSource tableView:nil cellForRowAtIndexPath:firstCell];
    STAssertFalse([cell.textLabel.text isEqualToString:@"There was a problem connecting to the network"], @"Placeholder should only be shown when there is no content.");
}
//
//- (void)testCellPropertiesAreTheSameAsUser {
//    [ptmEvent addMember:user1];
//    MemberSummaryCell *cell = (MemberSummaryCell *)[dataSource tableView:nil cellForRowAtIndexPath:firstCell];
//    STAssertEqualObjects(cell.displayNameLabel.text, @"Ger O'Sullivan", @"Member cells display the members name.");
//    
//}
//
//- (void)testCellGetsImageFromAvatorStore {
//    dataSource.avatarStore = store;
//    NSURL *imageURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"ger_osullivan" withExtension:@"jpg"];
//    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//    [store setData: imageData forLocation:@"http://www.gravatar.com/avatar/ee9aac143636c9e02aa52916f788d7b2"];
//    [ptmEvent addMember:user2];
//    MemberSummaryCell *cell = (MemberSummaryCell *)[dataSource tableView:nil cellForRowAtIndexPath:firstCell];
//    STAssertNotNil(cell.avatarView.image, @"The avatar store should supply avatar images.");
//}

- (void)testMemberListRegistersForAvatarNotifications {
    FakeNotificationCenter *center = [[FakeNotificationCenter alloc] init];
    dataSource.notificationCenter = (NSNotificationCenter *)center;
    [dataSource registerForUpdatesToAvatarStore: store];
    STAssertTrue([center hasObject: dataSource forNotification: AvatarStoreDidUpdateContentNotification], @"The data source should know when new images have been downloaded");
}

- (void)testMemberListStopsRegisteringForAvatarNotifications {
    FakeNotificationCenter *center = [[FakeNotificationCenter alloc] init];
    dataSource.notificationCenter = (NSNotificationCenter *)center;
    [dataSource registerForUpdatesToAvatarStore: store];
    [dataSource removeObservationOfUpdatesToAvatarStore: store];
    STAssertFalse([center hasObject: dataSource forNotification: AvatarStoreDidUpdateContentNotification], @"The data source  should no longer listen to avatar store notifications");
}

- (void)testMemberListCausesTableReloadOnAvatarNotification {
    ReloadDataWatcher *fakeTableView = [[ReloadDataWatcher alloc] init];
    dataSource.tableView = (UITableView *)fakeTableView;
    [dataSource avatarStoreDidUpdateContent: nil];
    STAssertTrue([fakeTableView didReceiveReloadData], @"Data source should get the table view to reload when new data is available");
}

//- (void)testSelectingPlaceholderDoesNotSendSelectionNotification {
//    dataSource.notificationCenter = [NSNotificationCenter defaultCenter];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didReceiveNotification:) name: @"MemberListDidSelectMemberNotification" object: nil];
//    [dataSource tableView: nil didSelectRowAtIndexPath: firstCell];
//    STAssertNil(receivedNotification, @"Shouldn't be notified of selecting the placeholder cell");
//}

@end
                    
