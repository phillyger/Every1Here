//
//  EventSegmentedControlViewController.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 4/13/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventListViewController;

@interface EventSegmentedControlViewController : UIViewController

@property (nonatomic, strong) EventListViewController *eventListViewController;
@property (retain, nonatomic) UIViewController *currentViewController;
@end
