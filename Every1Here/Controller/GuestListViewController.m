//
//  GuestPickerViewController.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/27/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestListViewController.h"
#import "GuestDetailsDialogController.h"
#import "GuestCommunicatorDelegate.h"
#import "EventMemberGuestTabBarController.h"
#import "GuestListTableDataSource.h"
#import "AnseoObjectConfiguration.h"
#import "FPPopoverController.h"
#import "GuestListPopoverTableController.h"
#import "GuestListViewNavigationItem.h"
#import "GuestNavIconView.h"
#import "Event.h"
#import "User.h"
#import "BlockAlertView.h"
#import "SocialNetworkUtilities.h"
#import "NSDictionary+RWFlatten.h"
#import "QuickDialog.h"
#import "AttendanceReceptionist.h"
#import "DisplayNameReceptionist.h"
#import "EventRole.h"
#import "ParseDotComManager.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static NSString *guestCellReuseIdentifier = @"guestSummaryCell";

@interface GuestListViewController ()
{
    Event *selectedEvent;
    User * selectedGuest;
    NSString *slTypeString;
    
    AttendanceReceptionist *attendanceReceptionist;
    DisplayNameReceptionist *displayNameReceptionist;
    MBProgressHUD *hud;
}

-(void)setGuestAttendeeListWithSlType:(SocialNetworkType) slType;
-(void)setGuestFullListWithSlType:(SocialNetworkType) slType;


//@property (strong) NSDictionary *guestListFullDict;
//@property (nonatomic, assign, getter=isAttendee) BOOL attendee;

-(IBAction) popover:(id)sender slType:(SocialNetworkType *)slType;

@end

@implementation GuestListViewController
@synthesize tableView;
@synthesize dataSource;
@synthesize objectConfiguration;
@synthesize guestFullListDict;
@synthesize guestAttendeeListDict;
@synthesize guestAttendeeListForSlType;
@synthesize guestFullListForSlType;
@synthesize parseDotComMgr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    UINib *guestCellNib = [UINib nibWithNibName:@"GuestSummaryCell" bundle:nil];
    [self.tableView registerNib:guestCellNib
         forCellReuseIdentifier:guestCellReuseIdentifier];
    
    // Get a handle on the selected index -  IS THERE A PATTERN I CAN USE FOR KEEPING TRACK OF SELECTED EVENT?
    EventMemberGuestTabBarController *tabBarController = (EventMemberGuestTabBarController *)[[self navigationController] tabBarController];
    selectedEvent = [tabBarController selectedEvent];
    selectedGuest = [[User alloc] initWithFirstName:nil lastName:nil];
    
    
    
    
    // custom navigationItem to display social media links.
//    GuestListViewNavigationItem *navItem = [(GuestListViewNavigationItem *)[self navigationItem] init];

    GuestListViewNavigationItem *navItem = [(GuestListViewNavigationItem *)[self navigationItem] initWithDelegate:self];
    
    // assign controller as the delegate for the custom navItem's to ensure image clicks on social icons get triggered.
//    navItem.delegate = self;
    
    // A full listing of all potential guests
    self.guestFullListDict = [[NSMutableDictionary alloc] init];
    self.guestFullListForSlType = [[NSMutableArray alloc] init];
    
    // The actual attendee guest list.
    self.guestAttendeeListDict = [[NSMutableDictionary alloc] init];
    self.guestAttendeeListForSlType = [[NSMutableArray alloc] init];
    

    self.objectConfiguration = [[AnseoObjectConfiguration alloc] init];
    GuestListTableDataSource *guestListDataSource = [[GuestListTableDataSource alloc] init];
    guestListDataSource.event = selectedEvent;
    


    
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.parseDotComDelegate = self;
    
    self.dataSource = guestListDataSource;
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    
    if ([self.dataSource isKindOfClass: [GuestListTableDataSource class]]) {
//        [self fetchGuestListTableContent];
        //        [(EventListTableDataSource *)self.dataSource setAvatarStore: [objectConfiguration avatarStore]];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(userDidSelectGuestListNotification:)
     name: GuestListDidSelectGuestNotification
     object: nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear: animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self name: GuestListDidSelectGuestNotification object: nil];
    
    //    [[NSNotificationCenter defaultCenter]
    //     removeObserver: self name: EventListTableDidSelectEventNotification object: nil];
    //    [[NSNotificationCenter defaultCenter]
    //     removeObserver: self name: MemberListDidSelectMemberNotification object: nil];
}


