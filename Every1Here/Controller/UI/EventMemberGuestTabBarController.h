//
//  EventMemberGuestTabBarController.h
//  Anseo
//
//  Created by Ger O'Sullivan on 2/27/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventMemberGuestTabBarController : UITabBarController

@property (nonatomic, strong) Event *selectedEvent;

@end
