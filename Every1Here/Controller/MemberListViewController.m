/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  MemberListViewController.h
 *  Every1Here
 *
 *  Created by Ger O'Sullivan on 2/21/13.
 *  Copyright (c) 2013 Brilliant Age. All rights reserved.
 *
 *  Handles the Member table list view.
 *
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface MemberListViewController ()
{
    //-------------------------------------------------------
    // member and event of current selection.
    //-------------------------------------------------------
    Event *selectedEvent;
    User * selectedMember;
    
    //-------------------------------------------------------
    // Uses a KVO Receptionist Pattern to manage input form handling for fields:
    // - Attendance
    // - Event Roles
    // - Guest Count
    // - Display Name
    //-------------------------------------------------------
    Receptionist *attendanceReceptionist;
    Receptionist *eventRoleReceptionist;
    Receptionist *displayNameReceptionist;
    Receptionist *guestCountReceptionist;
    
    //-------------------------------------------------------
    // Dicitionary for holding the values of Quick Dialog
    // form names.
    //-------------------------------------------------------
    NSDictionary *pListInfoDictForE1HQuickDialog;
    
    //-------------------------------------------------------
    // Queue for receptionist instances.
    //-------------------------------------------------------
    NSOperationQueue *aQueue;
    
}

@end

@implementation MemberListViewController
//-------------------------------------------------------
// Ivars inherited from BaseViewController.
//-------------------------------------------------------
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

    
    NSString *backArrowString = @"\U000025C0\U0000FE0E"; //BLACK LEFT-POINTING TRIANGLE PLUS VARIATION SELECTOR
    
    UIBarButtonItem *dismissBttnItem = [[UIBarButtonItem alloc] initWithTitle:backArrowString style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
//    self.navigationItem.leftButtonItem = backBarButtonItem;

//    UIBarButtonItem *dismissBttnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    UIBarButtonItem *addNewMemberBttnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewMember)];

    [self.navigationItem setLeftBarButtonItem: dismissBttnItem];
    [self.navigationItem setRightBarButtonItem: addNewMemberBttnItem];

    //-------------------------------------------------------
    // Load the Quick Dialog form names mapping.
    //-------------------------------------------------------
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:@"E1H_QuickDialog_FileNames" ofType:@"plist"];
    pListInfoDictForE1HQuickDialog = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    
    
    //-------------------------------------------------------
    // Register member summary cell used in table data source.
    //-------------------------------------------------------
    UINib *memberCellNib = [UINib nibWithNibName:@"MemberSummaryCell" bundle:nil];
    [self.tableView registerNib:memberCellNib
         forCellReuseIdentifier:memberCellReuseIdentifier];
    
    //-------------------------------------------------------
    // Register member summary cell used in table data source.
    //-------------------------------------------------------
    aQueue = [NSOperationQueue mainQueue];  // Question: Can these updates to attendance and event roles be handled by secondary thread.
    
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    
    objc_property_t tableViewProperty = class_getProperty([dataSource class], "tableView");
    if (tableViewProperty) {
        [dataSource setValue: tableView forKey: @"tableView"];
    }


    if ([self.dataSource isKindOfClass: [MemberListTableDataSource class]]) {
        [self fetchMemberListTableContent];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {

    //-------------------------------------------------------
    // Register notification when user selects a member.
    //-------------------------------------------------------
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(userDidSelectMemberListNotification:)
     name: MemberListDidSelectMemberNotification
     object: nil];
    
    [CommonUtilities showProgressHUD:self.view];
    
}

