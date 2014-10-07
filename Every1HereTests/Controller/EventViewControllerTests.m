//
//  E1HViewControllerTests.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/8/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventViewControllerTests.h"
#import "EventListViewController.h"
#import "EventListTableDataSource.h" 
#import "MemberListTableDataSource.h"
#import "E1HObjectConfiguration.h"
#import "TestObjectConfiguration.h"
#import "MockParseDotComManager.h"
//#import "MockMeetupDotComManager.h"
#import <objc/objc-runtime.h>
#import "Event.h"
#import "Group.h"
#import "Venue.h"
#import "Address.h"

static const char *notificationKey = "E1HViewControllerTestsAssociatedNotificationKey";

@implementation BaseViewController (TestNotificationDelivery)


- (void)E1HControllerTests_userDidSelectEventNotification: (NSNotification *)note {
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

//- (void)E1HControllerTests_userDidSelectMemberNotification: (NSNotification *)note {
//    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
//}


@end

static const char *viewDidAppearKey = "E1HViewControllerTestsViewWillAppearKey";
static const char *viewWillDisappearKey = "E1HViewControllerTestsViewWillDisappearKey";
static const char *viewWillAppearKey = "E1HViewControllerTestsViewWillAppearKey";

@implementation UIViewController (TestSuperclassCalled)

- (void)E1HViewControllerTests_viewDidAppear: (BOOL)animated {
    NSNumber *parameter = [NSNumber numberWithBool: animated];
    objc_setAssociatedObject(self, viewDidAppearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

- (void)E1HViewControllerTests_viewWillDisappear: (BOOL)animated {
    NSNumber *parameter = [NSNumber numberWithBool: animated];
    objc_setAssociatedObject(self, viewWillDisappearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}

- (void)browseOverflowViewControllerTests_viewWillAppear: (BOOL)animated {
    NSNumber *parameter = [NSNumber numberWithBool: animated];
    objc_setAssociatedObject(self, viewWillAppearKey, parameter, OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation EventViewControllerTests
{
    BaseViewController *viewController;
    EventListViewController *upcomingViewController;
    EventListViewController *pastViewController;
    UITableView *tableView;
    id <UITableViewDataSource, UITableViewDelegate> dataSource;
    UINavigationController *navController;
    E1HObjectConfiguration *objectConfiguration;
    TestObjectConfiguration *testConfiguration;
    MockParseDotComManager *parseDotComManager;
//    MockMeetupDotComManager *meetupDotComManager;
    
    SEL realViewDidAppear, testViewDidAppear;
    SEL realViewWillDisappear, testViewWillDisappear;
    SEL realViewWillAppear, testViewWillAppear;
    SEL realUserDidSelectEvent, testUserDidSelectEvent;
//    SEL realUserDidSelectMembers, testUserDidSelectMembers;
}

+ (void)swapInstanceMethodsForClass: (Class) cls selector: (SEL)sel1 andSelector: (SEL)sel2 {
    Method method1 = class_getInstanceMethod(cls, sel1);
    Method method2 = class_getInstanceMethod(cls, sel2);
    method_exchangeImplementations(method1, method2);
}

- (void)setUp {
    viewController = [[BaseViewController alloc] init];
    upcomingViewController = [[EventListViewController alloc] init];
    pastViewController = [[EventListViewController alloc] init];
    tableView = [[UITableView alloc] init];
    upcomingViewController.tableView = tableView;
    
    navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    dataSource = [[EventListTableDataSource alloc] init];
    upcomingViewController.dataSource = dataSource;
    objc_removeAssociatedObjects(viewController);
    
    realViewDidAppear = @selector(viewDidAppear:);
    testViewDidAppear = @selector(E1HViewControllerTests_viewDidAppear:);
    [EventViewControllerTests swapInstanceMethodsForClass: [UIViewController class]
                                                 selector: realViewDidAppear
                                              andSelector: testViewDidAppear];

    realViewWillDisappear = @selector(viewWillDisappear:);
    testViewWillDisappear = @selector(E1HViewControllerTests_viewWillDisappear:);
    [EventViewControllerTests swapInstanceMethodsForClass: [UIViewController class]
                                                 selector: realViewWillDisappear
                                              andSelector: testViewWillDisappear];
    
    realViewWillAppear = @selector(viewWillAppear:);
    testViewWillAppear = @selector(browseOverflowViewControllerTests_viewWillAppear:);
    [EventViewControllerTests swapInstanceMethodsForClass: [UIViewController class] selector: realViewWillAppear andSelector: testViewWillAppear];
    

    realUserDidSelectEvent = @selector(userDidSelectEventNotification:);
    testUserDidSelectEvent = @selector(E1HControllerTests_userDidSelectEventNotification:);
    
    navController = [[UINavigationController alloc] initWithRootViewController: viewController];
    objectConfiguration = [[E1HObjectConfiguration alloc] init];
    viewController.objectConfiguration = objectConfiguration;
    testConfiguration = [[TestObjectConfiguration alloc] init];
    parseDotComManager = [[MockParseDotComManager alloc] init];
    testConfiguration.objectToReturn = parseDotComManager;
}

- (void)tearDown {
     objc_removeAssociatedObjects(viewController);
    viewController = nil;
    tableView = nil;
    dataSource = nil;
    navController = nil;
    
    [EventViewControllerTests swapInstanceMethodsForClass: [UIViewController class]
                                                 selector: realViewDidAppear
                                              andSelector: testViewDidAppear];
    
    [EventViewControllerTests swapInstanceMethodsForClass: [UIViewController class]
                                                 selector: realViewWillDisappear
                                              andSelector: testViewWillDisappear];
    
    [EventViewControllerTests swapInstanceMethodsForClass: [UIViewController class]
                                                 selector: realViewWillAppear
                                              andSelector: testViewWillAppear];

}


- (void)testViewControllerHasATableProperty {
    objc_property_t tableViewProperty = class_getProperty([viewController class], "tableView");
    STAssertTrue(tableViewProperty != NULL, @"E1HViewController needs a table view.");
}

- (void)testViewControllerHasADataSourceProperty {
    objc_property_t dataSourceProperty = class_getProperty([viewController class], "dataSource");
    STAssertTrue(dataSourceProperty != NULL, @"E1HViewController needs a data source.");
}

//
//- (void)testUpcomingEventViewControllerConnectsDataSourceInViewLoad {
//    [upcomingViewController viewDidLoad];
//    STAssertEqualObjects([tableView dataSource], dataSource, @"View controller should have set the table view's data source.");
//}
//
//- (void)testViewControllerConnectsDelegateInViewLoad {
//    [upcomingViewController viewDidLoad];
//    STAssertEqualObjects([tableView delegate], dataSource, @"View controller should have set the table view's delegate.");
//}
//
//- (void)testViewControllerConnectsTableViewBacklinkInViewDidLoad {
//    MemberListTableDataSource *memberDataSource = [[MemberListTableDataSource alloc] init];
//    viewController.dataSource = memberDataSource;
//    [upcomingViewController viewDidLoad];
//    STAssertEqualObjects(memberDataSource.tableView, tableView, @"Back-link to table view should be set in data source");
//}

//- (void)testDefaultStateOfViewControllerDoesNotReceiveEventSelectionNotifications {
//    [EventViewControllerTests swapInstanceMethodsForClass: [EventListViewController class] selector: realUserDidSelectEvent andSelector: testUserDidSelectEvent];
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:EventListTableDidSelectEventNotification
//     object: nil
//     userInfo: nil];
//    STAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"Notification should not be received before -viewDidAppear:");
//    [EventViewControllerTests swapInstanceMethodsForClass: [EventListViewController class] selector: realUserDidSelectEvent andSelector: testUserDidSelectEvent];
//}
//
//- (void)testViewControllerReceivesEventSelectionNotificationAfterViewDidAppear {
//    [EventViewControllerTests swapInstanceMethodsForClass: [EventListViewController class] selector: realUserDidSelectEvent andSelector: testUserDidSelectEvent];
//    [viewController viewDidAppear: NO];
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName: EventListTableDidSelectEventNotification
//     object: nil
//     userInfo: nil];
//    STAssertNotNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewDidAppear: the view controller should handle selection notifications");
//    [EventViewControllerTests swapInstanceMethodsForClass: [EventListViewController class] selector: realUserDidSelectEvent andSelector: testUserDidSelectEvent];
//}

//- (void)testViewControllerDoesNotReceiveEventSelectNotificationAfterViewWillDisappear {
//    [EventViewControllerTests swapInstanceMethodsForClass: [EventListViewController class] selector: realUserDidSelectEvent andSelector: testUserDidSelectEvent];
//    [viewController viewDidAppear: NO];
//    [viewController viewWillDisappear: NO];
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName: EventListTableDidSelectEventNotification
//     object: nil
//     userInfo: nil];
//    STAssertNil(objc_getAssociatedObject(viewController, notificationKey), @"After -viewWillDisappear: is called, the view controller should no longer respond to topic selection notifications");
//    [EventViewControllerTests swapInstanceMethodsForClass: [EventListViewController class] selector: realUserDidSelectEvent andSelector: testUserDidSelectEvent];}


- (void)testViewControllerCallsSuperViewDidAppear {
    [viewController viewDidAppear: NO];
    STAssertNotNil(objc_getAssociatedObject(viewController, viewDidAppearKey), @"-viewDidAppear: should call through to superclass implementation");
}

- (void)testViewControllerCallsSuperViewWillDisappear {
    [viewController viewWillDisappear: NO];
    STAssertNotNil(objc_getAssociatedObject(viewController, viewWillDisappearKey), @"-viewWillDisappear: should call through to superclass implementation");
}

//- (void)testSelectingEventPushesNewViewController {
//    [viewController userDidSelectEventNotification: nil];
//    UIViewController *currentTopVC = navController.topViewController;
//    STAssertFalse([currentTopVC isEqual: viewController], @"New view controller should be pushed onto the stack");
//    STAssertTrue([currentTopVC isKindOfClass: [EventViewController class]], @"New view controller should be a E1HViewController");
//}


//- (void)testNewViewControllerHasAQuestionListDataSourceForTheSelectedEvent {
//    Event *ptmEvent = [[Event alloc] init];
//    ptmEvent.group = [[Group alloc] initWithName:@"Panorama Toastmasters"];
//    Address *address = [[Address alloc] initWithAddress:@"123 Main St" city:@"Philadelphia" state:@"PA" zip:@"19146" country:@"US" lat:nil lon:nil];
//    ptmEvent.venue = [[Venue alloc] initWithName:@"The Watermark" address:address];
//    ptmEvent.status = @"upcoming";
//    ptmEvent.startDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:(1361406600000/1000)];
//    ptmEvent.endDateTime = [[NSDate alloc] initWithTimeIntervalSince1970:((1361406600000 + 5400000)/1000) ];
//    
//    NSNotification *ptmEventSelectedNotification = [NSNotification notificationWithName: EventListTableDidSelectEventNotification object: ptmEvent];
//    [viewController userDidSelectEventNotification: ptmEventSelectedNotification];
//    EventListViewController *nextViewController = (EventListViewController *)navController.topViewController;
//    STAssertTrue([nextViewController.dataSource isKindOfClass: [MemberListTableDataSource class]], @"Selecting an event should push a list of possible members.");
//    STAssertEqualObjects([(MemberListTableDataSource *)nextViewController.dataSource event], ptmEvent, @"The members to display should come from the selected event");
//}
//
//- (void)testSelectingEventNotificationPassesObjectConfigurationToNewViewController {
//    [viewController userDidSelectEventNotification: nil];
//    EventListViewController *newTopVC = (EventListViewController *)navController.topViewController;
//    STAssertEqualObjects(newTopVC.objectConfiguration, objectConfiguration, @"The object configuration should be passed through to the new view controller");
//}
//
//- (void)testSelectingMemberNotificationPassesObjectConfigurationToNewViewController {
//    [viewController userDidSelectMemberNotification: nil];
//    EventListViewController *newTopVC = (EventListViewController *)navController.topViewController;
//    STAssertEqualObjects(newTopVC.objectConfiguration, objectConfiguration, @"The object configuration should be passed through to the new view controller");
//}

//- (void)testViewWillAppearCreatesAParseDotComManager {
//    [viewController viewWillAppear: YES];
//    STAssertNotNil(viewController.parseDotComMgr, @"Set up a stack overflow manager before the view appears");
//}

- (void)testViewWillAppearCallsSuper {
    [viewController viewWillAppear: YES];
    STAssertNotNil(objc_getAssociatedObject(viewController, viewWillAppearKey), @"-viewWillAppear: is documented to require a call to super");
}

//- (void)testViewWillAppearOnMemberListInitiatesLoadingOfMembers {
//    viewController.objectConfiguration = testConfiguration;
//    viewController.dataSource = [[MemberListTableDataSource alloc] init];
//    [viewController viewWillAppear: YES];
//    STAssertTrue([parseDotComManager didFetchMembers], @"View controller should have arranged for member content to be downloaded");
//}


@end
