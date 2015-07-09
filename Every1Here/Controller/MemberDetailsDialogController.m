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
#import "EventRoleDefault.h"
#import "SpeakerInfoViewController.h"
#import "MZFormSheetController.h"
#import "E1HObjectConfiguration.h"
#import "ParseDotComManager.h"
#import "CommonUtilities.h"
#import "Speech.h"

static NSString* kSpeechInfoEvaluatorKeyName = @"speechEvaluator";
static NSString* kSpeechInfoTMCCIdKeyName = @"speechTMCCId";
static NSString* kSpeechInfoTitleKeyName = @"speechTitle";
static NSString* kSpeechInfoHasIntroKeyName = @"speechHasIntro";
static NSString* kSpeechInfoSpeakingOrderKeyName = @"speakingOrder";

static NSString* kSpeechInfoSpeakingOrderFieldKeyPath = @"roles.EventRole.speech.speakingOrder";
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
    
    id thisEventRole;
    
    NSNumber *postEventRoles;
    NSNumber *postAttendance;
    NSNumber *postGuestCount;
    NSString *postDisplayName;
    NSString *postSpeakingOrder;
    
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

//- (void)createSampleFormRoot;
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

    
    //-------------------------------------------------------
    // Load the Quick Dialog form names mapping.
    //-------------------------------------------------------
    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:@"E1H_QuickDialog_FileNames" ofType:@"plist"];
    NSDictionary *pListInfoDictForE1HQuickDialog = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
    
    NSNumber *eventCode = [self.userToEdit eventCode];
    
    if (self.newUser) {
        self.root =[[QRootElement alloc] initWithJSONFile:[pListInfoDictForE1HQuickDialog valueForKey:@"member_details_new"]];
    } else if ([eventCode isEqualToNumber:@1000]){
        self.root =[[QRootElement alloc] initWithJSONFile:[pListInfoDictForE1HQuickDialog valueForKey:@"member_details_default_edit"]];
    } else if ([eventCode isEqualToNumber:@2000]){
        self.root =[[QRootElement alloc] initWithJSONFile:[pListInfoDictForE1HQuickDialog valueForKey:@"member_details_speech_contest_edit"]];
    }
    
    self.quickDialogTableView = [[QuickDialogTableView alloc] initWithController:self];
    self.view = self.quickDialogTableView;
    
    
    
    [CommonUtilities showProgressHUD:self.view];
    
    [self fetchMemberListTableContentWithCompletionBlock:^(NSArray *userList, NSArray *tmCCList, BOOL success) {
        
//        if (!success)
//            return;

        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateSpeakerInfoTableWithUserList:userList withTMCCList:tmCCList];
//            [self performSelectorOnMainThread:@selector(fetchedData:)
//                                   withObject:data waitUntilDone:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [CommonUtilities hideProgressHUD:self.view];
            });
        });
    }];
}

