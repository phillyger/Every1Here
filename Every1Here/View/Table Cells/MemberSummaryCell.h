//
//  MemberSummaryCell.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/11/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

@class PICircularProgressView;

@interface MemberSummaryCell : UITableViewCell

@property (strong) IBOutlet UILabel *displayNameLabel;
@property (strong) IBOutlet UIImageView *avatarView;

@property (strong) IBOutlet UIImageView * rolesView_1;
@property (strong) IBOutlet UIImageView * rolesView_2;
@property (strong) IBOutlet UIImageView * rolesView_3;

@property (strong) IBOutlet UIImageView * attendance;
@property (weak, nonatomic) IBOutlet PICircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *latestSpeech;

- (UIImageView *)rolesViewWithOffset:(NSUInteger )offset;

@end
