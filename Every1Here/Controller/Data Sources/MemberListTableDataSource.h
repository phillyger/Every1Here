//
//  MemberListTableDataSource.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/11/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;
@class MemberSummaryCell;
@class AvatarStore;

@interface MemberListTableDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong) Event *event;
@property (weak) IBOutlet MemberSummaryCell *memberCell;
@property (strong) AvatarStore *avatarStore;
@property (weak) UITableView *tableView;
@property (strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;



- (void)registerForUpdatesToAvatarStore: (AvatarStore *)store;
- (void)removeObservationOfUpdatesToAvatarStore: (AvatarStore *)store;
- (void)avatarStoreDidUpdateContent: (NSNotification *)notification;
- (void)configureSectionData;

@end

extern NSString *MemberListDidSelectMemberNotification;