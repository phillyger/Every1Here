//
//  MemberDetailDialogController.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberDetailsDialogController.h"
#import "QuickDialog.h"
#import "User.h"
#import "EventRole.h"

@interface MemberDetailsDialogController ()
{
    NSArray *meetingRoleKeys;
    NSDictionary *meetingRoleDict;
    NSDictionary *meetingRoleIconDict;
    NSDictionary *meetingRoleCellColorHueDict;
    EventRole *thisEventRole;
    
    NSNumber *postEventRoles;
    NSNumber *postAttendance;
    NSNumber *postGuestCount;
    NSString *postDisplayName;
    
}

//@property (nonatomic) NSInteger eventRolesChangedCount;
@property (nonatomic) BOOL hasFormBeenEdited;
@end

@implementation MemberDetailsDialogController
@synthesize newUser;
@synthesize userToEdit;


- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];
    

//    self.quickDialogTableView.backgroundView = nil;
//    self.quickDialogTableView.backgroundColor = [UIColor colorWithHue:0.1174 saturation:0.7131 brightness:0.8618 alpha:1.0000];
   
    self.quickDialogTableView.bounces = NO;
//    self.quickDialogTableView.styleProvider = self;
    

    thisEventRole = [[self userToEdit] getRole:@"EventRole"];
    TMEventRoles roles = [thisEventRole eventRoles];
    
    if (![self isNewUser]) {
        // Handle data values within Event Role objec
        [self unmaskEventRoles:roles];
        
        QPickerElement *guestCountElement = (QPickerElement *)[self.root elementWithKey:@"guestCount"];
        [guestCountElement setValue:[NSString stringWithFormat:@"%@", [[self userToEdit] valueForKeyPath:@"roles.EventRole.guestCount"]]];

    }
    
} 

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDone)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)onDone {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self loading:YES];
    [self setHasFormBeenEdited];
    if (self.hasFormBeenEdited) {

        if (![self isNewUser]) {

            [[self userToEdit] setValue:postAttendance forKeyPath:@"roles.EventRole.attendance"];
            [[self userToEdit] setValue:postGuestCount forKeyPath:@"roles.EventRole.guestCount"];
            [[self userToEdit] setValue:postEventRoles forKeyPath:@"roles.EventRole.eventRoles"];
//            [self computeDisplayName];
        } else {
            [self.userToEdit addRole:@"MemberRole"];
            [self.userToEdit addRole:@"EventRole"];
            [self computeDisplayName];
        }
   
    
    [self.root fetchValueUsingBindingsIntoObject:self.userToEdit];
    }
    
    [self performSelector:@selector(showDone:) withObject:self.userToEdit];
}

- (void)onCancel {
    NSLog(@"Dismiss view controller");

    if (self.completionBlock != nil)
		self.completionBlock(NO);
}


- (void)showDone:(User *)user {
    [self loading:NO];
    
    if (self.completionBlock != nil)
		self.completionBlock([self hasFormBeenEdited]);
    
}



-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath{
    
    
       if ([element isKindOfClass:[QBooleanElement class]] && [[element key] hasPrefix:@"is"]){
               NSLog(@"key: %@", [element key]);
//           cell.backgroundColor = indexPath.row % 2 ? [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000] : [UIColor whiteColor];
           cell.backgroundColor =  [UIColor colorWithHue:[[meetingRoleCellColorHueDict valueForKey:[element key]] floatValue]
                      saturation:0.7
                      brightness:0.7
                           alpha:0.70];
           
            cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        }
}


- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Editing changed");
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSNumber *)computeEventRoleCount {
    
    __block NSUInteger rolesCount = 0;
    [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"key %@: value %d", key, [obj unsignedIntegerValue]);
        QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];

        if (thisElement != nil) {
            if ([thisElement boolValue] == TRUE) {
                NSNumber *thisValue = (NSNumber *)meetingRoleDict[key];
                rolesCount = rolesCount + [thisValue unsignedIntegerValue];
            }
        }
        
    }];
    
    return [NSNumber numberWithInteger:rolesCount];
     
    
}




- (void)markUserInAttendance:(BOOL)isAttending {
    
    
    QBooleanElement *attendanceElement = (QBooleanElement *)[self.root elementWithKey: @"attendance"];
    [attendanceElement setBoolValue:isAttending];
    
}

