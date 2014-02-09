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
#import "SpeakerInfoViewController.h"
#import "MZFormSheetController.h"
#import "E1HObjectConfiguration.h"
#import "ParseDotComManager.h"
#import "CommonUtilities.h"

static NSString* kSpeechInfoEvaluatorKeyName = @"speechEvaluator";
static NSString* kSpeechInfoTMCCIdKeyName = @"speechTMCCId";
static NSString* kSpeechInfoTitleKeyName = @"speechTitle";
static NSString* kSpeechInfoHasIntroKeyName = @"speechHasIntro";
//static NSString* kSpeechInfoNumberKeyName = @"speechNumber";

static NSString* kSpeechInfoHasIntroFieldKeyPath = @"roles.EventRole.speech.hasIntro";
static NSString* kSpeechInfoEvaluatorIdFieldKeyPath = @"roles.EventRole.speech.evaluatorId";
static NSString* kSpeechInfoTMCCIdFieldKeyPath = @"roles.EventRole.speech.tmCCId";
static NSString* kSpeechInfoTitleFieldKeyPath = @"roles.EventRole.speech.title";
static NSString* kAttendanceFieldKeyPath = @"roles.EventRole.attendance";
static NSString* kGuestCountFieldKeyPath = @"roles.EventRole.guestCount";
static NSString* kEventRolesFieldKeyPath = @"roles.EventRole.eventRoles";


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
    
    NSString *postSpeechTitle;
    NSString *postSpeechEvaluatorId;
    NSNumber* postSpeechHasIntro;
    NSString *postSpeechTMCCId;
    
}
@property(nonatomic)CGSize trueContentSize;

//@property (nonatomic) NSInteger eventRolesChangedCount;
@property (nonatomic) BOOL hasFormBeenEdited;

@property (strong) E1HObjectConfiguration *objectConfiguration;
@property (strong) ParseDotComManager *parseDotComMgr;

- (void)createSampleFormRoot;
@end

@implementation MemberDetailsDialogController
@synthesize newUser;
@synthesize userToEdit;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        QRootElement *root =[[QRootElement alloc] init];

        
        self.root = root;
        self.resizeWhenKeyboardPresented = YES;
    }
    return self;
}

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];
    

//    self.quickDialogTableView.backgroundView = nil;
//    self.quickDialogTableView.backgroundColor = [UIColor colorWithHue:0.1174 saturation:0.7131 brightness:0.8618 alpha:1.0000];
   
    self.quickDialogTableView.bounces = NO;
//    self.quickDialogTableView.bounds = CGRectMake(0,0,320, 920);
//    self.quickDialogTableView.contentSize = CGSizeMake(320, 920);
    [self.quickDialogTableView setNeedsLayout];
    [self.quickDialogTableView setScrollEnabled:YES];
//    self.quickDialogTableView.styleProvider = self;
    
//     [self.userToEdit setValue:@"Test Title" forKeyPath:@"roles.EventRole.speech.title"];

    thisEventRole = [[self userToEdit] getRole:@"EventRole"];
    TMEventRoles roles = [thisEventRole eventRoles];
    
    if (![self isNewUser]) {
        // Handle data values within Event Role objec
        [self unmaskEventRoles:roles];
        
        QPickerElement *guestCountElement = (QPickerElement *)[self.root elementWithKey:@"guestCount"];
        [guestCountElement setValue:[NSString stringWithFormat:@"%@", [[self userToEdit] valueForKeyPath:kGuestCountFieldKeyPath]]];

    }
    
}

- (void)loadView {
    [super loadView];
    
    
    meetingRoleDict = [[NSDictionary alloc] init];
    meetingRoleIconDict = [[NSDictionary alloc] init];
    meetingRoleCellColorHueDict = [[NSDictionary alloc] init];
    
    meetingRoleDict = [[[self userToEdit] getRole:@"EventRole"] mapFieldsToRoles];
    meetingRoleIconDict = [[[self userToEdit] getRole:@"EventRole"] mapFieldsToIconsMedium];
    meetingRoleCellColorHueDict= [[[self userToEdit] getRole:@"EventRole"] mapFieldsToCellColorHue];

//    UITabBarController *tabBarController = self.tabBarController;
//    UITabBar *tabBar = [tabBarController tabBar];
//    UITabBarItem *tabBarItem = [[tabBar items] objectAtIndex:1];
//    NSLog(@"%@", [tabBarItem title]);
//    [tabBarItem setEnabled:NO];
    
    //-------------------------------------------------------
    // Load the Quick Dialog form names mapping.
    //-------------------------------------------------------
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:@"E1H_QuickDialog_FileNames" ofType:@"plist"];
    NSDictionary *pListInfoDictForE1HQuickDialog = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    
    if (self.newUser) {
        self.root =[[QRootElement alloc] initWithJSONFile:[pListInfoDictForE1HQuickDialog valueForKey:@"member_details_new"]];
    } else {
        self.root =[[QRootElement alloc] initWithJSONFile:[pListInfoDictForE1HQuickDialog valueForKey:@"member_details_edit"]];
    }
    
    self.quickDialogTableView = [[QuickDialogTableView alloc] initWithController:self];
    self.view = self.quickDialogTableView;
    
