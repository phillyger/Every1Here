//
//  AnseoAppDelegateTests.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/12/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "E1HAppDelegateTests.h"
#import "AnseoAppDelegate.h"
#import "BaseViewController.h"
#import "EventListTableDataSource.h"

@implementation E1HAppDelegateTests {
    UIWindow *window;
    UINavigationController *navigationController;
    AnseoAppDelegate *appDelegate;
    BOOL didFinishLaunchingWithOptionsReturn;
}

- (void)setUp {
    window = [[UIWindow alloc] init];
    navigationController = [[UINavigationController alloc] init];
    appDelegate = [[AnseoAppDelegate alloc] init];
    appDelegate.window = window;

//    appDelegate.navigationController = navigationController;
    didFinishLaunchingWithOptionsReturn = [appDelegate application: nil didFinishLaunchingWithOptions: nil];
}

- (void)tearDown {
    window = nil;
    navigationController = nil;
    appDelegate = nil;
}


//- (void)testWindowHasRootNavigationControllerAfterApplicationLaunch {
//    STAssertEqualObjects(window.rootViewController, navigationController, @"App delegate's navigation controller should be the root VC");
//}
//
//- (void)testAppDidFinishLaunchingReturnsYES {
//    STAssertTrue(didFinishLaunchingWithOptionsReturn, @"Method should return YES");
//}

//- (void)testNavigationControllerShowsAnAnseoViewController {
//    id visibleViewController = appDelegate.navigationController.topViewController;
//    STAssertTrue([visibleViewController isKindOfClass: [AnseoViewController class]], @"Views in this app are supplied by BrowseOverflowViewControllers");
//}
//
//- (void)testFirstViewControllerHasAEventTableDataSource {
//    EventListViewController *viewController = (EventListViewController *)appDelegate.navigationController.topViewController;
//    STAssertTrue([viewController.dataSource isKindOfClass: [EventListTableDataSource class]], @"First view should display a list of topics");
//}

//- (void)testEventListIsNotEmptyOnAppLaunch {
//    id <UITableViewDataSource> dataSource = [(AnseoViewController *)[appDelegate.navigationController topViewController] dataSource];
//    STAssertFalse([dataSource tableView: nil numberOfRowsInSection: 0] == 0, @"There should be some rows to display");
//}

//- (void)testFirstViewControllerHasAnObjectConfiguration {
//    EventListViewController *topicViewController = (EventListViewController *)[appDelegate.navigationController topViewController];
//    STAssertNotNil(topicViewController.objectConfiguration, @"The view controller should have an object configuration instance");
//}


@end
