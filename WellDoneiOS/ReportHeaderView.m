//
//  ReportHeaderView.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/17/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "ReportHeaderView.h"
#import "CreateReportViewController.h"

@implementation ReportHeaderView
- (IBAction)addReport:(id)sender {
    [self.delegate addReport]; 
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"ReportHeaderView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        
        UIView *subview = objects[0];
        self.frame = subview.frame;
        [self addSubview:objects[0]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
