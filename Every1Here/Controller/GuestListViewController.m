//
//  GuestPickerViewController.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/27/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestListViewController.h"
#import "GuestDetailsDialogController.h"
#import "GuestCommunicatorDelegate.h"
#import "EventMemberGuestTabBarController.h"
#import "GuestListTableDataSource.h"
#import "E1HObjectConfiguration.h"
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
#import "CommonUtilities.h"
#import "Receptionist.h"
#import "AFHTTPRequestOperation.h"


static NSString *guestCellReuseIdentifier = @"guestSummaryCell";

@interface GuestListViewController ()
{
    
    //-------------------------------------------------------
    // member and event of current selection.
    //-------------------------------------------------------
    Event *selectedEvent;
    User * selectedGuest;
    
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
    
    //-------------------------------------------------------
    // Social Network type.
    //-------------------------------------------------------
    NSString *slTypeString;
    
    //-------------------------------------------------------
    // Popover Controller variable.
    // https://github.com/50pixels/FPPopover
    // Installed using cocoapods
    //-------------------------------------------------------
    FPPopoverController *popover;
    
    //-------------------------------------------------------
    // Used to hold an instance of the custom icon bar on Guest view.
    //-------------------------------------------------------
    GuestListViewNavigationItem *navItem;
}


@property (nonatomic, strong) NSMutableDictionary *guestFullListDict;
@property (nonatomic, strong) NSMutableDictionary *guestAttendeeListDict;
@property (nonatomic, strong) NSMutableArray *guestAttendeeListForSlType;
@property (nonatomic, strong) NSMutableArray *guestFullListForSlType;

-(void)setGuestAttendeeListWithSlType:(SocialNetworkType) slType;
-(void)setGuestFullListWithSlType:(SocialNetworkType) slType;
-(void)fetchGuestListTableContent;

-(IBAction) popover:(id)sender slType:(SocialNetworkType)slType;

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

    // custom navigationItem to display social media links
    navItem = [(GuestListViewNavigationItem *)[self navigationItem] initWithDelegate:self];
    
    
    // A full listing of all potential guests
    self.guestFullListDict = [[NSMutableDictionary alloc] init];
    self.guestFullListForSlType = [[NSMutableArray alloc] init];
    
    // The actual attendee guest list.
    self.guestAttendeeListDict = [[NSMutableDictionary alloc] init];
    self.guestAttendeeListForSlType = [[NSMutableArray alloc] init];
    

    self.objectConfiguration = [[E1HObjectConfiguration alloc] init];
    GuestListTableDataSource *guestListDataSource = [[GuestListTableDataSource alloc] init];
    guestListDataSource.event = selectedEvent;
    

    //-------------------------------------------------------
    // Load the Quick Dialog form names mapping.
    //-------------------------------------------------------
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:@"E1H_QuickDialog_FileNames" ofType:@"plist"];
    pListInfoDictForE1HQuickDialog = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    
    
    
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.parseDotComDelegate = self;
    
    self.dataSource = guestListDataSource;
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector(userDidSelectGuestListNotification:)
     name: GuestListDidSelectGuestNotification
     object: nil];
    
    [CommonUtilities hideProgressHUD:self.view];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [CommonUtilities showProgressHUD:self.view];
    
    if ([self.dataSource isKindOfClass: [GuestListTableDataSource class]]) {
                [self fetchGuestListTableContent];
        //        [(EventListTableDataSource *)self.dataSource setAvatarStore: [objectConfiguration avatarStore]];
    }
    
}

/*---------------------------------------------------------------------------
 * Target-Action method for 'Done' button.
 * Dismisses the current view controller.
 *--------------------------------------------------------------------------*/
- (void)fetchGuestListTableContent
{
    
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.parseDotComDelegate = self;
    selectedEvent = (Event *)[(GuestListTableDataSource *)self.dataSource event];
    [self.parseDotComMgr fetchUsersForEvent:selectedEvent withUserType:Guest];
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
    
    navItem = nil;
}


- (void)fetchMemberListTableContent
{
    
    
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.parseDotComDelegate = self;
    selectedEvent = (Event *)[(GuestListTableDataSource *)self.dataSource event];
    [self.parseDotComMgr fetchUsersForEvent:selectedEvent withUserType:Guest];
}


- (void)popover:(id)sender slType:(SocialNetworkType)slType {
    
    popover=nil;
    GuestListPopoverTableController *controller = [[GuestListPopoverTableController alloc] initWithStyle:UITableViewStylePlain];

    [self setGuestFullListWithSlType:slType];
    [self setGuestAttendeeListWithSlType:slType];
    controller.slType = slType;
    controller.guestFullListForSlType = self.guestFullListForSlType;
    controller.guestAttendeeListForSlType = self.guestAttendeeListForSlType;
    controller.selectedEvent = selectedEvent;
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
    [visiblePopoverController dismissPopoverAnimated:YES completion:^{
        NSLog(@"Popover has been dismissed! Woo hoo!!");
    }];
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
//                [parseDotComMgr createNewUser: selectedGuest withEvent:selectedEvent];
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
//    [parseDotComMgr createNewGuest:aSelectedUser withEvent: aSelectedEvent];
    
    
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


- (void)didInsertUserForUserType:(UserTypes)userType withOutput:(NSArray *)objectNotationList {
    NSLog(@"Success!! We inserted new Guests into Parse ");
    
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
        
        NSLog(@"jspnObject: %@", jsonObject);
    }];
    
}


/*---------------------------------------------------------------------------
 * Delegation callback for fetching members
 *--------------------------------------------------------------------------*/
- (void)didFetchUsers:(NSArray *)userList forUserType:(UserTypes)userType  {
    NSLog(@"Success!! We updated an existing %d record in Parse", userType);
    
    
    
    if ([userList count] > 0) {
        for (User *thisUser in userList) {
//            NSString *thisKey = [SocialNetworkUtilities formatIntegerToString:[thisUser slType]];
            
            [selectedEvent addGuest:thisUser];
        }
    
    NSArray *slTypeArray = [userList valueForKey:@"slType"];
       
        
    for(NSUInteger slTypeIdx = NONE; slTypeIdx < Facebook; ++slTypeIdx) {
            //do something with i...
        NSIndexSet *indexes = [slTypeArray indexesOfObjectsPassingTest:
                               ^BOOL (id slType, NSUInteger i, BOOL *stop) {
                                   NSUInteger slTypeUInt = [slType unsignedIntegerValue];
                                   return slTypeUInt == slTypeIdx ? true : false;
                               }];
        NSArray *results = [userList objectsAtIndexes:indexes];
        if ([results count] >0 )
            [self updateTableContentsWithArray:results forKey:[SocialNetworkUtilities formatIntegerToString:slTypeIdx]];
        
        results = nil;
    }

//        [[self guestAttendeeListDict] setObject:userList forKey:@"Meetup"];
//        [self.tableView reloadData];
         
//        [self setGuestAttendeeListWithSlType:Meetup];
//        [self setGuestFullListWithSlType:Meetup];
       
    }
    
    
}



@end

//NSString *GuestListDidSelectGuestNotification = @"GuestListDidSelectGuestNotification";
