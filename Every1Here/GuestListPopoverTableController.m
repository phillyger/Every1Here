//
//  DemoTableControllerViewController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "GuestListPopoverTableController.h"
#import "GuestListViewController.h"
#import "GuestManagerDelegate.h"
#import "MeetupDotComManager.h"
#import "TwitterDotComManager.h"
#import "AnseoObjectConfiguration.h"
#import "GuestSelectedCell.h"
#import "UIImageView+AFNetworking.h"
#import "Event.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "SocialNetworkUtilities.h"


static NSString *guestCellReuseIdentifier = @"guestSelectedCell";

@interface GuestListPopoverTableController ()
{
    Event *event;
    MBProgressHUD *hud;
    NSString *slTypeString;
//    NSMutableArray *guestFullListForSlType;
    
}

@property (nonatomic, strong) NSMutableIndexSet *selectedIndexes;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (void)setSelectedIndexesFromArray:(NSArray *)attendeeList WithArray:(NSArray *)fullGuestList;

@end

@implementation GuestListPopoverTableController
@synthesize delegate=_delegate;
@synthesize slType;
@synthesize meetupDotComMgr;
@synthesize twitterDotComMgr;
@synthesize objectConfiguration;
@synthesize guestCell;
@synthesize event;
//@synthesize guestListFullDict;
//@synthesize guestListAttendeeDict;
@synthesize guestFullListForSlType;
@synthesize guestAttendeeListForSlType;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
       
    UINib *guestCellNib = [UINib nibWithNibName:@"GuestSelectedCell" bundle:nil];
    [self.tableView registerNib:guestCellNib
         forCellReuseIdentifier:guestCellReuseIdentifier];
    
    self.objectConfiguration = [[AnseoObjectConfiguration alloc] init];
    
//    guestFullListForSlType = [[NSMutableArray alloc] init];

//    [self.event clearGuestList];
    
    slTypeString = (NSString *)[SocialNetworkUtilities formatTypeToString:slType];
    [self fetchGuestListTableContent];
    
//  [(EventListTableDataSource *)self.dataSource setAvatarStore: [objectConfiguration avatarStore]];    

}


