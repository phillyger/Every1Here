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
#import "E1HObjectConfiguration.h"
#import "GuestSelectedCell.h"
#import "UIImageView+AFNetworking.h"
#import "Event.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "SocialNetworkUtilities.h"
#import "ParseDotComManager.h"
#import "E1HAppDelegate.h"
#import "CommonUtilities.h"
#import "NSIndexSet+Operations.h"


static NSString *guestCellReuseIdentifier = @"guestSelectedCell";

@interface GuestListPopoverTableController ()
{
    Event *selectedEvent;
    MBProgressHUD *hud;
    NSString *slTypeString;
//    NSMutableArray *guestFullListForSlType;
    E1HAppDelegate *appDelegate;
    NSMutableArray *addGuests;
    NSMutableArray *removeGuests;
    
}

@property (nonatomic, strong) NSMutableIndexSet *onLoadIndices;
@property (nonatomic, strong) NSMutableIndexSet *selectedIndices;
@property (nonatomic, strong) NSIndexSet *addedIndices;
@property (nonatomic, strong) NSIndexSet *removedIndices;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (void)setSelectedIndicesFromArray:(NSArray *)attendeeList WithArray:(NSArray *)fullGuestList;
- (NSMutableArray *)mergeChildArray:(NSArray *)childList intoParentArray:(NSArray *)parentList withIndexSet:(NSIndexSet *)indexes;

@end

@implementation GuestListPopoverTableController
@synthesize delegate=_delegate;
@synthesize slType;
@synthesize meetupDotComMgr;
@synthesize parseDotComMgr;
@synthesize twitterDotComMgr;
@synthesize objectConfiguration;
@synthesize guestCell;
@synthesize selectedEvent;
@synthesize guestFullListForSlType;
@synthesize guestAttendeeListForSlType;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
       
    UINib *guestCellNib = [UINib nibWithNibName:@"GuestSelectedCell" bundle:nil];
    [self.tableView registerNib:guestCellNib
         forCellReuseIdentifier:guestCellReuseIdentifier];
    
    self.objectConfiguration = [[E1HObjectConfiguration alloc] init];
    
    self.parseDotComMgr = [objectConfiguration parseDotComManager];
    self.parseDotComMgr.parseDotComDelegate = self;
    
    appDelegate = (E1HAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    slTypeString = (NSString *)[SocialNetworkUtilities formatTypeToString:slType];
    
    // An set of indexes
    self.selectedIndices = [[NSMutableIndexSet alloc] init];
    self.onLoadIndices = [[NSMutableIndexSet alloc] init];
    
//    [self fetchGuestListTableContent];

    self.addedIndices = [[NSIndexSet alloc] init];
    self.removedIndices = [[NSIndexSet alloc] init];
    
    addGuests = [[NSMutableArray alloc] init];
    removeGuests = [[NSMutableArray alloc] init];
    
    

    [self fetchGuestListTableContent];
    
   // [(EventListTableDataSource *)self.dataSource setAvatarStore: [objectConfiguration avatarStore]];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.addedIndices = [[self onLoadIndices] relativeComplementIn:[self selectedIndices]];
    
    self.removedIndices = [[self selectedIndices] relativeComplementIn:[self onLoadIndices]];
    
    [self.addedIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSLog(@"Added Index is %d", idx);
    }];
    
    [self.removedIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSLog(@"Removed Index is %d", idx);
    }];
    
}


