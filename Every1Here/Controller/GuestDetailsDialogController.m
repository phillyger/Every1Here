//
//  GuestDetailsViewController.m
//  Anseo
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
}

@end

@implementation GuestDetailsDialogController
@synthesize newUser;
@synthesize userToEdit;

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];
    
//    self.quickDialogTableView.backgroundView = nil;
//    self.quickDialogTableView.backgroundColor = [UIColor colorWithHue:0.1174 saturation:0.7131 brightness:0.8618 alpha:1.0000];
    self.quickDialogTableView.bounces = NO;
    self.quickDialogTableView.styleProvider = self;

    thisEventRole = [[self userToEdit] getRole:@"EventRole"];
    
    
    if (![self isNewUser]) {
        QPickerElement *withGuestsElement = (QPickerElement *)[self.root elementWithKey:@"withGuests"];
        [withGuestsElement setValue:[NSString stringWithFormat:@"%d", [thisEventRole withGuests]]];
        
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
    if (![self isNewUser]) {
        //        User *user = (User *)self.userToEdit;
        //        [self.root fetchValueUsingBindingsIntoObject:self.userToEdit];
        
        
        // Set the attendance field
        QBooleanElement *attendanceElement = (QBooleanElement *)[self.root elementWithKey: @"attendance"];
        QPickerElement *withGuestsElement = (QPickerElement *)[self.root elementWithKey:@"withGuests"];
        
        //[self markUserInAttendance:[attendanceElement boolValue]];
        [thisEventRole setAttendance:[attendanceElement boolValue]];
        [thisEventRole setWithGuests:[[withGuestsElement textValue] integerValue]];
        // Concatenate the firstName and lastName into fullName
        
        
        [self setDisplayName];
    } else {
        [self.userToEdit addRole:@"GuestRole"];
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
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:[NSString stringWithFormat: @"Hi %@, I hope you're loving QuickDialog! Here's your pass: %@, %@", user.firstName, user.lastName, user.displayName] delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil];
//    [alert show];
    
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
