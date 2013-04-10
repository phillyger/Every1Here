//
//  MemberListViewController.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/21/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberListViewController.h"
#import "MemberDetailsDialogController.h"
#import "ParseDotComManager.h"
#import "E1HObjectConfiguration.h"
#import "MemberListTableDataSource.h"
#import "Event.h"
#import "EventRole.h"
#import "QuickDialog.h"
#import "MBProgressHUD.h"
#import "AttendanceReceptionist.h"
#import "EventRoleReceptionist.h"
#import "DisplayNameReceptionist.h"
#import "Receptionist.h"
#import "E1HOperationFactory.h"
#import "E1HRESTApiOperationFactory.h"
#import "AttendanceBuilder.h"
#import "Attendance.h"
#import "RESTApiOperation.h"
#import "CommonUtilities.h"

#import <objc/runtime.h>

static NSString *memberCellReuseIdentifier = @"memberCell";
//

@interface MemberListViewController ()
{
    Event *selectedEvent;
    User * selectedMember;
//    AttendanceReceptionist *attendanceReceptionist;
//    EventRoleReceptionist *eventRoleReceptionist;
//    DisplayNameReceptionist *displayNameReceptionist;
    Receptionist *attendanceReceptionist;
    Receptionist *eventRoleReceptionist;
    Receptionist *displayNameReceptionist;
    Receptionist *guestCountReceptionist;
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
    UIBarButtonItem *closeViewBttnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
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




#pragma mark - Notification handling
- (void)userDidSelectMemberListNotification:(NSNotification *)note {
    
    __block BOOL doesAttendanceRecordExist = FALSE;
    
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    selectedMember = (User *)[note object];
    QRootElement *root =[[QRootElement alloc] initWithJSONFile:@"memberDetails_EDIT"];
    [root bindToObject:(User *)selectedMember];
    
    
    MemberDetailsDialogController *memberDetailsController = [(MemberDetailsDialogController *)[MemberDetailsDialogController alloc] initWithRoot:root];
    memberDetailsController.userToEdit = selectedMember;
    
    memberDetailsController.newUser = NO;
    
    
    NSOperationQueue* aQueue = [NSOperationQueue mainQueue];  // Question: Can these updates to attendance and event roles be handled by secondary thread.

    
    eventRoleReceptionist = [Receptionist receptionistForKeyPath:@"roles.EventRole.eventRoles"
                                                  object:selectedMember
                                                   queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                       
                                                       NSString *className = @"Attendance";
                                                       NSLog(@"Running EventRole Receptionist ...");
                                                       NSUInteger oldEventRole = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
                                                       NSUInteger newEventRole = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
                                                       NSLog(@"oldEventRole %d", oldEventRole);
                                                       NSLog(@"newEventRole %d", newEventRole);
                                                       if (doesAttendanceRecordExist)
                                                           if (oldEventRole != newEventRole) {
                                                               id updateOp= [E1HOperationFactory create:Update];
                                                               RESTApiOperation *op = [updateOp createOperationWithObj:selectedMember forClassName:className withKey:@"attendanceId"];
                                                               [operations addObject:op];
                                                               [parseDotComMgr execute:operations forActionType:Update forClassName:className];

                                                           }
                                                       
                                                   }];
    

