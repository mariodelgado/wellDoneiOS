//
//  PumpDetailViewController.h
//  WellDoneiOS
//
//  Created by Aparna Jain on 7/12/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pump.h"
#import "JBLineChartView.h"
//#import "ReportDelegate.h"
#import "ReportHeaderView.h"

@interface PumpDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning,ReportDelegate>
@property (nonatomic, strong) Pump *pump;
@end
