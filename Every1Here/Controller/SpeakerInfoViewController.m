//
//  SpeakerInfoViewController.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/26/14.
//  Copyright (c) 2014 Brilliant Age. All rights reserved.
//

#import "SpeakerInfoViewController.h"
#import "QuickDialog.h"
#import "E1HObjectConfiguration.h"
#import "ParseDotComManager.h"

@class E1HObjectConfiguration;
@class ParseDotComManager;

@interface SpeakerInfoViewController ()

@property (strong) E1HObjectConfiguration *objectConfiguration;
@property (strong) ParseDotComManager *parseDotComMgr;

@end

@implementation SpeakerInfoViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        QRootElement *root =[[QRootElement alloc] init];
        
        
        self.root = root;
        self.resizeWhenKeyboardPresented = YES;
    }
    return self;
}
//
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
    
    
}
//
- (void)loadView {
    [super loadView];
    
    
    //-------------------------------------------------------
    // Load the Quick Dialog form names mapping.
    //-------------------------------------------------------
//    NSString *pathToPList=[[NSBundle mainBundle] pathForResource:@"E1H_QuickDialog_FileNames" ofType:@"plist"];
//    NSDictionary *pListInfoDictForE1HQuickDialog = [[NSDictionary alloc] initWithContentsOfFile:pathToPList];
//    
//    self.root =[[QRootElement alloc] initWithJSONFile:[pListInfoDictForE1HQuickDialog valueForKey:@"speaker_info"]];
//    

    

    
    self.quickDialogTableView = [[QuickDialogTableView alloc] initWithController:self];
    self.view = self.quickDialogTableView;

}

- (void)viewDidAppear:(BOOL)animated
{
//    self.view.frame = CGRectMake(0, 0, 320, 400);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self fetchMemberListTableContent];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - QuickDialog delegate methods
-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath{
    
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
/*---------------------------------------------------------------------------
 *
 *--------------------------------------------------------------------------*/
//- (void)fetchMemberListTableContent
//{
//    self.objectConfiguration = [[E1HObjectConfiguration alloc] init];
//    self.parseDotComMgr = [self.objectConfiguration parseDotComManager];
//    self.parseDotComMgr.parseDotComDelegate = self;
//   
//    [self.parseDotComMgr fetchUsersWithUserType:Member];
//}

#pragma mark - ParseDotComManager delegate
-(void)didFetchUsers:(NSArray *)userList forUserType:(UserTypes)userType
{
    NSLog(@"Success!! We updated an existing %d record in Parse", userType);
    NSMutableArray *userNameList = [[NSMutableArray alloc] initWithObjects:@"-Select One-", nil];
    
    
    for (User *thisUser in userList) {
        NSString *firstName = [thisUser firstName];
        NSString *lastName = [thisUser lastName];
        [userNameList addObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
    }
    
    // Do any additional setup after loading the view.

    QSection *sectionElement = (QSection*)[self.root sectionWithKey:@"first"];

    QRadioElement *radioToModify = (QRadioElement*)[self.root elementWithKey:@"evaluator"];
    NSInteger selected = [radioToModify selected];
    
    [sectionElement.elements removeObject:radioToModify];
    QRadioElement *newRadioElement = [[QRadioElement alloc] initWithItems:userNameList selected:selected title:@"Evaluator"];
    newRadioElement.key = @"evaluator";
    [sectionElement insertElement:newRadioElement atIndex:2];
    
    [self.quickDialogTableView reloadData];

}

- (void)didInsertAttendanceWithOutput:(NSArray *)objectNotationList {}
- (void)didInsertUserForUserType:(UserTypes)userType withOutput:(NSArray *)objectNotationList{}
- (void)didDeleteAttendance{};


@end