//    self.view.frame = CGRectMake(0,0,320, 920);
    

 //    [radio setSelectedValue:@"Deborah Wyse"];
//    [radio setSelectedItem:@"Deborah Wyse"];
//    [radio setTextValue:@"Deborah Wyse"];
    
    
    [CommonUtilities showProgressHUD:self.view];
    
    [self fetchMemberListTableContentWithCompletionBlock:^(NSArray *userList, NSArray *tmCCList, BOOL success) {
        
        
        
        NSMutableArray *userNameList = [[NSMutableArray alloc] initWithObjects:@"-Select One-", nil];
        NSMutableArray *userIdList = [[NSMutableArray alloc] initWithObjects:@"", nil];
        
        [userNameList addObjectsFromArray:[userList valueForKey:@"displayName"]];
        [userIdList addObjectsFromArray:[userList valueForKey:@"userId"]];
        
        
         NSString *currentEvaluatorId = [self.userToEdit valueForKeyPath:kSpeechInfoEvaluatorIdFieldKeyPath];
         __block NSInteger currentEvaluatorSelected = -1;
        
        [userIdList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *userId= (NSString*)obj;
            if ([userId isEqualToString:currentEvaluatorId]){
                currentEvaluatorSelected = idx;
            }
            
        }];

        NSInteger nextSpeechNumber = [[self.userToEdit valueForKeyPath:@"compComm"] integerValue];
        if (nextSpeechNumber >= 10) {
            nextSpeechNumber = 9;
        }
        
        
        NSArray *tmCCListSpeechNumber = [tmCCList valueForKey:@"projectNum"];
        NSArray *tmCCListSpeechTitle = [tmCCList valueForKey:@"projectTitle"];
        NSMutableArray *tmCCListSpeechNumberString = [[NSMutableArray alloc] initWithCapacity:[tmCCListSpeechNumber count]];
        [tmCCListSpeechNumber enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *speechNumber = (NSNumber*)obj;
            NSString *speechDisplayItem = [NSString stringWithFormat:@"%@. %@", speechNumber, tmCCListSpeechTitle[idx]];
            [tmCCListSpeechNumberString addObject:speechDisplayItem];
        }];
        NSArray *tmCCListSpeechId = [tmCCList valueForKey:@"objectId"];
        
        
        QSection *sectionSpeakerInfo = [[QSection alloc] init];
        sectionSpeakerInfo.title = @"Speaker Info";

        sectionSpeakerInfo.key = @"sectionSpeakerInfo";

        
        QBooleanElement *isSpeaker = (QBooleanElement *)[self.root elementWithKey: @"isSpeaker"];
        
        QEntryElement *speechTitle = [[QEntryElement alloc] initWithTitle:@"Title" Value:[self.userToEdit valueForKeyPath:kSpeechInfoTitleFieldKeyPath] Placeholder:@"Speech Title"];
        speechTitle.enabled= [isSpeaker boolValue];
        speechTitle.key = kSpeechInfoTitleKeyName;
        [sectionSpeakerInfo addElement:speechTitle];
        
        
        QBooleanElement *hasIntro = [[QBooleanElement alloc] initWithTitle:@"Has Intro?" BoolValue:[[self.userToEdit valueForKeyPath:kSpeechInfoHasIntroFieldKeyPath]boolValue]];
        hasIntro.enabled = [isSpeaker boolValue];
        hasIntro.key = kSpeechInfoHasIntroKeyName;
        [sectionSpeakerInfo addElement:hasIntro];

        
        
//        QRadioElement *speechNumber = [[QRadioElement alloc] initWithItems:@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10] selected:currentSpeechNumber title:@"Speech #"];
//        QRadioElement *speechNumber = [[QRadioElement alloc] initWithDict:tmCCNumberDict selected:currentSpeechNumber title:@"Speech #"];
        
        QRadioElement *speechNumber = [[QRadioElement alloc] init];
        speechNumber.selected = nextSpeechNumber;
        [speechNumber setValues:tmCCListSpeechId];
        [speechNumber setItems:tmCCListSpeechNumberString];
        speechNumber.title = @"Speech #";
        speechNumber.enabled= [isSpeaker boolValue];
        speechNumber.key = kSpeechInfoTMCCIdKeyName;
        [sectionSpeakerInfo addElement:speechNumber];
       
        
        QRadioElement *speechEvaluator = [[QRadioElement alloc] init];
