//
//  EventSegmentedControlViewController.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventSegmentedControlViewController.h"
#import "HMSegmentedControl.h"
#import "EventListViewController.h"
#import "E1HAppDelegate.h"
#import "CommonUtilities.h"

@interface EventSegmentedControlViewController ()
@property (nonatomic) HMSegmentedControl *segmentedControl;


@end


@implementation EventSegmentedControlViewController
@synthesize segmentedControl;
@synthesize eventListViewController;
@synthesize currentViewController;

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
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Upcoming", @"Past"]];

//    EventListViewController *vc = [self viewControllerForSegmentIndex:self.segmentedControl.selectedSegmentIndex];
//    [self.eventListViewController addChildViewController:vc];
//    
//    vc.tableView.frame = self.eventListViewController.tableView.bounds;
//    [self.eventListViewController.tableView addSubview:vc.tableView];
//    [vc didMoveToParentViewController:self.eventListViewController];
//    self.currentViewController = vc;

    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [segmentedControl setFrame:CGRectMake(10, 10, 300, 44)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segmented Control

- (void)segmentedControlChangedValue:(HMSegmentedControl *)aSegmentedControl {
	NSLog(@"Selected index %i (via UIControlEventValueChanged)", aSegmentedControl.selectedSegmentIndex);
    
    [CommonUtilities showProgressHUD:self.parentViewController.view];
    switch (aSegmentedControl.selectedSegmentIndex) {
        case 0:
            [(EventListViewController*)self.currentViewController setEventStatus:@"upcoming"];


            self.parentViewController.navigationItem.title = @"Upcoming Events";
            break;
        case 1:
            

            [(EventListViewController*)self.currentViewController setEventStatus:@"past"];

            self.parentViewController.navigationItem.title = @"Past Events";
            
            break;
    }
    
    E1HAppDelegate *appDelegate = (E1HAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.eventListViewController fetchEventContentForOrgId:appDelegate.parseDotComAccountOrgId withStatus:[self.eventListViewController eventStatus]];
    [CommonUtilities hideProgressHUD:self.parentViewController.view];
    
}



@end
