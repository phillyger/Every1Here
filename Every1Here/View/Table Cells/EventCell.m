//
//  EventCell.m
//  Presence
//
//  Created by Ger O'Sullivan on 12/2/12.
//  Copyright (c) 2012 Brilliant Age. All rights reserved.
//

#import "EventCell.h"
#import "CommonUI.h"

@implementation EventCell

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

-(void) drawRect: (CGRect) rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIColor * lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]; // Previous Code
    UIColor * separatorColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0];
 
    
    // UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, whiteColor.CGColor, lightGrayColor.CGColor);
    
    // START NEW
    CGRect strokeRect = paperRect;
    strokeRect.size.height -= 1;
    strokeRect = rectFor1PxStroke(strokeRect);
    CGContextSetStrokeColorWithColor(context, whiteColor.CGColor);
    // END NEW
    
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);
    
    
    CGPoint startPoint = CGPointMake(paperRect.origin.x, paperRect.origin.y + paperRect.size.height - 1);
    CGPoint endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, paperRect.origin.y + paperRect.size.height - 1);
    draw1PxStroke(context, startPoint, endPoint, separatorColor.CGColor);

    
    
}

@end
