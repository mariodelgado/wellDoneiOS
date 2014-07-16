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

@interface PumpDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, JBLineChartViewDataSource, JBLineChartViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) Pump *pump;
@property (nonatomic, assign) CGFloat extraColorLayerOpacity UI_APPEARANCE_SELECTOR;

@end
