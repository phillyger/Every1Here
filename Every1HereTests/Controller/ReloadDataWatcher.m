//
//  ReloadDataWatcher.m
//  E1H
//
//  Created by Ger O'Sullivan on 2/12/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "ReloadDataWatcher.h"

@implementation ReloadDataWatcher

{
    BOOL didReloadData;
}

- (void)reloadData {
    didReloadData = YES;
}

- (BOOL)didReceiveReloadData {
    return didReloadData;
}

@end
