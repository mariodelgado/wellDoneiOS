//
//  ReportHeaderView.h
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/17/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ReportDelegate.h"

@protocol ReportDelegate <NSObject>

@optional
-(void)addReport;
@end

@interface ReportHeaderView : UIView
@property (nonatomic, assign) id <ReportDelegate> delegate;

@end
