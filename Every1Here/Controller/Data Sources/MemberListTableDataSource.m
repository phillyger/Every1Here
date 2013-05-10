//
//  MemberListTableDataSource.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/11/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "MemberListTableDataSource.h"
#import "UIImageView+AFNetworking.h"
#import "MemberSummaryCell.h"
#import "Event.h"
#import "EventRole.h"
#import "User.h"

#import <QuartzCore/QuartzCore.h>
#import "AvatarStore.h"


static NSString *memberCellReuseIdentifier = @"memberCell";

@interface MemberListTableDataSource ()
{
        NSDictionary *meetingRoleIconDict;
        NSDictionary *meetingRoleDict;
}
@end

@implementation MemberListTableDataSource
@synthesize event;
@synthesize memberCell;
@synthesize avatarStore;
@synthesize tableView;
@synthesize notificationCenter;


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [[event allMembers] count] ? :1;
}

- (User *)memberForIndexPath:(NSIndexPath *)indexPath {
    
    return [[event allMembers] objectAtIndex:[indexPath row]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotification *note = [NSNotification notificationWithName: MemberListDidSelectMemberNotification object: [self memberForIndexPath: indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification: note];
}



- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([[event allMembers]count]) {
        User *user = [[event allMembers] objectAtIndex:[indexPath row]];
        memberCell = [aTableView dequeueReusableCellWithIdentifier:memberCellReuseIdentifier forIndexPath:indexPath];
        
        memberCell.displayNameLabel.text = user.displayName;
        
        
        /*
         *  Icon loading to be refactored for async background thread call.
         */
        TMEventRoles roles = [[user getRole:@"EventRole"] eventRoles];
        meetingRoleIconDict = [[user getRole:@"EventRole"] mapFieldsToIconsSmall];
        meetingRoleDict = [[user getRole:@"EventRole"] mapFieldsToRoles];
        
        [[memberCell rolesViewWithOffset:1] setImage:nil];
        [[memberCell rolesViewWithOffset:2] setImage:nil];
        [[memberCell rolesViewWithOffset:3] setImage:nil];
        
        __block NSUInteger roleCount = 0;
        [meetingRoleDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            NSLog(@"key %@: value %u", key, [obj unsignedIntegerValue]);
            if (roles & [obj unsignedIntegerValue]) {
                // Found a matching role
                roleCount++;
//                [memberCell setValue:[UIImage imageNamed:@"mic-28x28.jpg"] forKey:@"roleView_1"];
                [[memberCell rolesViewWithOffset:roleCount] setImage:[UIImage imageNamed:meetingRoleIconDict[key]]];
            }
        }];
        
        [memberCell.attendance setImage:nil];
        if ([[user getRole:@"EventRole"] isAttending]) {
            [memberCell.attendance setImage:[UIImage imageNamed:@"imgOn"]];
        }
            
        

//        NSData *avatarData = [avatarStore dataForURL: user.avatarURL];
//        if (avatarData) {
//        if (user.avatarURL) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:user.avatarURL];
        __weak UIImageView *imageView = memberCell.avatarView;
        
        [memberCell.avatarView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imageView.image = image;

            // use the image's layer to mask the image into a circle
            imageView.layer.cornerRadius = roundf(imageView.frame.size.width/2.0);
            imageView.layer.masksToBounds = YES;

            [imageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [imageView.layer setBorderWidth:1.5f];
            [imageView.layer setShadowColor:[UIColor blackColor].CGColor];
            [imageView.layer setShadowOpacity:0.8];
            [imageView.layer setShadowRadius:3.0];
            [imageView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
            

        } failure:NULL];


            
//        }
        
        cell = memberCell;
        memberCell = nil;
    } else {
        cell = [aTableView dequeueReusableCellWithIdentifier:@"placeholder"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeholder"];
        }
//        cell.textLabel.text = @"There was a problem connecting to the network.";
        
    }
    return cell;
}

- (void)registerForUpdatesToAvatarStore:(AvatarStore *)store {
    [notificationCenter addObserver:self
                           selector:@selector(avatarStoreDidUpdateContent:)
                               name:AvatarStoreDidUpdateContentNotification
                             object: store];
}

- (void)removeObservationOfUpdatesToAvatarStore: (AvatarStore *)store {
    [notificationCenter removeObserver:self
                                  name:AvatarStoreDidUpdateContentNotification
                                object:store];
}

- (void)avatarStoreDidUpdateContent:(NSNotification *)notification {
    [tableView reloadData];
}


@end

NSString *MemberListDidSelectMemberNotification = @"MemberListDidSelectMemberNotification";