//                QRadioElement *newRadioElement = [[QRadioElement alloc] initItems:userNameList selected:currentEvaluatorSelected title:@"Evaluator"];
        speechEvaluator.selected = currentEvaluatorSelected;
        speechEvaluator.title = @"Evaluator";
        [speechEvaluator setValues:userIdList];
        [speechEvaluator setItems:userNameList];
        speechEvaluator.key = kSpeechInfoEvaluatorKeyName;
        speechEvaluator.enabled = [isSpeaker boolValue];
        [sectionSpeakerInfo addElement:speechEvaluator];

        
        [self.root addSection:sectionSpeakerInfo];
        
        [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            //        NSLog(@"key %@: value %d", key, [obj integerValue]);

            if ([key isEqualToString:@"isSpeaker"]) {
                __weak QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];
                thisElement.onValueChanged = ^(QRootElement *el){
//                    NSLog(@"Flag changed");
//                    NSLog(@"%@", [thisElement numberValue]);
//                    NSLog(@"%@", [thisElement key]);
                    
                    
                    QRadioElement *speechEvaluator = (QRadioElement*)[self.root elementWithKey:kSpeechInfoEvaluatorKeyName];
                    QRadioElement *speechNumber = (QRadioElement*)[self.root elementWithKey:kSpeechInfoTMCCIdKeyName];
                    QBooleanElement *speechHasIntro = (QBooleanElement*)[self.root elementWithKey:kSpeechInfoHasIntroKeyName];
                    QEntryElement *speechTitle = (QEntryElement*)[self.root elementWithKey:kSpeechInfoTitleKeyName];
                    speechEvaluator.enabled = [thisElement boolValue];
                    speechNumber.enabled = [thisElement boolValue];
                    speechTitle.enabled = [thisElement boolValue];
                    speechHasIntro.enabled = [thisElement boolValue];
                    
                    
                    [self.quickDialogTableView reloadCellForElements:speechEvaluator, speechNumber, speechHasIntro, speechTitle, nil];
                    
                    *stop = YES;
                };
            }
            
        }];
        
        [CommonUtilities hideProgressHUD:self.view];
        
    }];
    

    


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    

    [self.root bindToObject:self.userToEdit];
    //    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDone)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    
//    QSection *sectionSamples = [[QSection alloc] init];
//    sectionSamples.footer = @"Hey there, this is a footer.";
//    [sectionSamples addElement:[self createSampleFormRoot]];
//    [self.root addSection:sectionSamples];
    
// QSection *sectionSpeakerInfo = (QSection*)[self.root.sections lastObject];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = nil;
}


- (void)onDone {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self loading:YES];
    [self setHasFormBeenEdited];
    if (self.hasFormBeenEdited) {

        if (![self isNewUser]) {
            
//            NSString* radioValue = [self getSpeechEvaluatorValue];
//            NSString* radioItem = [self getSpeechEvaluatorItem];

            [[self userToEdit] setValue:postSpeechHasIntro forKeyPath:kSpeechInfoHasIntroFieldKeyPath];
            [[self userToEdit] setValue:postSpeechEvaluatorId forKeyPath:kSpeechInfoEvaluatorIdFieldKeyPath];
            [[self userToEdit] setValue:postSpeechTMCCId forKeyPath:kSpeechInfoTMCCIdFieldKeyPath];
            [[self userToEdit] setValue:postSpeechTitle forKeyPath:kSpeechInfoTitleFieldKeyPath];
            [[self userToEdit] setValue:postAttendance forKeyPath:kAttendanceFieldKeyPath];
            [[self userToEdit] setValue:postGuestCount forKeyPath:kGuestCountFieldKeyPath];
            [[self userToEdit] setValue:postEventRoles forKeyPath:kEventRolesFieldKeyPath];
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


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.quickDialogTableView reloadData]; // Calculates correct contentSize
    self.trueContentSize = self.quickDialogTableView.contentSize;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.quickDialogTableView.contentSize = self.trueContentSize;
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


#pragma mark - QuickDialog delegate methods
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

#pragma mark - Custom Methods
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

    [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"key %@: value %d", key, [obj integerValue]);
        __weak QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];
        
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
    BOOL isAttending = [[[self userToEdit] valueForKeyPath:kAttendanceFieldKeyPath] boolValue];
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

    NSNumber *preEventRoles = [[self userToEdit] valueForKeyPath:kEventRolesFieldKeyPath];
    NSNumber *preAttendance = [[self userToEdit] valueForKeyPath:kAttendanceFieldKeyPath];
    NSNumber *preGuestCount = [[self userToEdit] valueForKeyPath:kGuestCountFieldKeyPath];
    NSString *preDisplayName = [[self userToEdit] valueForKeyPath:@"displayName"];
    
    // Pre Speech Title
    NSString *preSpeechTitle = [[self userToEdit] valueForKeyPath:kSpeechInfoTitleFieldKeyPath];
    
    // Pre Speech EvaluatorId
    NSString *preSpeechEvaluatorId = [[self userToEdit] valueForKeyPath:kSpeechInfoEvaluatorIdFieldKeyPath];
    
    // Pre Speech HasIntro
    NSNumber *preSpeechHasIntro = [[self userToEdit] valueForKeyPath:kSpeechInfoHasIntroFieldKeyPath];
    
    // Pre Speech TM CC Id
    NSString *preSpeechTMCCId = [[self userToEdit] valueForKeyPath:kSpeechInfoTMCCIdFieldKeyPath];
    
    postEventRoles = [self computeEventRoleCount];
    postDisplayName = [self computeDisplayName];
    postAttendance = [NSNumber numberWithInt:[[(QBooleanElement *)[[self root] elementWithKey:@"attendance"] numberValue] intValue]] ;
    postGuestCount = [NSNumber numberWithInt:[[(QPickerElement *)[[self root] elementWithKey:@"guestCount"] value] intValue]];
    
    postSpeechTitle = [self getSpeechTitle];
    postSpeechEvaluatorId = [self getRadioElementValue:kSpeechInfoEvaluatorKeyName];
    postSpeechTMCCId = [self getRadioElementValue:kSpeechInfoTMCCIdKeyName];
    postSpeechHasIntro = [self getSpeechHasIntro];
    
    if (postSpeechTitle == nil )
        [self setSpeechTitle:@"Untitled"];
    
    
