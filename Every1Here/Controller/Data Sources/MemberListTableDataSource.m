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
#import "EventRoleDefault.h"
#import "User.h"
#import "CRNInitialsImageView.h"
#import "PICircularProgressView.h"
#import "CommonUtilities.h"

#import <QuartzCore/QuartzCore.h>
#import "AvatarStore.h"


static NSString *memberCellReuseIdentifier = @"memberCell";

@interface MemberListTableDataSource ()
{
        NSDictionary *meetingRoleIconDict;
        NSDictionary *meetingRoleDict;
}

@property (nonatomic, strong) NSMutableArray *outerArray;
@property (nonatomic, strong) NSArray *indexTitlesArray;

@end

@implementation MemberListTableDataSource
@synthesize event;
@synthesize memberCell;
@synthesize avatarStore;
@synthesize tableView;
@synthesize notificationCenter;
@synthesize collation;


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
//    return [[event allMembers] count] ? :1;
    NSArray *innerArray = [self.outerArray objectAtIndex:section];
    return [innerArray count];
}

- (User *)memberForIndexPath:(NSIndexPath *)indexPath {
    
    return [[event allMembers] objectAtIndex:[indexPath row]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the inner array for this section
    NSArray *innerArray = [self.outerArray objectAtIndex:indexPath.section];
    User *user = [innerArray objectAtIndex:indexPath.row];
    NSNotification *note = [NSNotification notificationWithName: MemberListDidSelectMemberNotification object: user];
    [[NSNotificationCenter defaultCenter] postNotification: note];
}



- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([[event allMembers]count]) {
//        User *user = [[event allMembers] objectAtIndex:[indexPath row]];
        
        
        
        memberCell = [aTableView dequeueReusableCellWithIdentifier:memberCellReuseIdentifier forIndexPath:indexPath];
        
        // Get the inner array for this section
        NSArray *innerArray = [self.outerArray objectAtIndex:indexPath.section];
        User *user = [innerArray objectAtIndex:indexPath.row];
//        memberCell.displayNameLabel.text =
        memberCell.displayNameLabel.text = user.displayName;
        

        memberCell.progressView.progress = [user.compComm floatValue]/10;
        
        
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
            
//        memberCell.latestSpeech.text = [NSString stringWithFormat:@"%@",[user latestSpeechDate]];
        
        if ([user latestSpeechDate] != nil)
            memberCell.latestSpeech.text = [CommonUtilities convertDaysCountToLabelWithBaseDate:[NSDate date] offsetDate:[user latestSpeechDate]];
        else
            memberCell.latestSpeech.text = @"";

//        NSData *avatarData = [avatarStore dataForURL: user.avatarURL];
//        if (avatarData) {
//        if (user.avatarURL) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:user.avatarURL];
        __weak UIImageView *imageView = memberCell.avatarView;
        

        // Implementation example of CRNInitialsImageView
        CRNInitialsImageView *crnImageView = [[CRNInitialsImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        crnImageView.initialsBackgroundColor = [self randomColor];
        crnImageView.initialsTextColor = [UIColor whiteColor];
        crnImageView.initialsFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
//        crnImageView.useCircle = _isCircle ? TRUE : FALSE; // setting value based on UISegmentedControl
        crnImageView.useCircle = YES;
        crnImageView.firstName = [user firstName];
        crnImageView.lastName = [user lastName];
        [crnImageView drawImage];
        
        
        [memberCell.avatarView setImageWithURLRequest:request placeholderImage:crnImageView.image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
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

- (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 128 / 256.0) + 0.25;
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.25;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.25;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark - UITableViewDelegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.collation.sectionTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *theLetter = [self.collation.sectionTitles objectAtIndex:section];
    
    if (![theLetter isEqualToString:@"#"]) {
        NSString *titleString = [NSString stringWithFormat:
                                 @"%@", theLetter];
        return titleString;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
     return [self.collation sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.collation = [UILocalizedIndexedCollation currentCollation];
    return [self.collation.sectionTitles count];
}

#pragma mark - Custom configuration of table data
-(void)configureSectionData
{
 
    SEL selector = @selector(lastName);
//    SEL selector = @selector(user);
    NSUInteger sectionTitlesCount = [collation.sectionTitles count];
    
    self.outerArray = [NSMutableArray arrayWithCapacity:sectionTitlesCount];
    
    for (NSUInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [NSMutableArray array];
        [self.outerArray addObject:array];
    }
    
    for (User *user in [event allMembers]) {
        NSInteger sectionNumber = [collation sectionForObject:[user lastName] collationStringSelector:@selector(lowercaseString)];
        
        NSMutableArray *sectionNames = [self.outerArray objectAtIndex:sectionNumber];
        [sectionNames addObject:user];
    }
    
    for (NSUInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *namesForSection = [self.outerArray objectAtIndex:index];
        NSArray *sortedNamesForSection = [collation sortedArrayFromArray: namesForSection collationStringSelector:selector];
        [self.outerArray replaceObjectAtIndex:index withObject:sortedNamesForSection];
    }
    
}



@end

NSString *MemberListDidSelectMemberNotification = @"MemberListDidSelectMemberNotification";