- (void)fetchMemberListTableContent
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.dimBackground = YES;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    hud.labelText = @"Loading..";
    [hud show:TRUE];
    
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.parseDotComDelegate = self;
    selectedEvent = (Event *)[(GuestListTableDataSource *)self.dataSource event];
//    [self.parseDotComMgr fetchGuestsForEvent:selectedEvent];
}


- (void)popover:(id)sender slType:(SocialNetworkType *)slType {
    
    popover=nil;
    GuestListPopoverTableController *controller = [[GuestListPopoverTableController alloc] initWithStyle:UITableViewStylePlain];

    [self setGuestFullListWithSlType:slType];
    [self setGuestAttendeeListWithSlType:slType];
    controller.slType = slType;
    controller.guestFullListForSlType = self.guestFullListForSlType;
    controller.guestAttendeeListForSlType = self.guestAttendeeListForSlType;
    controller.event = selectedEvent;
    controller.delegate = self;
    
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.tint = FPPopoverDefaultTint;
    popover.contentSize = CGSizeMake(300, 370);

    //sender is the UIButton view
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    [popover presentPopoverFromView:sender];
}


- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
}


-(void)setGuestAttendeeListWithSlType:(SocialNetworkType)slType {
     slTypeString = [SocialNetworkUtilities formatTypeToString:slType];
    if ([[self.guestAttendeeListDict allKeys] containsObject:slTypeString]) {
        self.guestAttendeeListForSlType = (NSMutableArray *)[self.guestAttendeeListDict objectForKey:slTypeString];
    } else {
        self.guestAttendeeListForSlType = [[NSMutableArray alloc] init];
        [self.guestAttendeeListForSlType removeAllObjects];
    }
    
}

- (void)setGuestFullListWithSlType:(SocialNetworkType) slType {
    
    slTypeString = [SocialNetworkUtilities formatTypeToString:slType];
    self.guestFullListForSlType = (NSMutableArray *)[self.guestFullListDict objectForKey:slTypeString];
}



#pragma mark - Popover Delegate
//-(void)didSelectPopoverRow:(NSUInteger)rowNum forSocialNetworkType:(SocialNetworkType)slType
//{
//    // Sets the guestFullList array for SlType
////    [self setGuestFullListWithSlType:slType];
////    [self setGuestAttendeeListWithSlType:slType];
//    
//    User *popoverUser = [self guestFullListForSlType][rowNum];
//    BOOL isAttendeeForSlType = [self isAttendee:popoverUser forSlType:slType inRow:rowNum];
//    
//    if (!isAttendeeForSlType) {
//        // Add a new user to the the guestListAttendeeArray
//        [self.guestAttendeeListForSlType addObject:popoverUser];
//        
//    }
//    
//    [self updateTableContentsForSlType:slType];
//}
//
//-(void)didDeselectPopoverRow:(NSUInteger)rowNum forSocialNetworkType:(SocialNetworkType)slType
//{
//
//    // Sets the guestFullList array for SlType
////    [self setGuestFullListWithSlType:slType];
////    [self setGuestAttendeeListWithSlType:slType];
//    
//    User *popoverUser = [self guestFullListForSlType][rowNum];
//    BOOL isAttendeeForSlType = [self isAttendee:popoverUser forSlType:slType inRow:rowNum];
//    
//    if (isAttendeeForSlType) {
//        // Remove a new user from the the guestAttendeeList array for specific social network type
//        [[self guestAttendeeListForSlType] removeObject:popoverUser];
//        
//        // remove section header if the attendee array is empty
//        if ([[self guestAttendeeListForSlType] count] == 0) {
//            [[self guestAttendeeListDict] removeObjectForKey:[SocialNetworkUtilities formatTypeToString:slType]];
//        }
//        
//    }
//    
//    [self updateTableContentsForSlType:slType];
//}


