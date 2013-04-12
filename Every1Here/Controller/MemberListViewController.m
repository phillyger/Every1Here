//
//  MemberListViewController.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/21/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberListViewController.h"
#import "MemberDetailsDialogController.h"
#import "MemberListTableDataSource.h"
#import "ParseDotComManager.h"
#import "Event.h"
#import "QuickDialog.h"
#import "Receptionist.h"
#import "CommonUtilities.h"
#import "AFHTTPRequestOperation.h"
#import "E1HObjectConfiguration.h"

#import <objc/runtime.h>

static NSString *memberCellReuseIdentifier = @"memberCell";


@interface MemberListViewController ()
{
    Event *selectedEvent;
    User * selectedMember;
    Receptionist *attendanceReceptionist;
    Receptionist *eventRoleReceptionist;
    Receptionist *displayNameReceptionist;
    Receptionist *guestCountReceptionist;

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


    UIBarButtonItem *dismissBttnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    UIBarButtonItem *addNewMemberBttnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewMember)];

    [self.navigationItem setLeftBarButtonItem: dismissBttnItem];
    [self.navigationItem setRightBarButtonItem: addNewMemberBttnItem];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(userDidSelectMemberListNotification:)
     name: MemberListDidSelectMemberNotification
     object: nil];
    
    
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

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dismiss {
    selectedEvent = nil;
    selectedMember = nil;
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchMemberListTableContent
{
    [CommonUtilities showProgressHUD:self.view];
    
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.parseDotComDelegate = self;
    selectedEvent = (Event *)[(MemberListTableDataSource *)self.dataSource event];
    [self.parseDotComMgr fetchUsersForEvent:selectedEvent withUserType:Member];
}

- (void)retrievingMembersFailedWithError:(NSError *)error {
    
}




#pragma mark - Notification handling
- (void)userDidSelectMemberListNotification:(NSNotification *)note {
    
    __block BOOL doesAttendanceRecordExist = FALSE;
    
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
                                                       
                                                       NSLog(@"Running EventRole Receptionist ...");
                                                       NSUInteger oldEventRole = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
                                                       NSUInteger newEventRole = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
                                                       NSLog(@"oldEventRole %d", oldEventRole);
                                                       NSLog(@"newEventRole %d", newEventRole);
                                                       if (doesAttendanceRecordExist)
                                                           if (oldEventRole != newEventRole) {

                                                               [parseDotComMgr updateAttendanceForUser:selectedMember];

                                                           }
                                                       
                                                   }];
    

    attendanceReceptionist = [Receptionist receptionistForKeyPath:@"roles.EventRole.attendance"
                                                       object:selectedMember
                                                        queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                    
                                                            
                                                            NSLog(@"Running Attendance Receptionist ...");
                                                            BOOL oldAttendance = [[change objectForKey:NSKeyValueChangeOldKey] boolValue];
                                                            BOOL newAttendance = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];

                                                            
                                                            if (newAttendance == oldAttendance) {
                                                                //do nothing
                                                                doesAttendanceRecordExist = TRUE;
                                                            } else if (newAttendance == TRUE) {
                                                                doesAttendanceRecordExist = FALSE;

                                                                [parseDotComMgr insertAttendanceForUser:selectedMember];
                                                                
                                                    
                                                            } else if (newAttendance == FALSE) {
                                                                doesAttendanceRecordExist = FALSE;

                                                                [parseDotComMgr deleteAttendanceForUser:selectedMember];

                                                            }
                                                            
                                                        }];
    
    
    displayNameReceptionist = [Receptionist receptionistForKeyPath:@"displayName"
                                                           object:selectedMember
                                                            queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                                
                                                                
                                                                NSLog(@"Running DisplayName Receptionist ...");
                                                                NSString *oldDisplayName = [change objectForKey:NSKeyValueChangeOldKey];
                                                                NSString *newDisplayName = [change objectForKey:NSKeyValueChangeNewKey] ;
                                                            
                                                                if (![newDisplayName isEqualToString:oldDisplayName]) {

                                                                    
                                                                    [parseDotComMgr updateUser:selectedMember withUserType:Member];
                                                                    
                                                                }
                                                                
                                                            }];
    

    guestCountReceptionist = [Receptionist receptionistForKeyPath:@"roles.EventRole.guestCount"
                                                                       object:selectedMember
                                                                        queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                                            
                                                                            if (doesAttendanceRecordExist == TRUE) {
                                                                                
                                                                                NSLog(@"Running guestCountReceptionist Receptionist ...");
                                                                                NSUInteger oldGuestCount = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
                                                                                NSUInteger newGuestCount = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
                                                                                
                                                                                if (newGuestCount != oldGuestCount ) {
                                                                                    
                                                                                    [parseDotComMgr updateAttendanceForUser:selectedMember];

                                                                                }
                                                                            }
                                                                            
                                                                            
                                                                        }];
    
    
    memberDetailsController.completionBlock = ^(BOOL success)
    {
        if (success)
        {
            [CommonUtilities showProgressHUD:self.view];
            
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

    MemberDetailsDialogController *memberDetailsController = [(MemberDetailsDialogController *)[MemberDetailsDialogController alloc] initWithRoot:root];
    memberDetailsController.userToEdit = selectedMember;
    memberDetailsController.newUser = YES;
    
    memberDetailsController.completionBlock = ^(BOOL success)
    {
        if (success)
        {

            [CommonUtilities showProgressHUD:self.view];    
            [parseDotComMgr insertUser:selectedMember withUserType:Member];

        }
        
        [self dismissViewControllerAnimated:YES completion:nil];

    };
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:memberDetailsController];
    [self presentViewController:navController animated:YES completion:nil];
    
}


