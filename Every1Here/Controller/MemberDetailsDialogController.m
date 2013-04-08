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
        QPickerElement *withGuestsElement = (QPickerElement *)[self.root elementWithKey:@"withGuests"];
//        [withMembersElement setValue:[NSString stringWithFormat:@"%d", [thisEventRole withMembers]]];
        [withGuestsElement setValue:[NSString stringWithFormat:@"%d", [thisEventRole withGuests]]];

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
//        User *user = (User *)self.userToEdit;
//        [self.root fetchValueUsingBindingsIntoObject:self.userToEdit];

        
        // Set the attendance field
        QBooleanElement *attendanceElement = (QBooleanElement *)[self.root elementWithKey: @"attendance"];
//        QPickerElement *withMembersElement = (QPickerElement *)[self.root elementWithKey:@"withMembers"];
        QPickerElement *withGuestsElement = (QPickerElement *)[self.root elementWithKey:@"withGuests"];
        
        //[self markUserInAttendance:[attendanceElement boolValue]];
        [thisEventRole setAttendance:[attendanceElement boolValue]];
//        [thisEventRole setWithMembers:[[withMembersElement textValue] integerValue]];
        [thisEventRole setWithGuests:[[withGuestsElement textValue] integerValue]];
        // Concatenate the firstName and lastName into fullName
        
        [self setEventRolesForUser:self.userToEdit];
        
        [self setDisplayName];
    } else {
        [self.userToEdit addRole:@"MemberRole"];
        [self.userToEdit addRole:@"EventRole"];
        // Don't default to in attendance for new user.
        //[self markUserInAttendance:TRUE];
        //[thisEventRole setAttendance:TRUE];
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

+ (QRootElement *)createDetailsForm {
    QRootElement *details = [[QRootElement alloc] init];
    details.presentationMode = QPresentationModeModalForm;
    details.title = @"Details";
    details.controllerName = @"AboutController";
    details.grouped = YES;
    QSection *section = [[QSection alloc] initWithTitle:@"Information"];
    [section addElement:[[QTextElement alloc] initWithText:@"Here's some more info about this app."]];
    [details addSection:section];
    return details;
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

- (void)setEventRolesForUser:(User *)user {
    
    __block NSUInteger roles = 0;
    [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"key %@: value %d", key, [obj unsignedIntegerValue]);
        QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];
        if (thisElement != nil) {
            if ([thisElement boolValue] == TRUE) {
                NSNumber *thisValue = (NSNumber *)meetingRoleDict[key];
                roles = roles + [thisValue unsignedIntegerValue];
            }
        }
        
    }];
    
    [[user getRole:@"EventRole"] setEventRoles:roles];
    
////    NSLog(@"Is User Attending: %d", (BOOL)[attendanceElement boolValue]);
////    [attendanceElement bindToObject:(BOOL)[[user getRole:@"EventRole"] attendance]];
//    [[user getRole:@"EventRole"] setAttendance:[attendanceElement boolValue]];
   
    
}



//- (void)testEnumerateMeetingRoleValue:(int) total {
//    
//    __block NSMutableArray *checkedItems = [[NSMutableArray alloc] initWithCapacity:7];
//    __block int idx = 0;
//    [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"key %@: value %d", key, [obj unsignedIntegerValue]);
//        NSLog(@"Index: %d", idx);
//        if (total & [obj unsignedIntegerValue]) {
//            NSLog(@"You selected: %@", key);
//            //            [concatCheckedItems stringByAppendingString: [NSString stringWithFormat:@"%@ | ", key]];
//            [checkedItems addObject:(NSString *) key];
//        }
//        idx++;
//    }];
//       
//}

- (void)markUserInAttendance:(BOOL)isAttending {
    
    
    QBooleanElement *attendanceElement = (QBooleanElement *)[self.root elementWithKey: @"attendance"];
    [attendanceElement setBoolValue:isAttending];
//  [thisEventRole setAttendance:isAttending];
    
}

- (void)unmaskEventRoles:(TMEventRoles)roles {
    
    meetingRoleDict = [[NSDictionary alloc] init];
    meetingRoleIconDict = [[NSDictionary alloc] init];
    meetingRoleDict = [[[self userToEdit] getRole:@"EventRole"] mapFieldsToRoles];
    meetingRoleIconDict = [[[self userToEdit] getRole:@"EventRole"] mapFieldsToIconsMedium];
    
    
    [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key %@: value %d", key, [obj integerValue]);
        QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];
        NSString *iconString = meetingRoleIconDict[key];
        [thisElement setImage:[UIImage imageNamed:iconString]];
        if (thisElement != nil) {
            thisElement.onImage = [UIImage imageNamed:@"imgOn"];
            thisElement.offImage = [UIImage imageNamed:@"imgOff"];
            if (roles & [obj unsignedIntegerValue]) {
                NSLog(@"You selected: %@", key);
                
                [thisElement setBoolValue:TRUE];
            }
        }
        
    }];
    
    BOOL isAttending = [[[self userToEdit] getRole:@"EventRole"] isAttending];
    [self markUserInAttendance:isAttending];

    [self reloadInputViews];
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