- (BOOL)isAttendee:(User *)user forSlType:(SocialNetworkType)slType inRow:(NSUInteger)rowNum {
    
    BOOL isAttendeeForSlType = NO;
//    [self setGuestAttendeeListWithSlType:slType];
    if ([[self guestAttendeeListForSlType] count] > 0)
        isAttendeeForSlType = [self findKeyForGuest:user inArray:[self guestAttendeeListForSlType]];
    
    return isAttendeeForSlType;

}

- (void)closeView {
    selectedEvent = nil;
    selectedGuest = nil;
    //    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)receivedGuestFullList:(NSArray *)guestFullList forKey:(NSString *)aKey {
    NSLog(@"receivedGuestFullList: forSlType");
    [self.guestFullListDict setObject:guestFullList forKey: aKey];
}


#pragma mark - Navigation Item Icon Delegate

- (void)didReceiveTwitterEvent:(id)sender {
    NSLog(@"Received TWITTER event.");
     [self popover:sender slType:Twitter];
}

- (void)didReceiveFacebookEvent:(id)sender {

    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Facebook Integration" message:@"Sorry folks! Still working on implementing this. Check back soon."];
    [alert setCancelButtonWithTitle:@"Ok" block:nil];
    [alert show];
}

- (void)didReceiveMeetupEvent:(id)sender {
    NSLog(@"Received MEETUP event.");
    [self popover:sender slType:Meetup];
}

- (void)didReceiveLinkedInEvent:(id)sender {
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"LinkedIn Integration" message:@"Sorry folks! Still working on implementing this. Check back soon."];
    
    [alert setCancelButtonWithTitle:@"Ok" block:nil];
    [alert show];
}

- (BOOL)findKeyForGuest:(User *)popoverUser inArray:(NSArray *)guestList {
    
    // 1 - Find the matching item index
    NSIndexSet* indexes = [guestList indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        User* keyUser = obj;
        return [popoverUser.displayName isEqualToString:keyUser.displayName];
    }];
    
    // 2 - Return first matching item
    if ([indexes count] >= 1) {
//        User *keyUser = [self.guestListAttendeeForSlTypeArray objectAtIndex:[indexes firstIndex]];
        return YES;
    }
    return NO;
}

