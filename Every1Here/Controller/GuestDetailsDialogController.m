//
//  GuestDetailsViewController.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/10/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestDetailsDialogController.h"
#import "QuickDialog.h"
#import "User.h"
#import "EventRole.h"


@interface GuestDetailsDialogController ()
{
    EventRole *thisEventRole;
    
    NSNumber *postAttendance;
    NSString *postPrimaryEmailAddr;
    NSString *postDisplayName;
}

@property (nonatomic) BOOL hasFormBeenEdited;

@end

@implementation GuestDetailsDialogController
@synthesize newUser;
@synthesize userToEdit;

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];
    
//    self.quickDialogTableView.backgroundView = nil;
//    self.quickDialogTableView.backgroundColor = [UIColor colorWithHue:0.1174 saturation:0.7131 brightness:0.8618 alpha:1.0000];
    self.quickDialogTableView.bounces = NO;
//    self.quickDialogTableView.styleProvider = self;

    thisEventRole = [[self userToEdit] getRole:@"EventRole"];
    BOOL isAttending = [[[self userToEdit] valueForKeyPath:@"roles.EventRole.attendance"] boolValue];
    [self markUserInAttendance:isAttending];
    
    if (![self isNewUser]) {
        QPickerElement *guestCountElement = (QPickerElement *)[self.root elementWithKey:@"guestCount"];
        [guestCountElement setValue:[NSString stringWithFormat:@"%d", [thisEventRole guestCount]]];
        
    }

    QImageElement *avatar = (QImageElement *)[self.root elementWithKey:@"avatar"];
    NSLog(@"sltype : %d", self.userToEdit.slType);
    
    switch (self.userToEdit.slType) {
        case Meetup:
            [avatar setImageValue:[UIImage imageNamed:@"meetup-32x32.png"]];
            break;
        case Twitter:
            [avatar setImageValue:[UIImage imageNamed:@"twitter-32x32.png"]];
            break;
        case LinkedIn:
            [avatar setImageValue:[UIImage imageNamed:@"linkedin-32x32.png"]];
            break;
        case Facebook:
            [avatar setImageValue:[UIImage imageNamed:@"facebook-32x32.png"]];
            break;
        default:
            break;
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
            [[self userToEdit] setValue:postPrimaryEmailAddr forKeyPath:@"primaryEmailAddr"];
            [self computeDisplayName];
            
        } else {
            [self.userToEdit addRole:@"GuestRole"];
            [self.userToEdit addRole:@"EventRole"];
            [[self userToEdit] setValue:postPrimaryEmailAddr forKeyPath:@"primaryEmailAddr"];
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

- (void)markUserInAttendance:(BOOL)isAttending {
    
    
    QBooleanElement *attendanceElement = (QBooleanElement *)[self.root elementWithKey: @"attendance"];
    [attendanceElement setBoolValue:isAttending];
    
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
    
    NSNumber *preAttendance = [[self userToEdit] valueForKeyPath:@"roles.EventRole.attendance"];
    NSString *preDisplayName = [[self userToEdit] valueForKeyPath:@"displayName"];
    NSString *prePrimaryEmailAddr = [[self userToEdit] valueForKeyPath:@"primaryEmailAddr"];
    
    postDisplayName = [self computeDisplayName];
    postAttendance = [NSNumber numberWithInt:[[(QBooleanElement *)[[self root] elementWithKey:@"attendance"] numberValue] intValue]] ;
    postPrimaryEmailAddr = [(QEntryElement *)[[self root] elementWithKey:@"primaryEmailAddr"] textValue];
    
    
    //    if ((preEventRoles != postEventRoles) || (preAttendance != postAttendance) || (preGuestCount != postGuestCount))
    if (([preAttendance boolValue] != [postAttendance boolValue])
        || (![preDisplayName isEqualToString:postDisplayName])
        || (![prePrimaryEmailAddr isEqualToString:postPrimaryEmailAddr]))
        self.hasFormBeenEdited = TRUE;
    
}



@end
