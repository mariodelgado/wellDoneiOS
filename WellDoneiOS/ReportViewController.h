//
//  ReportViewController.h
//  wellDoneReportPage
//
//  Created by Bhargava, Rajat on 7/6/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface ReportViewController : UIViewController <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) Report *report; 

@end
