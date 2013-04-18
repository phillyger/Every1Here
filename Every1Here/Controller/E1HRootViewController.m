//
//  E1HRootViewController.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "E1HRootViewController.h"
#import "EventSegmentedControlViewController.h"
#import "BaseViewController.h"

@interface E1HRootViewController ()
@property (nonatomic, weak) EventSegmentedControlViewController *eventSegmentedControlViewController;
@property (nonatomic, weak) BaseViewController *eventListViewController;

//@property (retain, nonatomic) UIViewController *currentViewController;
//@property (weak, nonatomic) UIView *contentView;
@end

@implementation E1HRootViewController


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
    
    self.eventSegmentedControlViewController.eventListViewController = (EventListViewController *)self.eventListViewController;
    self.eventSegmentedControlViewController.currentViewController = self.eventListViewController;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"eventSegmentedControl"])
    {
        NSLog(@"Tapped Segmented Control");
        self.eventSegmentedControlViewController =
        segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"eventList"])
    {
        NSLog(@"Tapped Event List");
        self.eventListViewController =
        segue.destinationViewController;
    }
}



@end
