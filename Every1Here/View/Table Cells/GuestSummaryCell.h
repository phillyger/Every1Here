//
//  GuestSummaryCell.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/22/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestSummaryCell : UITableViewCell

@property (strong) IBOutlet UILabel *displayNameLabel;
@property (strong) IBOutlet UIImageView *avatarView;

@property (strong) IBOutlet UIImageView * attendance;

@end