- (void)updateSpeakerInfoTableWithUserList:(NSArray *)userList withTMCCList:(NSArray *)tmCCList
{
    
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
    
    /** Calculate the current speech to display **/
    __block NSInteger nextSpeechNumber;
    EventRoleBase *eventRole = [self.userToEdit getRole:@"EventRole"];
    Speech *speech = [eventRole speech];
    if (speech != nil) {
        NSString *tmCCId = [speech tmCCId];
        if (tmCCId!=nil && ![tmCCId isEqualToString:@""]) {
            [tmCCList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *tmCCDict = (NSDictionary*)obj;
                if ([tmCCId isEqualToString:[tmCCDict valueForKey:@"objectId"]]) {
                    nextSpeechNumber = ([[tmCCDict valueForKey:@"projectNum"] integerValue] - 1);
                }
            }];
        } else {
            nextSpeechNumber = [[self.userToEdit valueForKeyPath:@"compComm"] integerValue];
            if (nextSpeechNumber >= 10) {
                nextSpeechNumber = 9;
            }
        }
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
    //        speechTitle.enabled= [isSpeaker boolValue];
    speechTitle.enabled= YES;
    speechTitle.key = kSpeechInfoTitleKeyName;
    [sectionSpeakerInfo addElement:speechTitle];
    
    
    QBooleanElement *speechHasIntro = [[QBooleanElement alloc] initWithTitle:@"Has Intro?" BoolValue:[[self.userToEdit valueForKeyPath:kSpeechInfoHasIntroFieldKeyPath]boolValue]];
    //        speechHasIntro.enabled = [isSpeaker boolValue];
    speechHasIntro.enabled = YES;
    speechHasIntro.key = kSpeechInfoHasIntroKeyName;
    [sectionSpeakerInfo addElement:speechHasIntro];
    
    
    QRadioElement *speechNumber = [[QRadioElement alloc] init];
    speechNumber.selected = nextSpeechNumber;
    [speechNumber setValues:tmCCListSpeechId];
    [speechNumber setItems:tmCCListSpeechNumberString];
    speechNumber.title = @"Speech #";
    //        speechNumber.enabled= [isSpeaker boolValue];
    speechNumber.enabled= YES;
    speechNumber.key = kSpeechInfoTMCCIdKeyName;
    [sectionSpeakerInfo addElement:speechNumber];
    
    
    QRadioElement *speechEvaluator = [[QRadioElement alloc] init];
    speechEvaluator.selected = currentEvaluatorSelected;
    speechEvaluator.title = @"Evaluator";
    [speechEvaluator setValues:userIdList];
    [speechEvaluator setItems:userNameList];
    speechEvaluator.key = kSpeechInfoEvaluatorKeyName;
    //        speechEvaluator.enabled = [isSpeaker boolValue];
    speechEvaluator.enabled = YES;
    [sectionSpeakerInfo addElement:speechEvaluator];
    
    QEntryElement *speakingOrder = [[QEntryElement alloc] initWithTitle:@"Speaking Order" Value:[self.userToEdit valueForKeyPath:kSpeechInfoSpeakingOrderFieldKeyPath] Placeholder:@"Speaking Order"];
    //        speakingOrder.enabled= [isSpeaker boolValue];
    speakingOrder.enabled= YES;
    speakingOrder.key = kSpeechInfoSpeakingOrderKeyName;
    [sectionSpeakerInfo addElement:speakingOrder];
    
    
    [self.root addSection:sectionSpeakerInfo];

//    [self.quickDialogTableView layoutIfNeeded];
//    [self.quickDialogTableView rel];

//        [self.quickDialogTableView setNeedsDisplay];
//    [self.quickDialogTableView setNeedsLayout];
//    [self.quickDialogTableView reloadCellForElements:speechTitle, speechHasIntro, speechNumber, speechEvaluator, speakingOrder, nil];
    
    //        [self.quickDialogTableView reloadData];
    
    //        [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //            //        NSLog(@"key %@: value %d", key, [obj integerValue]);
    //
    //            if ([key isEqualToString:@"isSpeaker"]) {
    //                __weak QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];
    //                thisElement.onValueChanged = ^(QRootElement *el){
    ////                    NSLog(@"Flag changed");
    ////                    NSLog(@"%@", [thisElement numberValue]);
    ////                    NSLog(@"%@", [thisElement key]);
    //
    //                    if ([self isEventRolesSelected]){
    //                        [self markUserInAttendance:YES];
    //                        [self.quickDialogTableView reloadData];
    //                    }
    //
    //
    ////                    QRadioElement *speechEvaluator = (QRadioElement*)[self.root elementWithKey:kSpeechInfoEvaluatorKeyName];
    ////                    QRadioElement *speechNumber = (QRadioElement*)[self.root elementWithKey:kSpeechInfoTMCCIdKeyName];
    ////                    QBooleanElement *speechHasIntro = (QBooleanElement*)[self.root elementWithKey:kSpeechInfoHasIntroKeyName];
    ////                    QEntryElement *speechTitle = (QEntryElement*)[self.root elementWithKey:kSpeechInfoTitleKeyName];
    ////                    speechEvaluator.enabled = [thisElement boolValue];
    ////                    speechNumber.enabled = [thisElement boolValue];
    ////                    speechTitle.enabled = [thisElement boolValue];
    ////                    speechHasIntro.enabled = [thisElement boolValue];
    ////                    speakingOrder.enabled = [thisElement boolValue];
    //
    //                    speechEvaluator.enabled = YES;
    //                    speechNumber.enabled = YES;
    //                    speechTitle.enabled = YES;
    //                    speechHasIntro.enabled = YES;
    //                    speakingOrder.enabled = YES;
    //
    //
    //                    [self.quickDialogTableView reloadCellForElements:speechEvaluator, speechNumber, speechHasIntro, speechTitle, speakingOrder, nil];
    //
    //                     [self.quickDialogTableView reloadData];
    //                    *stop = YES;
    //                };
    //            } else if ([key isEqualToString:@"isToastmaster"]) {
    //                __weak QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];
    //                thisElement.onValueChanged = ^(QRootElement *el){
    //                    //                    NSLog(@"Flag changed");
    //                    //                    NSLog(@"%@", [thisElement numberValue]);
    //                    //                    NSLog(@"%@", [thisElement key]);
    //
    //                    if ([self isEventRolesSelected]){
    //                        [self markUserInAttendance:YES];
    //                        [self.quickDialogTableView reloadData];
    //                    }
    //                };
    //            }
    //
    //        }];
    
    [self.quickDialogTableView setNeedsDisplay];
    [self.quickDialogTableView reloadData];
    
    
    
    
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

            [[self userToEdit] setValue:postSpeakingOrder forKeyPath:kSpeechInfoSpeakingOrderFieldKeyPath];
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
            [self.userToEdit addRole:@"EventRoleDefault" forKey:@"EventRole"];
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
//        NSLog(@"key: %@", [element key]);
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

- (BOOL)isEventRolesSelected
{
    NSLog(@"Running isEventRolesSelected...");
    if ([[self computeEventRoleCount] intValue]> 0) {
        return true;
    }
    return false;
}


- (void)markUserInAttendance:(BOOL)isAttending {
    
    QBooleanElement *attendanceElement = (QBooleanElement *)[self.root elementWithKey: @"attendance"];
    [attendanceElement setBoolValue:isAttending];
    
}

- (void)unmaskEventRoles:(TMEventRoles)roles {

    [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"key %@: value %d", key, [obj integerValue]);
        __weak QBooleanElement *thisElement = (QBooleanElement *)[self.root elementWithKey: key];
        
        thisElement.onValueChanged = ^(QRootElement *el){
            if ([self isEventRolesSelected]){
                [self markUserInAttendance:YES];
                [self.quickDialogTableView reloadData];
            }
            
                
        };

        
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
    
    // Pre Speaking Order
    NSString *preSpeakingOrder = [[self userToEdit] valueForKeyPath:kSpeechInfoSpeakingOrderFieldKeyPath];
    
    postEventRoles = [self computeEventRoleCount];
    postDisplayName = [self computeDisplayName];
    postAttendance = [NSNumber numberWithInt:[[(QBooleanElement *)[[self root] elementWithKey:@"attendance"] numberValue] intValue]] ;
    postGuestCount = [NSNumber numberWithInt:[[(QPickerElement *)[[self root] elementWithKey:@"guestCount"] value] intValue]];
    
    postSpeechTitle = [self getSpeechTitle];
    postSpeechEvaluatorId = [self getRadioElementValue:kSpeechInfoEvaluatorKeyName];
    postSpeechTMCCId = [self getRadioElementValue:kSpeechInfoTMCCIdKeyName];
    postSpeechHasIntro = [self getSpeechHasIntro];
    postSpeakingOrder = [self getSpeakingOrder];
    
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
        || (![preSpeechTMCCId isEqualToString:postSpeechTMCCId])
        || (![preSpeakingOrder isEqualToString:postSpeakingOrder]))
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


-(NSString *)getSpeakingOrder
{
    QEntryElement *speakingOrder = (QEntryElement*)[self.root elementWithKey:kSpeechInfoSpeakingOrderKeyName];
    return [speakingOrder textValue];
}

-(void)setSpeakingOrder:(NSNumber*)newSpeakingOrder
{
    QEntryElement *speakingOrder = (QEntryElement*)[self.root elementWithKey:kSpeechInfoSpeakingOrderKeyName];
//    [speakingOrder setValue:[NSNumber numberWithInteger:[[speakingOrder textValue] integerValue]]];
    [speakingOrder setValue:[speakingOrder textValue]];
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
    NSLog(@"Has Intro: %hhd", (char)[speechHasIntro boolValue]);
    return [NSNumber numberWithChar:[speechHasIntro boolValue]];
}



@end
