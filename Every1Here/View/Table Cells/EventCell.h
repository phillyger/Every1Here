//
//  EventCell.h
//  Presence
//
//  Created by Ger O'Sullivan on 12/2/12.
//  Copyright (c) 2012 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;

// date label properties
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *starttimeLabel;
@end