//    if ((preEventRoles != postEventRoles) || (preAttendance != postAttendance) || (preGuestCount != postGuestCount))
    if (([preEventRoles intValue] != [postEventRoles intValue])
        || [preAttendance boolValue] != [postAttendance boolValue]
        || ([preGuestCount intValue] != [postGuestCount intValue])
        || (![preDisplayName isEqualToString:postDisplayName])
        || (![preSpeechTitle isEqualToString:postSpeechTitle])
        || (preSpeechHasIntro != postSpeechHasIntro)
        || (![preSpeechEvaluatorId isEqualToString:postSpeechEvaluatorId])
        || (![preSpeechTMCCId isEqualToString:postSpeechTMCCId]))
        self.hasFormBeenEdited = TRUE;
    
}

/*---------------------------------------------------------------------------
 *
 *--------------------------------------------------------------------------*/
- (void)fetchMemberListTableContentWithCompletionBlock:(MemberDetailsDialogControllerCompletionBlock)successBlock
{
    self.objectConfiguration = [[E1HObjectConfiguration alloc] init];
    self.parseDotComMgr = [self.objectConfiguration parseDotComManager];
//    self.parseDotComMgr.parseDotComDelegate = self;
    
//    NSString *tmCCId = [self.userToEdit valueForKeyPath:@"roles.EventRole.speech.tmCCId"];
    [self.parseDotComMgr fetchUserInfoWithUserType:Member withCompletionBlock:successBlock];
}


#pragma mark - getter and setter methods
-(NSString *)getSpeechTitle
{
    QEntryElement *speechTitle = (QEntryElement*)[self.root elementWithKey:kSpeechInfoTitleKeyName];
    return [speechTitle textValue];
}

-(void)setSpeechTitle:(NSString*)newTitle
{
    QEntryElement *speechTitle = (QEntryElement*)[self.root elementWithKey:kSpeechInfoTitleKeyName];
    [speechTitle setTextValue:newTitle];
}

- (NSString *)getRadioElementValue:(NSString*)keyPath
{
    QRadioElement *radio = (QRadioElement*)[self.root elementWithKey:keyPath];
    NSLog(@"Evaluator Value: %@", (NSString*)[radio selectedValue]);
    return (NSString*)[radio selectedValue];
}

- (NSString *)getRadioElementItem:(NSString*)keyPath
{
    QRadioElement *radio = (QRadioElement*)[self.root elementWithKey:keyPath];
    NSLog(@"Evaluator Value: %@", (NSString*)[radio selectedItem]);
    return (NSString*)[radio selectedItem];
}


- (NSNumber*)getSpeechHasIntro
{
    QBooleanElement *speechHasIntro = (QBooleanElement*)[self.root elementWithKey:kSpeechInfoHasIntroKeyName];
    NSLog(@"Has Intro: %hhd", [speechHasIntro boolValue]);
    return [NSNumber numberWithChar:[speechHasIntro boolValue]];
}



@end
