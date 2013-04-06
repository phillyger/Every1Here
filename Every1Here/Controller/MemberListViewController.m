//
//  MemberListViewController.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/21/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberListViewController.h"
#import "MemberDetailsDialogController.h"
#import "ParseDotComManager.h"
#import "AnseoObjectConfiguration.h"
#import "MemberListTableDataSource.h"
#import "Event.h"
#import "EventRole.h"
#import "QuickDialog.h"
#import "MBProgressHUD.h"
#import "AttendanceReceptionist.h"
#import "EventRoleReceptionist.h"
#import "DisplayNameReceptionist.h"
#import <objc/runtime.h>

static NSString *memberCellReuseIdentifier = @"memberCell";
//

@interface MemberListViewController ()
{
    Event *selectedEvent;
    User * selectedMember;
    AttendanceReceptionist *attendanceReceptionist;
    EventRoleReceptionist *eventRoleReceptionist;
    DisplayNameReceptionist *displayNameReceptionist;
    MBProgressHUD *hud;
}

@end

@implementation MemberListViewController
@synthesize parseDotComMgr;
@synthesize tableView;
@synthesize dataSource;
@synthesize objectConfiguration;

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
//    NSString *EventListTableDidSelectEventNotification = @"EventListTableDidSelectEventNotification";
//    UINavigationController *navigationController = [self navigationController];
    
//    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(Back:)];
    UIBarButtonItem *closeViewBttnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
    UIBarButtonItem *addNewMemberBttnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewMember)];
//    [self.navigationController setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem: closeViewBttnItem];
    [self.navigationItem setRightBarButtonItem: addNewMemberBttnItem];
    
//    [customItem release];
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(userDidSelectMemberListNotification:)
     name: MemberListDidSelectMemberNotification
     object: nil];
    
//    NSNotification *note = [NSNotification notificationWithName: @"EventListTableDidSelectEventNotification" object:self];
//    Event *selectedEvent = (Event *)[sender object];
    
//    self.objectConfiguration = [[AnseoObjectConfiguration alloc] init];
//    MemberListTableDataSource *eventDataSource = [[MemberListTableDataSource alloc] init];
//    
//    
//    self.dataSource = eventDataSource;
    
    
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    
    UINib *memberCellNib = [UINib nibWithNibName:@"MemberSummaryCell" bundle:nil];
    [self.tableView registerNib:memberCellNib
         forCellReuseIdentifier:memberCellReuseIdentifier];
    
    
    objc_property_t tableViewProperty = class_getProperty([dataSource class], "tableView");
    if (tableViewProperty) {
        [dataSource setValue: tableView forKey: @"tableView"];
    }
   
    

    if ([self.dataSource isKindOfClass: [MemberListTableDataSource class]]) {
        [self fetchMemberListTableContent];
        //        [(EventListTableDataSource *)self.dataSource setAvatarStore: [objectConfiguration avatarStore]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {

    
}

- (void)viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self name:MemberListDidSelectMemberNotification object:nil];
    


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didReceiveMembers:(NSArray *)members {
    Event *event = ((MemberListTableDataSource *)self.dataSource).event;
    for (User *thisUser in members) {
        [event addMember:thisUser];
    }

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tableView reloadData];
}

- (void)membersReceivedForEvent:(Event *)event {
    
}

- (void)closeView {
    selectedEvent = nil;
    selectedMember = nil;
    //    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    [self dismissModalViewControllerAnimated:YES];
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
    self.parseDotComMgr.memberDelegate = self;
    self.parseDotComMgr.parseDotComDelegate = self;
    selectedEvent = (Event *)[(MemberListTableDataSource *)self.dataSource event];
    [self.parseDotComMgr fetchMembersForEvent:selectedEvent];
}

- (void)retrievingMembersFailedWithError:(NSError *)error {
    
}


//
//- (void)registerAsObserver {
//    /*
//     Register 'inspector' to receive change notifications for the "attendance" property of
//     the 'user' object and specify that both the old and new values of "attendance"
//     should be provided in the observe… method.
//     */
//    [account addObserver:inspector
//              forKeyPath:@"attendance"
//                 options:(NSKeyValueObservingOptionNew |
//                          NSKeyValueObservingOptionOld)
//                 context:NULL];
//}



