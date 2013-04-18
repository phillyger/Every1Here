//
//  GuestListTableDataSource.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/22/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "GuestListTableDataSource.h"
#import "UIImageView+AFNetworking.h"
#import "GuestSummaryCell.h"
#import "Event.h"
#import "User.h"
#import "AvatarStore.h"
#import "GuestAttendeeListSection.h"
#import <QuartzCore/QuartzCore.h>

NSString *guestCellReuseIdentifier = @"guestSummaryCell";

@implementation GuestListTableDataSource
@synthesize event;
@synthesize guestCell;
@synthesize avatarStore;
@synthesize tableView;
@synthesize notificationCenter;



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (event.sortedSocialNetworkTypes)
		return [event.sortedSocialNetworkTypes count];
	else
		return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (event.sortedSocialNetworkTypes > 0)
		return event.sortedSocialNetworkTypes[section];
	else
		return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[event allGuests] count])
    {
        NSString *sectionName = event.sortedSocialNetworkTypes[section];
        
        GuestAttendeeListSection *section = [[GuestAttendeeListSection alloc] initWithArray:(NSArray *)[event filterBySocialNetwork:sectionName]];
        
        return [section.users count];
    } else {
        
        return 1;
    }
}

- (User *)guestForIndexPath:(NSIndexPath *)indexPath {
//    return [[event allGuests] objectAtIndex: [indexPath row]];
     NSString *sectionName = event.sortedSocialNetworkTypes[indexPath.section];
    return [[event filterBySocialNetwork:sectionName] objectAtIndex:[indexPath row]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotification *note = [NSNotification notificationWithName: GuestListDidSelectGuestNotification object: [self guestForIndexPath: indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification: note];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([[event allGuests]count]) {
//        User *user = [[event allGuests] objectAtIndex:[indexPath row]];
        NSString *sectionName = event.sortedSocialNetworkTypes[indexPath.section];
        User *user = [[event filterBySocialNetwork:sectionName] objectAtIndex:[indexPath row]];
        
        guestCell = [aTableView dequeueReusableCellWithIdentifier:guestCellReuseIdentifier forIndexPath:indexPath];

        
        guestCell.displayNameLabel.text = user.displayName;
        
        //        NSData *avatarData = [avatarStore dataForURL: user.avatarURL];
        //        if (avatarData) {
//        [guestCell.avatarView setImageWithURL:user.avatarURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.png"]];
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:user.avatarURL];
        __weak UIImageView *imageView = guestCell.avatarView;
        [guestCell.avatarView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imageView.image = image;
            CALayer *layer = imageView.layer;
            layer.masksToBounds = YES;
            layer.cornerRadius = 10.0f;
        } failure:NULL];
        
        
        cell = guestCell;
        guestCell = nil;
    } else {
        cell = [aTableView dequeueReusableCellWithIdentifier:@"placeholder"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeholder"];
        }
        
        
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


NSString *GuestListDidSelectGuestNotification = @"GuestListDidSelectGuestNotification";