    attendanceReceptionist = [Receptionist receptionistForKeyPath:@"roles.EventRole.attendance"
                                                       object:selectedMember
                                                        queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                            
                                                            NSString *className = @"Attendance";
                                                            
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
                   
                                                                NSDictionary *parameters = [CommonUtilities generateValueDictWithObject:selectedMember forClassName:className];

                                                                id insertOp= [E1HOperationFactory create:Insert];
                                                                RESTApiOperation *op = [insertOp createOperationWithDict:parameters forClassName:className];
                                                                [operations addObject:op];
                                                                [parseDotComMgr execute:operations forActionType:Insert forClassName:className];
                                                    
                                                            } else if (newAttendance == FALSE) {
                                                                doesAttendanceRecordExist = FALSE;

                                                                id deleteOp= [E1HOperationFactory create:Delete];
                                                                RESTApiOperation *op = [deleteOp createOperationWithId:[selectedMember valueForKeyPath:@"attendanceId"] forClassName:className];
                                                                [operations addObject:op];
                                                                [parseDotComMgr execute:operations forActionType:Delete forClassName:className];
                                                                
                                                                [parseDotComMgr deleteAttendanceForUser:selectedMember];

                                                            }
                                                            
                                                        }];
    
    
    displayNameReceptionist = [Receptionist receptionistForKeyPath:@"displayName"
                                                           object:selectedMember
                                                            queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                                
                                                                NSString *className = @"Member";
                                                                
                                                                NSLog(@"Running DisplayName Receptionist ...");
                                                                NSString *oldDisplayName = [change objectForKey:NSKeyValueChangeOldKey];
                                                                NSString *newDisplayName = [change objectForKey:NSKeyValueChangeNewKey] ;
                                                                NSLog(@"Old DisplayName %@", oldDisplayName);
                                                                NSLog(@"New DisplayName %@", newDisplayName);
                                                            
                                                                if (![newDisplayName isEqualToString:oldDisplayName]) {
                                                                    id updateOp= [E1HOperationFactory create:Update];
                                                                    RESTApiOperation *op = [updateOp createOperationWithObj:selectedMember forClassName:className withKey:@"objectId"];
                                                                    [operations addObject:op];
                                                                    [parseDotComMgr execute:operations forActionType:Update forClassName:className];
                                                                    
                                                                }
                                                                
                                                            }];
    

    guestCountReceptionist = [Receptionist receptionistForKeyPath:@"roles.EventRole.guestCount"
                                                                       object:selectedMember
                                                                        queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                                            
                                                                            NSString *className = @"Attendance";
                                                                            
                                                                            NSLog(@"Running guestCountReceptionist Receptionist ...");
                                                                            NSUInteger oldGuestCount = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
                                                                            NSUInteger newGuestCount = [[change objectForKey:NSKeyValueChangeNewKey] intValue] ;
                                                                            NSLog(@"Old Guest Count %d", oldGuestCount);
                                                                            NSLog(@"New Guest Count %d", newGuestCount);
                                                                            
                                                                            if (newGuestCount != oldGuestCount ) {
                                                                                id updateOp= [E1HOperationFactory create:Update];
                                                                                RESTApiOperation *op = [updateOp createOperationWithObj:selectedMember forClassName:className withKey:@"attendanceId"];
                                                                                [operations addObject:op];
                                                                                [parseDotComMgr execute:operations forActionType:Update forClassName:className];
                                                                            }
                                                                                
                                                                            
                                                                        }];
    
    
    memberDetailsController.completionBlock = ^(BOOL success)
    {
        if (success)
        {

            
            [selectedMember removeObserver:attendanceReceptionist forKeyPath:@"roles.EventRole.attendance"];
            [selectedMember removeObserver:eventRoleReceptionist forKeyPath:@"roles.EventRole.eventRoles"];
            [selectedMember removeObserver:displayNameReceptionist forKeyPath:@"displayName"];
            [selectedMember removeObserver:guestCountReceptionist forKeyPath:@"roles.EventRole.guestCount"];
            
            
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
    memberDetailsController.newUser = YES;
    
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
            
            

            NSLog(@"User: %@", [selectedMember displayName] );
            

            NSMutableString *className = [[NSMutableString alloc] init];
            
            className = [@"Member" mutableCopy];
            NSDictionary *parameters = [CommonUtilities generateValueDictWithObject:selectedMember forClassName:className];
            NSLog(@"%@", parameters);
            NSMutableArray *operations = [[NSMutableArray alloc] init];
            
            id insertOp1= [E1HOperationFactory create:Insert];
            RESTApiOperation *op1 = [insertOp1 createOperationWithDict:parameters forClassName:className];
            [operations addObject:op1];
            
            className = [@"User" mutableCopy];
            parameters = [CommonUtilities generateValueDictWithObject:selectedMember forClassName:className];
            NSLog(@"%@", parameters);
            id insertOp2= [E1HOperationFactory create:Insert];
            RESTApiOperation *op2 = [insertOp2 createOperationWithDict:parameters forClassName:className];
            [operations addObject:op2];
//
            [parseDotComMgr execute:operations forActionType:Insert forClassName:className];
           
//            [parseDotComMgr createNewMember:selectedMember withEvent:selectedEvent];

        }
        
        [self dismissViewControllerAnimated:YES completion:nil];

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

- (void)didExecuteOps:(NSArray *)objectNotationList forActionType:(ActionTypes)actionType forClassName:(NSString *)className {
    
    switch (actionType) {
        case Insert:
            NSLog(@"Success!! We inserted a new %@ record into Parse", className);
            if ([className isEqualToString:@"User"] || [className isEqualToString:@"Member"] ) {
                NSLog(@"%@", objectNotationList);
                
                // TODO: Need to find a better pattern for extracting values from enqueued operations. Sequence here needs to
                // ensure that
                // a) the Member op os first and
                // b) the User op is second
                [objectNotationList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if (idx == 0)
                        [selectedMember setValue:[obj valueForKey:@"objectId"] forKeyPath:@"objectId"];     // Member op
                    if (idx == 1)
                        [selectedMember setValue:[obj valueForKey:@"objectId"] forKeyPath:@"userId"];   // User op
                }];
                
                
                className = [@"Member" mutableCopy];
                NSMutableArray *operations = [[NSMutableArray alloc] init];                
                id updateOp= [E1HOperationFactory create:Update];
                RESTApiOperation *op = [updateOp createOperationWithObj:selectedMember forClassName:className withKey:@"objectId"];
                [operations addObject:op];
                [parseDotComMgr execute:operations forActionType:Update forClassName:className];
            }
            break;
        case Update:
            NSLog(@"Success!! We updated an existing %@ record in Parse", className);
            break;
        case Delete:
            NSLog(@"Success!! We deleted an existing %@ record from Parse", className);
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   
    
}

@end

