/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  MemberListViewController.h
 *  Every1Here
 *
 *  Created by Ger O'Sullivan on 2/21/13.
 *  Copyright (c) 2013 Brilliant Age. All rights reserved.
 *
 *  Handles the Member table list view.
 *
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

#import "BaseViewController.h"
#import "MemberManagerDelegate.h"
#import "ParseDotComManagerDelegate.h"


@interface MemberListViewController :BaseViewController <MemberManagerDelegate, ParseDotComManagerDelegate>


@end


