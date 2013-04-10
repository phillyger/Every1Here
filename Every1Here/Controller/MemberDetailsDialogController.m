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
    EventRole *thisEventRole;
}
@end

@implementation MemberDetailsDialogController
@synthesize newUser;
@synthesize userToEdit;


- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];
    
    //    self.quickDialogTableView.backgroundView = nil;
    //    self.quickDialogTableView.backgroundColor = [UIColor colorWithHue:0.1174 saturation:0.7131 brightness:0.8618 alpha:1.0000];
    self.quickDialogTableView.bounces = NO;
    self.quickDialogTableView.styleProvider = self;
    

    thisEventRole = [[self userToEdit] getRole:@"EventRole"];
    TMEventRoles roles = [thisEventRole eventRoles];
    
    if (![self isNewUser]) {
        // Handle data values within Event Role objec
        [self unmaskEventRoles:roles];
        
//        QPickerElement *withMembersElement = (QPickerElement *)[self.root elementWithKey:@"withMembers"];
        QPickerElement *guestCountElement = (QPickerElement *)[self.root elementWithKey:@"guestCount"];
//        [withMembersElement setValue:[NSString stringWithFormat:@"%d", [thisEventRole withMembers]]];
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
    if (![self isNewUser]) {

        QBooleanElement *attendanceElement = (QBooleanElement *)[self.root elementWithKey: @"attendance"];
        QPickerElement *guestCountElement = (QPickerElement *)[self.root elementWithKey:@"guestCount"];
        
        NSNumber *isAttending = [NSNumber numberWithBool:[attendanceElement boolValue]];
        [[self userToEdit] setValue:isAttending forKeyPath:@"roles.EventRole.attendance"];
        [[self userToEdit] setValue:[guestCountElement value] forKeyPath:@"roles.EventRole.guestCount"];
        [self computeEventRoleCountForUser:self.userToEdit];
        
        [self setDisplayName];
    } else {
        [self.userToEdit addRole:@"MemberRole"];
        [self.userToEdit addRole:@"EventRole"];
        [self setDisplayName];
    }
    
    [self.root fetchValueUsingBindingsIntoObject:self.userToEdit];
    [self performSelector:@selector(showDone:) withObject:self.userToEdit];
}

- (void)onCancel {
    NSLog(@"Dismiss view controller");
    //    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.completionBlock != nil)
		self.completionBlock(NO);
}


- (void)showDone:(User *)user {
    [self loading:NO];
   
//       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome"
//                                                       message:[NSString stringWithFormat: @"Hi %@, Your role selection count is %u", user.firstName, total]
//                                                                                 delegate:self cancelButtonTitle:@"YES!"
//                                                                        otherButtonTitles:nil];
//        [alert show];
    
    if (self.completionBlock != nil)
		self.completionBlock(YES);
    
}



-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath{
    //    cell.backgroundColor = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
    
    //    if ([element isKindOfClass:[QEntryElement class]] || [element isKindOfClass:[QButtonElement class]]){
    //        cell.textLabel.textColor = [UIColor colorWithRed:0.6033 green:0.2323 blue:0.0000 alpha:1.0000];
    //    }
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

- (void)computeEventRoleCountForUser:(User *)user {
    
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
    
    [[self userToEdit] setValue:[NSNumber numberWithInteger:rolesCount] forKeyPath:@"roles.EventRole.eventRoles"];
     
    
}




- (void)markUserInAttendance:(BOOL)isAttending {
    
    
    QBooleanElement *attendanceElement = (QBooleanElement *)[self.root elementWithKey: @"attendance"];
    [attendanceElement setBoolValue:isAttending];
    
}

- (void)unmaskEventRoles:(TMEventRoles)roles {
    
    meetingRoleDict = [[NSDictionary alloc] init];
    meetingRoleIconDict = [[NSDictionary alloc] init];
    meetingRoleDict = [[[self userToEdit] getRole:@"EventRole"] mapFieldsToRoles];
    meetingRoleIconDict = [[[self userToEdit] getRole:@"EventRole"] mapFieldsToIconsMedium];
    
    
    [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"key %@: value %d", key, [obj integerValue]);
        QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];
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

- (void)setDisplayName {
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

            
            NSString *fullNameString = [NSString stringWithFormat:@"%@ %@", firstNameString, lastNameString];
            [displayNameElement setTextValue:fullNameString];
        }
    }
    
}

@end
