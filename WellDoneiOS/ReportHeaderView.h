//
//  ReportHeaderView.h
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/17/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportDelegate.h"

@interface ReportHeaderView : UIView
@property (nonatomic, weak) id <ReportDelegate> delegate;

@end