#pragma mark - Notification handling
- (void)userDidSelectMemberListNotification:(NSNotification *)note {
    
    __block BOOL doesAttendanceRecordExist = FALSE;
    
    selectedMember = (User *)[note object];
    QRootElement *root =[[QRootElement alloc] initWithJSONFile:@"memberDetails_EDIT"];
    [root bindToObject:(User *)selectedMember];
    
    
    MemberDetailsDialogController *memberDetailsController = [(MemberDetailsDialogController *)[MemberDetailsDialogController alloc] initWithRoot:root];
    memberDetailsController.userToEdit = selectedMember;
    
    memberDetailsController.newUser = FALSE;
    
    
    EventRole *eventRoleModel = [selectedMember getRole:@"EventRole"];
    NSOperationQueue* aQueue = [NSOperationQueue mainQueue];  // Question: Can these updates to attendance and event roles be handled by secondary thread.

    
    eventRoleReceptionist = [EventRoleReceptionist receptionistForKeyPath:@"eventRoles"
                                                  object:eventRoleModel
                                                   queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                       
                                                       NSLog(@"Running EventRole Receptionist ...");
                                                       NSUInteger oldEventRole = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
                                                       NSUInteger newEventRole = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
                                                       //                                                                 NSLog(@"oldEventRole %d", oldEventRole);
                                                       //                                                                 NSLog(@"newEventRole %d", newEventRole);
                                                       if (doesAttendanceRecordExist)
                                                           if (oldEventRole != newEventRole)
                                                               [parseDotComMgr updateAttendanceWithUser:    selectedMember withEvent: selectedEvent];
                                                       
                                                   }];
    

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
                                                                [parseDotComMgr createNewAttendanceWithUser:selectedMember withEvent: selectedEvent];
                                                    
                                                            } else if (newAttendance == FALSE) {
                                                                doesAttendanceRecordExist = FALSE;
                                                                [parseDotComMgr deleteAttendanceForUser:selectedMember];

                                                            }
                                                            
                                                        }];
    
    
    displayNameReceptionist = [DisplayNameReceptionist receptionistForKeyPath:@"displayName"
                                                           object:selectedMember
                                                            queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                                
                                                                NSLog(@"Running DisplayName Receptionist ...");
                                                                NSString *oldDisplayName = [change objectForKey:NSKeyValueChangeOldKey];
                                                                NSString *newDisplayName = [change objectForKey:NSKeyValueChangeNewKey] ;
                                                                NSLog(@"Old DisplayName %@", oldDisplayName);
                                                                NSLog(@"New DisplayName %@", newDisplayName);
                                                            
                                                                if (![newDisplayName isEqualToString:oldDisplayName])
                                                                    [parseDotComMgr updateExistingUser:selectedMember withClassType:@"Member"];
                                                                
                                                            }];
    
    
    memberDetailsController.completionBlock = ^(BOOL success)
    {
        if (success)
        {

            
            [eventRoleModel removeObserver:attendanceReceptionist forKeyPath:@"attendance"];
            [eventRoleModel removeObserver:eventRoleReceptionist forKeyPath:@"eventRoles"];
            [selectedMember removeObserver:displayNameReceptionist forKeyPath:@"displayName"];
            
            // This will cause the table of values to be resorted if necessary.
            //            [dataModel clearSortedItems];
            
            // [self updateTableContentsForSlType:[selectedGuest slType]];
            
//            if (![selectedMember userId]) {
//                [parseDotComMgr createNewUser:selectedMember withEvent: selectedEvent];
//            } else if (![[selectedMember getRole:@"EventRole"] isAttending]) {
//                [parseDotComMgr deleteAttendanceForUser:selectedMember];
//            }
//            else if (![selectedMember attendanceId]){
//                [parseDotComMgr createNewAttendanceWithUser:selectedMember withEvent: selectedEvent];
//            }
//            else {
//                [parseDotComMgr updateAttendanceWithUser:selectedMember withEvent: selectedEvent];
//            }
            
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:memberDetailsController];
    [self presentViewController:navController animated:YES completion:nil];
    
    
}



- (void)addNewMember {
    
    selectedMember = [[User alloc] init];
    selectedEvent = (Event *)[(MemberListTableDataSource *)self.dataSource event];
    QRootElement *root =[[QRootElement alloc] initWithJSONFile:@"memberDetails_NEW"];
//    [root bindToObject:selectedMember];
    
    
    MemberDetailsDialogController *memberDetailsController = [(MemberDetailsDialogController *)[MemberDetailsDialogController alloc] initWithRoot:root];
    memberDetailsController.userToEdit = selectedMember;
    memberDetailsController.newUser = TRUE;
    
    memberDetailsController.completionBlock = ^(BOOL success)
    {
        if (success)
        {

            hud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:hud];
            hud.dimBackground = YES;
            // Regiser for HUD callbacks so we can remove it from the window at the right time
            hud.labelText = @"Loading..";
            [hud show:TRUE];
            
            
            // [self updateTableContentsForSlType:[selectedGuest slType]];
            NSLog(@"Welcome back from dialog");
            NSLog(@"User: %@", [selectedMember displayName] );
            [parseDotComMgr createNewUser: selectedMember withEvent:selectedEvent];
           
            

//            [self.tableView reloadData];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];

        selectedMember = nil;
    };
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:memberDetailsController];
    [self presentViewController:navController animated:YES completion:nil];
    
}


- (void)didInsertNewUser:(User *) aSelectedUser
                 withEvent:(Event *)aSelectedEvent{
    NSLog(@"Success!! We inserted a new user into Parse");
    [parseDotComMgr createNewMember:aSelectedUser withEvent: aSelectedEvent];

    
}

- (void)didInsertNewMember:(User *) aSelectedUser
                 withEvent:(Event *)aSelectedEvent{
    NSLog(@"Success!! We inserted a new member into Parse");
    [selectedEvent addMember:aSelectedUser];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView reloadData];
    selectedMember = nil;
//    [parseDotComMgr updateExistingMember:aSelectedUser];
    
}

- (void)didInsertNewAttendanceWithUser:(User *)aSelectedUser
                             withEvent:(Event *)aSelectedEvent {
    NSLog(@"Success!! We inserted a new attendance record into Parse"); 
    
//    [parseDotComMgr updateExistingMember:aSelectedUser];

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tableView reloadData];
}

-(void)didUpdateExistingUser:(User *)selectedUser {
    

    NSLog(@"Success!! We updated an existing Member record in Parse");
    [self.tableView reloadData];
    selectedUser = nil;
    selectedMember = nil;
}


-(void)didUpdateAttendanceWithUser:(User *)selectedUser withEvent:(Event *)selectedEvent {
     NSLog(@"Success!! We updated an existing attendance record into Parse");
    [self.tableView reloadData];
}


- (void)didDeleteAttendanceForUser:(User *)selectedUser {
    NSLog(@"Success!! We deleted an existing attendance record from Parse: %@", [selectedUser attendanceId]);
    [self.tableView reloadData];
}

@end