- (void)unmaskEventRoles:(TMEventRoles)roles {
    
    meetingRoleDict = [[NSDictionary alloc] init];
    meetingRoleIconDict = [[NSDictionary alloc] init];
    meetingRoleCellColorHueDict = [[NSDictionary alloc] init];
    
    meetingRoleDict = [[[self userToEdit] getRole:@"EventRole"] mapFieldsToRoles];
    meetingRoleIconDict = [[[self userToEdit] getRole:@"EventRole"] mapFieldsToIconsMedium];
    
    meetingRoleCellColorHueDict= [[[self userToEdit] getRole:@"EventRole"] mapFieldsToCellColorHue];
    
    
    [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"key %@: value %d", key, [obj integerValue]);
        __weak QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];
//        thisElement.onValueChanged = ^(QRootElement *el){
//            NSLog(@"Flag changed");
//            NSLog(@"%@", [thisElement numberValue]);
//           
//        };
        NSString *iconString = meetingRoleIconDict[key];
        [thisElement setImage:[UIImage imageNamed:iconString]];
        if (thisElement != nil) {
            thisElement.onImage = [UIImage imageNamed:@"imgOn"];
            thisElement.offImage = [UIImage imageNamed:@"imgOff"];
            if (roles & [obj unsignedIntegerValue]) {
//                NSLog(@"You selected: %@", key);
                
                [thisElement setBoolValue:TRUE];
            }
        }
        
    }];
    
//    BOOL isAttending = [[[self userToEdit] getRole:@"EventRole"] isAttending];
    BOOL isAttending = [[[self userToEdit] valueForKeyPath:@"roles.EventRole.attendance"] boolValue];
    [self markUserInAttendance:isAttending];

//    [self reloadInputViews];
}

- (NSString *)computeDisplayName {
    // Transform value for Full Name field
     QEntryElement *displayNameElement = (QEntryElement *)[self.root elementWithKey:@"displayName"];
        
    NSString *firstNameString;
    NSString *lastNameString;
    NSString * displayNameString;
    
    if (![self isNewUser]) {
        
        displayNameString = [displayNameElement textValue];
        NSArray* displayNameParts = [displayNameString componentsSeparatedByString: @" "];
        if ([displayNameParts count] > 0) {
            firstNameString = displayNameParts[0];
            if ([displayNameParts count] > 1)
                lastNameString = displayNameParts[1];
        }
        
        [self.userToEdit setFirstName:firstNameString];
        [self.userToEdit setLastName:lastNameString];

        
    } else {
       
        if ([[displayNameElement textValue] isEqualToString:@""]) {             // if displayName field is left blank.
        
            QEntryElement *firstNameElement = (QEntryElement *)[self.root elementWithKey:@"firstName"];
            QEntryElement *lastNameElement = (QEntryElement *)[self.root elementWithKey:@"lastName"];

            
            firstNameString = [firstNameElement textValue];
            lastNameString = [lastNameElement textValue];

            
            displayNameString = [NSString stringWithFormat:@"%@ %@", firstNameString, lastNameString];
        }
    }
    
    return displayNameString;
}

- (void)setHasFormBeenEdited {

    NSNumber *preEventRoles = [[self userToEdit] valueForKeyPath:@"roles.EventRole.eventRoles"];
    NSNumber *preAttendance = [[self userToEdit] valueForKeyPath:@"roles.EventRole.attendance"];
    NSNumber *preGuestCount = [[self userToEdit] valueForKeyPath:@"roles.EventRole.guestCount"];
    NSString *preDisplayName = [[self userToEdit] valueForKeyPath:@"displayName"];
    
    postEventRoles = [self computeEventRoleCount];
    postDisplayName = [self computeDisplayName];
    postAttendance = [NSNumber numberWithInt:[[(QBooleanElement *)[[self root] elementWithKey:@"attendance"] numberValue] intValue]] ;
    postGuestCount = [NSNumber numberWithInt:[[(QPickerElement *)[[self root] elementWithKey:@"guestCount"] value] intValue]];
    
    
//    if ((preEventRoles != postEventRoles) || (preAttendance != postAttendance) || (preGuestCount != postGuestCount))
    if (([preEventRoles intValue] != [postEventRoles intValue])
        || [preAttendance boolValue] != [postAttendance boolValue]
        || ([preGuestCount intValue] != [postGuestCount intValue])
        || (![preDisplayName isEqualToString:postDisplayName]))
        self.hasFormBeenEdited = TRUE;
    
}


@end
