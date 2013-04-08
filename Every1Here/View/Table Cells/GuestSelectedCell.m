//
//  GuestSelectedCell.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 3/6/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestSelectedCell.h"

@implementation GuestSelectedCell
@synthesize displayNameLabel;
@synthesize avatarView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