#pragma mark - Notification handling
- (void)userDidSelectGuestListNotification:(NSNotification *)note {
    
    
    __block BOOL doesAttendanceRecordExist = FALSE;
    
    selectedGuest = (User *)[note object];
    QRootElement *root =[[QRootElement alloc] initWithJSONFile:@"guestDetails_EDIT"];
    [root bindToObject:(User *)selectedGuest];

    
    GuestDetailsDialogController *guestDetailsController = [(GuestDetailsDialogController *)[GuestDetailsDialogController alloc] initWithRoot:root];
    guestDetailsController.userToEdit = selectedGuest;
    
    EventRole *eventRoleModel = [selectedGuest getRole:@"EventRole"];
    NSOperationQueue* aQueue = [NSOperationQueue mainQueue];  // Question: Can these updates to attendance and event roles be handled by secondary thread.
    

    attendanceReceptionist = [AttendanceReceptionist receptionistForKeyPath:@"attendance"
                                                                     object:eventRoleModel
                                                                      queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                                          
                                                                          NSLog(@"Running Attendance Receptionist ...");
                                                                          BOOL oldAttendance = [[change objectForKey:NSKeyValueChangeOldKey] boolValue];
                                                                          
                                                                          BOOL newAttendance = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
                                                                          //                                                                                        NSLog(@"%@", (oldAttendance?@"YES":@"NO"));
                                                                          //                                                                                        NSLog(@"%@", (newAttendance?@"YES":@"NO"));
                                                                          
                                                                          if (newAttendance == oldAttendance) {
                                                                              //do nothing
                                                                              doesAttendanceRecordExist = TRUE;
                                                                          } else if (newAttendance == TRUE) {
                                                                              doesAttendanceRecordExist = FALSE;
                                                                              [parseDotComMgr createNewAttendanceWithUser:selectedGuest withEvent: selectedEvent];
                                                                              
                                                                          } else if (newAttendance == FALSE) {
                                                                              doesAttendanceRecordExist = FALSE;
                                                                              [parseDotComMgr deleteAttendanceForUser:selectedGuest];
                                                                              
                                                                          }
                                                                          
                                                                      }];
    
    

    
    displayNameReceptionist = [DisplayNameReceptionist receptionistForKeyPath:@"displayName"
                                                                       object:selectedGuest
                                                                        queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                                            
                                                                            NSLog(@"Running DisplayName Receptionist ...");
                                                                            NSString *oldDisplayName = [change objectForKey:NSKeyValueChangeOldKey];
                                                                            NSString *newDisplayName = [change objectForKey:NSKeyValueChangeNewKey] ;
                                                                            NSLog(@"Old DisplayName %@", oldDisplayName);
                                                                            NSLog(@"New DisplayName %@", newDisplayName);
                                                                            
                                                                            if (![newDisplayName isEqualToString:oldDisplayName])
                                                                                [parseDotComMgr updateExistingUser:selectedGuest withClassType:@"Guest"];
                                                                            
                                                                        }];
    
    guestDetailsController.completionBlock = ^(BOOL success)
    {
        if (success)
        {
            // This will cause the table of values to be resorted if necessary.
//            [dataModel clearSortedItems];

           // [self updateTableContentsForSlType:[selectedGuest slType]];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        selectedGuest = nil;
    };
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:guestDetailsController];
    [self presentViewController:navController animated:YES completion:nil];

    
}




- (void)updateTableContentsWithArray:(NSArray *)newGuestAttendeeList forKey:(NSString *)aKey {
    
    [[self guestAttendeeListDict] removeObjectForKey:aKey];
    
    if ([newGuestAttendeeList count] > 0) {
        [[self guestAttendeeListDict] setObject:newGuestAttendeeList forKey:aKey];
    }
    
    [selectedEvent sortSocialNetworkTypes:[self guestAttendeeListDict]];
    [selectedEvent setGuestList:[guestAttendeeListDict rw_flattenIntoArray]];

    
    
    [self.tableView reloadData];
    
    self.guestAttendeeListForSlType = nil;
    
}

//- (void)updateTableContentsWithArray:(NSArray *)newList forKey:(NSString *)aKey {
//    
////    slTypeString = [SocialNetworkUtilities formatTypeToString:slType];   
////    [self setGuestAttendeeListWithSlType:slType];
//  
//    if ([[self guestAttendeeListForSlType] count] > 0) {
//        [[self guestAttendeeListDict] setObject:[self guestAttendeeListForSlType] forKey:slTypeString];
//        
//    }
//
//
//    
//    [selectedEvent sortSocialNetworkTypes:[self guestAttendeeListDict]];
//    [selectedEvent setGuestList:[guestAttendeeListDict rw_flattenIntoArray]];
//    
//    //[self.guestAttendeeListForSlType removeAllObjects];
//    
//    //[popover dismissPopoverAnimated:YES];
//    [self.tableView reloadData];
//    
//}