- (void)viewDidDisappear:(BOOL)animated {
     NSLog(@"indexes: %@", [self selectedIndices]);
    NSMutableArray *newGuestAttendeeList = [[NSMutableArray alloc] init];
    NSLog(@"Popover disappeared");
    [[self guestFullListForSlType] enumerateObjectsAtIndexes:[self selectedIndices] options:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        User *user = (User *)obj;
        
        
        NSLog(@"Selected user: %@ at index %d", [user displayName], idx );
        NSLog(@"Selected user avatar: %@ at index %d", [user avatarURL], idx );
        [newGuestAttendeeList addObject:user];
    }];
    
    
    [[self guestFullListForSlType] enumerateObjectsAtIndexes:[self addedIndices] options:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        User *user = (User *)obj;
        
        NSLog(@"Selected user: %@ at index %d", [user displayName], idx );
        NSLog(@"Selected user avatar: %@ at index %d", [user avatarURL], idx );
        [addGuests addObject:user];
    }];
    
    [[self guestFullListForSlType] enumerateObjectsAtIndexes:[self removedIndices] options:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        User *user = (User *)obj;
        
        NSLog(@"Selected user: %@ at index %d", [user displayName], idx );
        NSLog(@"Selected user avatar: %@ at index %d", [user avatarURL], idx );
        [removeGuests addObject:user];
    }];
    
    if ([removeGuests count] > 0)
        [[[self delegate] parseDotComMgr] deleteUserList:removeGuests withUserType:Guest forSocialNetworkKey:slType];
    
    if ([addGuests count] > 0)
        [[[self delegate] parseDotComMgr] insertUserList:addGuests withUserType:Guest forSocialNetworkKey:slType];
    
    
    [[self delegate] updateTableContentsWithArray:newGuestAttendeeList forKey:slTypeString];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setSelectedIndicesFromArray:(NSArray *)childList WithArray:(NSMutableArray *)parentList {

    
    BOOL (^test)(id obj, NSUInteger idx, BOOL *stop);
    
    NSArray *childListDisplayName = [childList valueForKey:@"displayName"];
    
    test = ^(id obj, NSUInteger idx, BOOL *stop) {
        
            if ([childListDisplayName containsObject: [(User*)obj displayName]]) {
                return YES;
        }
        return NO;
    };
    
    NSIndexSet *indexes = [parentList indexesOfObjectsPassingTest:test];
     
    
    NSLog(@"indexes: %@", indexes);
    
    [self setSelectedIndices:[indexes mutableCopy]];
    [self setOnLoadIndices:[indexes mutableCopy]];
    
}

- (NSMutableArray *)mergeChildArray:(NSArray *)childList intoParentArray:(NSArray *)parentList withIndexSet:(NSIndexSet *)indexes {
    
    //NSMutableArray *mergedGuestList = [[NSMutableArray alloc] initWithCapacity:[parentList count]];
    NSMutableArray *mergedGuestList = [[NSMutableArray alloc] initWithArray:parentList];
    
    [childList enumerateObjectsUsingBlock:^(id childListObj, NSUInteger childListIdx, BOOL *stop) {
        [parentList enumerateObjectsAtIndexes:indexes options:NSEnumerationConcurrent usingBlock:^(id parentListObj, NSUInteger parentListIdx, BOOL *stop) {
            NSLog(@"Child List Index: %d", childListIdx);
            NSLog(@"Parent List Index: %d", parentListIdx);
            NSLog(@"DisplayName Child: %@", [(User*)childListObj displayName]);
            NSLog(@"DisplayName Parent: %@", [(User*)parentListObj displayName]);
            if ([[(User*)childListObj displayName] isEqualToString:[(User*)parentListObj displayName]]) {
//                parentListObj = [childListObj copy];
//                mergedGuestList[parentListIdx]
                [mergedGuestList replaceObjectAtIndex:parentListIdx withObject:childListObj];
                *stop = YES;
            }
        }];
    }];

    
    return mergedGuestList;
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
        
        NSURLRequest *request = [NSURLRequest requestWithURL:user.avatarURL];
        __weak UIImageView *imageView = guestCell.avatarView;
        [guestCell.avatarView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imageView.image = image;
            CALayer *layer = imageView.layer;
            layer.masksToBounds = YES;
            layer.cornerRadius = 10.0f;
        } failure:NULL];
        
        
        if ([self.selectedIndices containsIndex:indexPath.row]) {
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
    
    [self.selectedIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSLog(@"SelectIndex is %d vs current index is %d", idx, [indexPath row]);
        if (idx == [indexPath row]) {
            self.selected = YES;
            *stop = YES;
        }
    }];
    
    if (self.isSelected) {
        [self.selectedIndices removeIndex:[indexPath row]];
        
    } else {
        [self.selectedIndices addIndex:[indexPath row]];
        
    }
    
    [self.tableView reloadData];

    

}



