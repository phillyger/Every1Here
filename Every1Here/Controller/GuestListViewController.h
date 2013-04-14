//
//  GuestPickerViewController.h
//  Every1Here
//
//  Created by Ger O'Sullivan on 2/27/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FPPopoverController.h"
#import "GuestCommunicatorDelegate.h"
#import "GuestListViewManagerDelegate.h"
#import "ParseDotComManagerDelegate.h"

@class ParseDotComManager;
@class SocialNetworkUtilities;

@interface GuestListViewController : UIViewController <FPPopoverControllerDelegate, GuestListViewManagerDelegate, ParseDotComManagerDelegate>
{
    FPPopoverController *popover;
}



@property (nonatomic, strong) NSMutableDictionary *guestFullListDict;
@property (nonatomic, strong) NSMutableDictionary *guestAttendeeListDict;
@property (nonatomic, strong) NSMutableArray *guestAttendeeListForSlType;
@property (nonatomic, strong) NSMutableArray *guestFullListForSlType;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;
@property (nonatomic, strong) E1HObjectConfiguration *objectConfiguration;
@property (strong) ParseDotComManager *parseDotComMgr;

- (void)didSelectPopoverRow:(NSUInteger)rowNum forSocialNetworkType:(SocialNetworkType)slType;
- (void)didDeselectPopoverRow:(NSUInteger)rowNum forSocialNetworkType:(SocialNetworkType)slType;
- (void)userDidSelectGuestListNotification: (NSNotification *)note;
- (void)receivedGuestFullList:(NSArray *)guestFullList forKey:(NSString *)aKey;
- (void)updateTableContentsWithArray:(NSArray *)newGuestAttendeeList forKey:(NSString *)aKey;

@end