-(void)didUpdateUserForUserType:(UserTypes)userType {
    NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];
     NSLog(@"Success!! We updated the %@ record in Parse", namedClass);
}


- (void)didInsertUserForUserType:(UserTypes)userType withOutput:(NSArray *)objectNotationList{
    
    /* TODO: Need to find a better pattern for extracting values from enqueued operations. 
     * Sequence here needs to ensure that
    * 
    * a) the Member op is always first returned
    * b) the User op is second
    */
    
    [objectNotationList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0)
            [selectedMember setValue:[obj valueForKey:@"objectId"] forKeyPath:@"objectId"];     // Member op
        if (idx == 1)
            [selectedMember setValue:[obj valueForKey:@"objectId"] forKeyPath:@"userId"];   // User op
    }];
    
    [selectedMember setValue:[selectedEvent valueForKey:@"objectId"] forKeyPath:@"eventId"];    // set member with eventId
    
    [parseDotComMgr updateUser:selectedMember withUserType:Member];
    
}



- (void)didFetchUsers:(NSArray *)userList forUserType:(UserTypes)userType  {
    NSLog(@"Success!! We updated an existing %d record in Parse", userType);
   
    
    for (User *thisUser in userList) {
        [selectedEvent addMember:thisUser];
    }
    
    
    [self.tableView reloadData];
    [CommonUtilities hideProgressHUD:self.view];
}

- (void)didUpdateAttendance {
    NSLog(@"Success!! We updated Attendance record in Parse");

    [self.tableView reloadData];
    [CommonUtilities hideProgressHUD:self.view];

}

- (void)didDeleteAttendance {
    NSLog(@"Success!! We deleted an existing Attendance record from Parse");

    
    [self.tableView reloadData];
    [CommonUtilities hideProgressHUD:self.view];
}

- (void)didInsertAttendanceWithOutput:(NSArray *)objectNotationList {
    NSLog(@"Success!! We inserted a new Attendance record into Parse");
    
    // Expecting a single value returned after new Attendance Record Insert.
    // objectNotationList is an array containing a single object.
    // Update Member object with Attendance Id value.
    
    [objectNotationList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *ro = obj;
        NSData *jsonData = [ro responseData];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:jsonData
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
    [selectedMember setAttendanceId:[jsonObject valueForKey:@"objectId"]];
    }];
    
    [self.tableView reloadData];
    [CommonUtilities hideProgressHUD:self.view];
}



- (void)didExecuteOps:(NSArray *)objectNotationList forActionType:(ActionTypes)actionType forNamedClass:(NSString *)namedClass {
    

}

- (void)executedOpsFailedWithError:(NSError *)error
                     forActionType:(ActionTypes) actionType
                     forNamedClass:(NSString *)namedClass {}


@end