- (void)createNewGuest {
    NSLog(@"Create new guest!");
    
    selectedGuest = [[User alloc] initWithFirstName:nil lastName:nil];
    [selectedGuest addRole:@"GuestRole"];
    
    QRootElement *root =[[QRootElement alloc] initWithJSONFile:@"guestDetails_NEW"];
    [root bindToObject:(User *)selectedGuest];
    
    
    GuestDetailsDialogController *guestDetailsController = [(GuestDetailsDialogController *)[GuestDetailsDialogController alloc] initWithRoot:root];
    guestDetailsController.userToEdit = selectedGuest;
    
    // Get a Listing of Guest Attendees with no social network connection (i.e. Direct);
    [self setGuestAttendeeListWithSlType:NONE];
    
    __block NSMutableArray *newGuestAttendeeList = [[NSMutableArray alloc] init];
    
    newGuestAttendeeList = (NSMutableArray *)[self guestAttendeeListForSlType];
    NSLog(@"Pre-Block - guestAttendeeListForSlType count: %d", [[self guestAttendeeListForSlType] count]);

    guestDetailsController.completionBlock = ^(BOOL success)
    {
        if (success)
        {
            // This will cause the table of values to be resorted if necessary.
            //            [dataModel clearSortedItems];
            

            
//            NSLog(@"DisplayName: %@", [selectedGuest displayName]);
//            NSLog(@"Name: %@ %@", [selectedGuest firstName], [selectedGuest lastName]);
//            if ([[selectedGuest displayName] isEqualToString:@""])
//                [(User *)selectedGuest setDisplayName:[NSString stringWithFormat: @"%@ %@",[selectedGuest firstName], [selectedGuest lastName]]];
//            
//             NSLog(@"In-BLock Before - guestAttendeeListForSlType count: %d", [newGuestAttendeeList count]);
            // Add a new user to the the guestListAttendeeArray
            if (selectedGuest != nil) {
                [parseDotComMgr createNewUser: selectedGuest withEvent:selectedEvent];
//                [newGuestAttendeeList addObject:selectedGuest];
            }
            

             NSLog(@"In-BLock After - guestAttendeeListForSlType count: %d", [newGuestAttendeeList count]);
            
            [self updateTableContentsWithArray:newGuestAttendeeList forKey:[SocialNetworkUtilities formatTypeToString:NONE]];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
         selectedGuest = nil;
    };
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:guestDetailsController];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didInsertNewUser:(User *) aSelectedUser
               withEvent:(Event *)aSelectedEvent{
    NSLog(@"Success!! We inserted a new user into Parse");
    [parseDotComMgr createNewGuest:aSelectedUser withEvent: aSelectedEvent];
    
    
}

- (void)didInsertNewAttendanceWithUser:(User *)aSelectedUser
                             withEvent:(Event *)aSelectedEvent {
    NSLog(@"Success!! We inserted a new attendance record into Parse");
    
    //    [parseDotComMgr updateExistingMember:aSelectedUser];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tableView reloadData];
}

-(void)didUpdateAttendanceWithUser:(User *)selectedUser withEvent:(Event *)selectedEvent {
    NSLog(@"Success!! We updated an existing attendance record into Parse");
    [self.tableView reloadData];
}


- (void)didDeleteAttendanceForUser:(User *)selectedUser {
    NSLog(@"Success!! We deleted an existing attendance record from Parse: %@", [selectedUser attendanceId]);
    [self.tableView reloadData];
}


- (void)didInsertNewGuest:(User *) aSelectedUser
                 withEvent:(Event *)aSelectedEvent{
    NSLog(@"Success!! We inserted a new guest into Parse");
//    [selectedEvent addGuest:aSelectedUser];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [self.tableView reloadData];
    aSelectedUser = nil;
    selectedGuest = nil;
    //    [parseDotComMgr updateExistingMember:aSelectedUser];
    
}

-(void)didUpdateExistingUser:(User *)selectedUser {
    
    
    NSLog(@"Success!! We updated an existing Member record in Parse");
    [self.tableView reloadData];
    selectedUser = nil;
    selectedGuest = nil;
}


@end

//NSString *GuestListDidSelectGuestNotification = @"GuestListDidSelectGuestNotification";