- (void)viewDidAppear:(BOOL)animated {
    //-------------------------------------------------------
    // Hide progress HUD when view displays.
    //-------------------------------------------------------
    [CommonUtilities hideProgressHUD:self.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    //-------------------------------------------------------
    // Remove notification for member selection.
    //-------------------------------------------------------
    [[NSNotificationCenter defaultCenter]
     removeObserver: self name: MemberListDidSelectMemberNotification object: nil];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*---------------------------------------------------------------------------
 * Target-Action method for 'Done' button.
 * Dismisses the current view controller.
 *--------------------------------------------------------------------------*/
- (void)dismiss {
    selectedEvent = nil;
    selectedMember = nil;
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}


/*---------------------------------------------------------------------------
 * Target-Action method for 'Done' button.
 * Dismisses the current view controller.
 *--------------------------------------------------------------------------*/
- (void)fetchMemberListTableContent
{
    
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.parseDotComDelegate = self;
    selectedEvent = (Event *)[(MemberListTableDataSource *)self.dataSource event];
    [self.parseDotComMgr fetchUsersForEvent:selectedEvent withUserType:Member];
}



#pragma mark - Notification handling

/*---------------------------------------------------------------------------
 * Handles member selection in table view. Implements four(4) KVO receptionist
 * pattern methods to handle insert/updates/edits to the selected member fields
 * - Attendance
 * - Event Roles
 * - Guest Count
 * - Display Name
 *
 * A completion block is used to remove the KVO on form close and dismiss the 
 * child controller.
 *--------------------------------------------------------------------------*/

- (void)userDidSelectMemberListNotification:(NSNotification *)note {
    

    //-------------------------------------------------------
    // The current member selected.
    //-------------------------------------------------------
    selectedMember = (User *)[note object];
    
    //-------------------------------------------------------
    // QuickDialog :: Reads the JSON file to structure the
    // member form. The form name is loads from plist.
    //-------------------------------------------------------
    QRootElement *root =[[QRootElement alloc] initWithJSONFile:[pListInfoDictForE1HQuickDialog valueForKey:@"member_details_edit"]];
    [root bindToObject:(User *)selectedMember];
    
    
    //-------------------------------------------------------
    // Initialize the destination controller with the
    // Quick Dialog root object. Assign the Ivars for
    // - userToEdit
    // - newUser
    // in destination controller
    //-------------------------------------------------------
    MemberDetailsDialogController *memberDetailsController = [(MemberDetailsDialogController *)[MemberDetailsDialogController alloc] initWithRoot:root];
    memberDetailsController.userToEdit = selectedMember;
    memberDetailsController.newUser = NO;

    //-------------------------------------------------------
    // Check to see if Attendance Id field has been set on
    // selected member .
    //-------------------------------------------------------
     __block BOOL doesAttendanceRecordExist = [selectedMember attendanceId]!=nil ? TRUE : FALSE;
    
    //-------------------------------------------------------
    // KVO Receptionist pattern for handling changes to
    // eventRoles field.
    //-------------------------------------------------------
    eventRoleReceptionist = [Receptionist receptionistForKeyPath:@"roles.EventRole.eventRoles"
                                                  object:selectedMember
                                                   queue:aQueue task:^(NSString *keyPath, id object, NSDictionary *change) {
                                                       
                                                       NSUInteger oldEventRole = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
                                                       NSUInteger newEventRole = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
  
                                                       if (doesAttendanceRecordExist)
                                                           if (oldEventRole != newEventRole) {

                                                               [parseDotComMgr updateAttendanceForUser:selectedMember];

                                                           }
                                                       
                                                   }];
    
    //-------------------------------------------------------
    // KVO Receptionist pattern for handling changes to
    // attendance field.
    //-------------------------------------------------------
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
    
    //-------------------------------------------------------
    // KVO Receptionist pattern for handling changes to
    // displayName field.
    //-------------------------------------------------------
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
    
    //-------------------------------------------------------
    // KVO Receptionist pattern for handling changes to
    // guestCount field.
    //-------------------------------------------------------
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
    
    
    //-------------------------------------------------------
    // On completion, ensure to remove KVO observers.
    //-------------------------------------------------------
    memberDetailsController.completionBlock = ^(BOOL success)
    {
  
        [selectedMember removeObserver:attendanceReceptionist forKeyPath:@"roles.EventRole.attendance"];
        [selectedMember removeObserver:eventRoleReceptionist forKeyPath:@"roles.EventRole.eventRoles"];
        [selectedMember removeObserver:displayNameReceptionist forKeyPath:@"displayName"];
        [selectedMember removeObserver:guestCountReceptionist forKeyPath:@"roles.EventRole.guestCount"];

        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:memberDetailsController];
    [self presentViewController:navController animated:YES completion:nil];
    
    
}


/*---------------------------------------------------------------------------
 * Handles the creation of a new member 
 *--------------------------------------------------------------------------*/
- (void)addNewMember {
    
    
    //-------------------------------------------------------
    // Create a new selected member instance.
    //-------------------------------------------------------
    selectedMember = [[User alloc] init];
    
    //-------------------------------------------------------
    // QuickDialog :: Reads the JSON file to structure the
    // member form. The form name is loads from plist.
    //-------------------------------------------------------
    QRootElement *root =[[QRootElement alloc] initWithJSONFile:[pListInfoDictForE1HQuickDialog valueForKey:@"member_details_new"]];
    

    //-------------------------------------------------------
    // Initialize the destination controller with the
    // Quick Dialog root object. Assign the Ivars for
    // - userToEdit
    // - newUser
    // in destination controller
    //-------------------------------------------------------
    MemberDetailsDialogController *memberDetailsController = [(MemberDetailsDialogController *)[MemberDetailsDialogController alloc] initWithRoot:root];
    memberDetailsController.userToEdit = selectedMember;
    memberDetailsController.newUser = YES;
    
    
    //-------------------------------------------------------
    // On completion, if form content has changed, insert
    // new user,
    //-------------------------------------------------------
    memberDetailsController.completionBlock = ^(BOOL success)
    {
        if (success)
        {

            [CommonUtilities showProgressHUD:self.view];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // insert a new user.
                [parseDotComMgr insertUser:selectedMember withUserType:Member];
                [selectedEvent addMember:selectedMember];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CommonUtilities hideProgressHUD:self.view];

                });
            });
            

        }
        
        [self dismissViewControllerAnimated:YES completion:nil];

    };
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:memberDetailsController];
    
    
    [self presentViewController:navController animated:YES completion:nil];
    
}



