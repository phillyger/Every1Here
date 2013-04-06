//
//  MemberSummaryCell.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/11/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberSummaryCell.h"

@implementation MemberSummaryCell
@synthesize attendance;
@synthesize displayNameLabel;
@synthesize avatarView;
@synthesize rolesView_1, rolesView_2, rolesView_3;

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

- (UIImageView *)rolesViewWithOffset:(NSUInteger )offset {
    
    UIImageView *fieldToBind;
    
    switch (offset) {
        case 1:
            fieldToBind = [self rolesView_1];
            break;
        case 2:
            fieldToBind = [self rolesView_2];
            break;
        case 3:
            fieldToBind = [self rolesView_3];
            break;
        default:
            break;
    }
    
    return fieldToBind;

}

@end