- (void)viewDidDisappear:(BOOL)animated {
     NSLog(@"indexes: %@", [self selectedIndexes]);
    NSMutableArray *newGuestAttendeeList = [[NSMutableArray alloc] init];
    NSLog(@"Popover disappeared");
    [[self guestFullListForSlType] enumerateObjectsAtIndexes:[self selectedIndexes] options:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        User *user = (User *)obj;
        
        NSLog(@"Selected user: %@ at index %d", [user displayName], idx );
        [newGuestAttendeeList addObject:user];
    }];
    
    [[self delegate] updateTableContentsWithArray:newGuestAttendeeList forKey:slTypeString];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setSelectedIndexesFromArray:(NSArray *)childList WithArray:(NSArray *)parentList {

    
    BOOL (^test)(id obj, NSUInteger idx, BOOL *stop);
    
    test = ^(id obj, NSUInteger idx, BOOL *stop) {
            if ([childList containsObject: obj]) {
                return YES;
        }
        return NO;
    };
    
    NSIndexSet *indexes = [parentList indexesOfObjectsPassingTest:test];
    
    NSLog(@"indexes: %@", indexes);
    
    [self setSelectedIndexes:[indexes mutableCopy]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [self.guestFullListForSlType count] ? :1;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    UITableViewCell *cell = nil;
    if ([[self guestFullListForSlType] count] > 0) {
        User *user = [[self guestFullListForSlType] objectAtIndex:[indexPath row]];
        guestCell = [aTableView dequeueReusableCellWithIdentifier:guestCellReuseIdentifier forIndexPath:indexPath];
        guestCell.displayNameLabel.text = user.displayName;
        [guestCell.avatarView setImageWithURL:user.avatarURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.png"]];
        
        if ([self.selectedIndexes containsIndex:indexPath.row]) {
            [guestCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [guestCell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        cell = guestCell;
        guestCell = nil;
    } else {
        cell = [aTableView dequeueReusableCellWithIdentifier:@"placeholder"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeholder"];
        }
        //cell.textLabel.text = @"There was a problem connecting to the network.";
        
    }
    return cell;
}



#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    self.selected = NO;
    
    [self.selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSLog(@"SelectIndex is %d vs current index is %d", idx, [indexPath row]);
        if (idx == [indexPath row]) {
            self.selected = YES;
            *stop = YES;
        }
    }];
    
    if (self.isSelected) {
        [self.selectedIndexes removeIndex:[indexPath row]];
        if([self.delegate respondsToSelector:@selector(didDeselectPopoverRow:forSocialNetworkType:)])
        {
//            [self.delegate didDeselectPopoverRow:[indexPath row] forSocialNetworkType:slType];
        }
    } else {
        [self.selectedIndexes addIndex:[indexPath row]];
        if([self.delegate respondsToSelector:@selector(didSelectPopoverRow:forSocialNetworkType:)])
        {
//            [self.delegate didSelectPopoverRow:[indexPath row] forSocialNetworkType:slType];
        }
    }
    
    [self.tableView reloadData];

    

}




#pragma mark - Guest Manager delegate


- (void)guestsReceivedForEvent:(Event *)event {
    
}

- (void)didReceiveGuests:(NSArray *)guests {

    // Remove HUD
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    // cache guest list from WS for specific social type key.
    NSLog(@"Did Receive Guests!");
    //[self.delegate setGuestListFullDictWithArray:guests forKey:slType];
    [self setGuestFullListForSlType:[guests mutableCopy]];
    
    // Should only have to send this message the first time it loads.
    // Subsequent calls are cached.
    [self.delegate receivedGuestFullList:[self guestFullListForSlType] forKey:slTypeString];
    [self.tableView reloadData];
}


-(void)retrievingGuestsFailedWithError:(NSError *)error {}



#pragma mark - fetch methods
- (void)fetchGuestListTableContent
{
    
    // An set of indexes
    self.selectedIndexes = [[NSMutableIndexSet alloc] init];
//    guestFullListForSlType = (NSMutableArray *)[self.guestListFullDict objectForKey:slTypeString];
    

    if ([self.guestFullListForSlType count] > 0) {
//        [event setGuestList:guestFullListForSlType];
//        NSArray *attendeeListForSlType = (NSArray *)[self.guestListAttendeeDict objectForKey:slTypeString];
        
        [self setSelectedIndexesFromArray:[self guestAttendeeListForSlType] WithArray:[self guestFullListForSlType]];
    
        
        [self setPopoverTitleWithString:slTypeString];
        
    } else {
        [self fetchGuestListFromWS];
    }
    
    [self.tableView reloadData];
    
}

-(void)fetchGuestListFromWS {
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.dimBackground = YES;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    hud.labelText = @"Loading..";
    [hud show:TRUE];
    
    
    [self setPopoverTitleWithString:slTypeString];
    
    switch (self.slType)
    {
        case Meetup:
            self.meetupDotComMgr = [objectConfiguration meetupDotComManager];
            self.meetupDotComMgr.guestDelegate = self;
            //        Event *selectedEvent = (Event *)[(GuestListTableDataSource *)self.dataSource event];
            [self.meetupDotComMgr fetchGuestsForGroupName:@"Panorama-Toastmasters"];
            break;
        case Facebook:
            
            NSLog(@"Welcome to Facebook!");
            
            break;
            
        case LinkedIn:
            
            NSLog(@"Welcome to LinkedIN!");
            
            break;
            
        case Twitter:
            self.twitterDotComMgr = [objectConfiguration twitterDotComManager];
            self.twitterDotComMgr.guestDelegate = self;
            [self.twitterDotComMgr fetchGuestsForGroupName:@"panoramatoast"];
            
            NSLog(@"Welcome to Twitter!");
            
            break;
            
        default:
            
            NSLog(@"Welcome to Meetup!");
            
            break;
            
    }
    
}


-(void)setPopoverTitleWithString:(NSString *)title {
    self.title = [NSString stringWithFormat:@"Guests - %@", title];
}


@end