/*---------------------------------------------------------------------------
 * Delegation callback for updates of an existing member
 *--------------------------------------------------------------------------*/
-(void)didUpdateUserForUserType:(UserTypes)userType {
    NSString *namedClass = [CommonUtilities convertUserTypeToNamedClass:userType];
     NSLog(@"Success!! We updated the %@ record in Parse", namedClass);
    [self.tableView reloadData];
    
}


/*---------------------------------------------------------------------------
 * Delegation callback for insert of a new member
 *--------------------------------------------------------------------------*/
- (void)didInsertUserForUserType:(UserTypes)userType withOutput:(NSArray *)objectNotationList{
    
    /* TODO: Need to find a better pattern for extracting values from enqueued operations. 
     * Sequence here needs to ensure that
    * 
    * a) the Member op is always first returned
    * b) the User op is second
    */
    
    [objectNotationList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *ro = obj;
        NSData *jsonData = [ro responseData];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:jsonData
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        if (idx == 0)
            [selectedMember setValue:[jsonObject valueForKey:@"objectId"] forKeyPath:@"objectId"];     // Member op
        if (idx == 1)
            [selectedMember setValue:[jsonObject valueForKey:@"objectId"] forKeyPath:@"userId"];   // User op
    }];
    
    [selectedMember setValue:[selectedEvent valueForKey:@"objectId"] forKeyPath:@"eventId"];    // set member with eventId
    
    [parseDotComMgr updateUser:selectedMember withUserType:Member];
    
}


/*---------------------------------------------------------------------------
 * Delegation callback for fetching members
 *--------------------------------------------------------------------------*/
- (void)didFetchUsers:(NSArray *)userList forUserType:(UserTypes)userType  {
    NSLog(@"Success!! We updated an existing %d record in Parse", userType);
   
    
    for (User *thisUser in userList) {
        [selectedEvent addMember:thisUser];
    }
    
    [self.tableView reloadData];

}

/*---------------------------------------------------------------------------
 * Delegation callback for inserting attendance record.
 *--------------------------------------------------------------------------*/
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
    
}

/*---------------------------------------------------------------------------
 * Delegation callback for updating attendance record.
 *--------------------------------------------------------------------------*/
- (void)didUpdateAttendance {
    NSLog(@"Success!! We updated Attendance record in Parse");

    [self.tableView reloadData];


}

/*---------------------------------------------------------------------------
 * Delegation callback for deleting attendance record.
 *--------------------------------------------------------------------------*/
- (void)didDeleteAttendance {
    NSLog(@"Success!! We deleted an existing Attendance record from Parse");

    
    [self.tableView reloadData];
}



/*---------------------------------------------------------------------------
 * Delegation callback for Parse batche executions that failed.
 *--------------------------------------------------------------------------*/
- (void)executedOpsFailedWithError:(NSError *)error
                     forActionType:(ActionTypes) actionType
                     forNamedClass:(NSString *)namedClass {}





@end

