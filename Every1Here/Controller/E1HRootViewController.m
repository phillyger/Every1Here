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
    
    self.eventSegmentedControlViewController.eventListViewController = self.eventListViewController;
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

#pragma mark - Segmented Control
//- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
//    UIViewController *vc;
//    switch (index) {
//        case 0:
//            vc = [[UpcomingEventListViewController alloc] init];
//            break;
//        case 1:
//            vc = [[PastEventListViewController alloc] init];
//            break;
//    }
//    return vc;
//}
//
//- (void)segmentedControlChangedValue:(HMSegmentedControl *)aSegmentedControl {
//	NSLog(@"Selected index %i (via UIControlEventValueChanged)", aSegmentedControl.selectedSegmentIndex);
//    UIViewController *vc = [self viewControllerForSegmentIndex:aSegmentedControl.selectedSegmentIndex];
//    [self.eventListViewController addChildViewController:vc];
//    [self.eventListViewController transitionFromViewController:self.currentViewController toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//        [self.currentViewController.view removeFromSuperview];
//        vc.view.frame = self.contentView.bounds;
//        [self.contentView addSubview:vc.view];
//    } completion:^(BOOL finished) {
//        [vc didMoveToParentViewController:self];
//        [self.currentViewController removeFromParentViewController];
//        self.currentViewController = vc;
//    }];
//    self.navigationItem.title = vc.title;
//    
//}


@end