#pragma mark - fetch methods
- (void)fetchGuestListTableContent
{
    

//    guestFullListForSlType = (NSMutableArray *)[self.guestListFullDict objectForKey:slTypeString];
    

    if ([self.guestFullListForSlType count] > 0) {
//        [event setGuestList:guestFullListForSlType];
//        NSArray *attendeeListForSlType = (NSArray *)[self.guestListAttendeeDict objectForKey:slTypeString];
        
        [self setSelectedIndicesFromArray:[self guestAttendeeListForSlType] WithArray:[self guestFullListForSlType]];
        self.guestFullListForSlType = [self mergeChildArray:[self guestAttendeeListForSlType] intoParentArray:[self guestFullListForSlType] withIndexSet:[self selectedIndices]];
        [self setPopoverTitleWithString:slTypeString];
        
    } else {
        [self fetchGuestListFromWS];
        
    }
    
    
    [self.tableView reloadData];
    
}

-(void)fetchGuestListFromWS {
    

    [CommonUtilities showProgressHUD:self.view];
    [self setPopoverTitleWithString:slTypeString];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // insert a new user.
        
        
        switch (self.slType)
        {
            case Meetup:
                self.meetupDotComMgr = [self.objectConfiguration meetupDotComManager];
                self.meetupDotComMgr.guestDelegate = self;
                //        Event *selectedEvent = (Event *)[(GuestListTableDataSource *)self.dataSource event];
                [self.meetupDotComMgr fetchGuestsForGroupName:[appDelegate meetupDotComAccountGroupUrlName]];
                break;
            case Facebook:
                
                NSLog(@"Welcome to Facebook!");
                
                break;
                
            case LinkedIn:
                
                NSLog(@"Welcome to LinkedIN!");
                
                break;
                
            case Twitter:
                self.twitterDotComMgr = [self.objectConfiguration twitterDotComManager];
                self.twitterDotComMgr.guestDelegate = self;
                [self.twitterDotComMgr fetchGuestsForGroupName:[appDelegate twitterDotComAccountName]];
                
                NSLog(@"Welcome to Twitter!");
                
                break;
                
            default:
                
                NSLog(@"Welcome to Meetup!");
                
                break;
                
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [CommonUtilities hideProgressHUD:self.view];
            
        });
    });


    
       
}


-(void)setPopoverTitleWithString:(NSString *)title {
    self.title = [NSString stringWithFormat:@"Guests - %@", title];
}


#pragma mark - Guest Manager delegate


- (void)guestsReceivedForEvent:(Event *)event {
    
}

- (void)didReceiveGuests:(NSArray *)guests {
    
    // Remove HUD
    [CommonUtilities hideProgressHUD:self.view];
    
    // cache guest list from WS for specific social type key.
    NSLog(@"Did Receive Guests!");
    //[self.delegate setGuestListFullDictWithArray:guests forKey:slType];
    [self setGuestFullListForSlType:[guests mutableCopy]];
    
    // Should only have to send this message the first time it loads.
    // Subsequent calls are cached.
    [self.delegate receivedGuestFullList:[self guestFullListForSlType] forKey:slTypeString];
    
    [self setSelectedIndicesFromArray:[self guestAttendeeListForSlType] WithArray:[self guestFullListForSlType]];
    self.guestFullListForSlType =[self mergeChildArray:[self guestAttendeeListForSlType] intoParentArray:[self guestFullListForSlType] withIndexSet:[self selectedIndices]];
    [self setPopoverTitleWithString:slTypeString];
    
    [self.tableView reloadData];
}


-(void)retrievingGuestsFailedWithError:(NSError *)error {}



@end
