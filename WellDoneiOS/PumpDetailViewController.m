//
//  PumpDetailViewController.m
//  WellDoneiOS
//
//  Created by Aparna Jain on 7/12/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "PumpDetailViewController.h"
#import "Report.h"
#import "MHPrettyDate.h"
#import "ReportViewController.h"
#import "StatsViewController.h"
#import "PumpMapViewController.h"

#import "MHPrettyDate.h"
#import "PNChart.h"
#import "ReportHeaderView.h"
#import "CreateReportViewController.h"
#import "UILabel+BorderedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Animations.h"
#import "NextPumpMapViewController.h"


@interface PumpDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdated;
@property (weak, nonatomic) IBOutlet UIImageView *imgPump;
@property (weak, nonatomic) IBOutlet UILabel *lblDecsription;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *reports;
@property(nonatomic,strong)UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (strong, nonatomic) Report *report;
@property (strong, nonatomic) ReportHeaderView *reportHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, assign) BOOL firstSwipe;
@property (nonatomic, retain) NSString *message;
@property (weak, nonatomic) IBOutlet UIImageView *brokenIndicatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *notBrokenIndicatorImageView;



@property (nonatomic, assign) BOOL isPresenting;
@end

@implementation PumpDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.reportHeaderView = [ReportHeaderView new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportSavedShowNextRoute) name:ReportSavedNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setupx after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configRefreshControl];
    [self loadReports];
    [self loadChart];
    [self reloadViewWithData:self.pump];
    [self configureTapGestureOnChartView];
    self.reportHeaderView.delegate = self;
    
    float width = self.imgPump.bounds.size.width;
    self.imgPump.layer.cornerRadius = width/2;
    self.imgPump.layer.borderColor =  [UIColor colorWithRed:0.0 / 255.0 green:171.0 / 255.0 blue:243.0 / 255.0 alpha:1].CGColor; //change this to status color of pump
    self.imgPump.layer.borderWidth = 4;
    
    self.lblName.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    self.lblName.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.lblName.layer.shadowRadius = 14.0f;
    self.lblName.layer.shadowOpacity = 1.0;
    self.lblName.layer.shadowOffset = CGSizeZero;
    self.lblName.layer.masksToBounds = NO;
    self.lblName.layer.opacity = 0;
    
    self.lblLastUpdated.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    self.lblLastUpdated.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.lblLastUpdated.layer.shadowRadius = 9.0f;
    self.lblLastUpdated.layer.shadowOpacity = 1.0;
    self.lblLastUpdated.layer.shadowOffset = CGSizeZero;
    self.lblLastUpdated.layer.masksToBounds = NO;
    self.lblLastUpdated.layer.opacity = 0;

    self.lblStatus.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.lblStatus.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.lblStatus.layer.shadowRadius = 19.0f;
    self.lblStatus.layer.shadowOpacity = 1.0;
    self.lblStatus.layer.shadowOffset = CGSizeZero;
    self.lblStatus.layer.masksToBounds = NO;
    self.lblStatus.layer.opacity = 0;

    self.addButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.addButton.layer.shadowOpacity = 0.8;
    self.addButton.layer.shadowRadius = 0.5;
    self.addButton.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.imgPump.transform = CGAffineTransformMakeScale(0,0);
    self.brokenIndicatorImageView.transform = CGAffineTransformMakeScale(0, 0);
    self.notBrokenIndicatorImageView.transform = CGAffineTransformMakeScale(0, 0);
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeLight) name:@"Light" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeDark) name:@"Dark" object:nil];

    
    
    [UIView animateWithDuration:0.3 delay:0.3 usingSpringWithDamping:.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imgPump.transform = CGAffineTransformMakeScale(1,1);
        self.brokenIndicatorImageView.transform = CGAffineTransformMakeScale(1, 1);
        self.notBrokenIndicatorImageView.transform = CGAffineTransformMakeScale(1, 1);

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.lblName.layer.opacity = 1;

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.lblLastUpdated.layer.opacity = 1;
            } completion:^(BOOL finished) {
                nil;
            }];
            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
                self.lblStatus.layer.opacity = 1;
            } completion:^(BOOL finished) {
                nil;
            }];

        }];
    }];
}

- (void) makeLight{
    self.lblName.textColor = [UIColor whiteColor];
    self.lblStatus.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    self.lblLastUpdated.textColor = [UIColor whiteColor];
}

- (void) makeDark{
    self.lblName.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    self.lblLastUpdated.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    self.lblStatus.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
}

- (void)loadChart {
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 18, self.chartView.frame.size.width, self.chartView.frame.size.height -20)];
    [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    
    lineChart.backgroundColor = [UIColor clearColor];
    
    // Line Chart No.1
    NSArray * data01Array = @[@60.1, @40.1, @16.4, @62.2, @66.2];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // Line Chart No.2
    NSArray * data02Array = @[@180.1, @180.1, @180.1, @180.1, @0];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data01, data02];
    [lineChart strokeChart];
    [self.chartView addSubview:lineChart];
    
    self.report = [[Report alloc] init];
}

- (void)reloadViewWithData: (Pump *)pump {
    self.lblName.text = pump.name;
    self.lblDecsription.text = pump.descriptionText;
    self.imgPump.image = [UIImage imageNamed:@"pumpPlaceholder"];
//  NSString *prettyDAte = [self giveMePrettyDate];
//  NSLog(@"report update %@ for pump %@", prettyDAte, self.pump.name);
//  self.pump.updatedAt = prettyDAte;
    if(pump.lastUpdatedAt){
        NSLog(@"pump name %@", pump.name);
    self.lblLastUpdated.text = pump.lastUpdatedAt;
    }

    self.lblStatus.text = pump.status;
    //[self addStatusLabel:pump.status]; //Was acting weired.
    if ([self.lblStatus.text isEqualToString:@"BROKEN"]) {
        self.brokenIndicatorImageView.hidden = NO;
        self.notBrokenIndicatorImageView.hidden = YES;
    } else {
        self.brokenIndicatorImageView.hidden = YES;
        self.notBrokenIndicatorImageView.hidden = NO;
    }
    
}

- (NSString *)giveMePrettyDate {

    if (self.report.updatedAt) {
        return [MHPrettyDate prettyDateFromDate:self.report.updatedAt withFormat:MHPrettyDateLongRelativeTime];
    }else {
        return @"3 hours ago";
    }
}

- (void)setPump:(Pump *)pump{
    _pump = pump;
    __weak PumpDetailViewController *weakSelf = self;
    [Report getReportsForPump:pump withBlock:^(NSArray *objects, NSError *error) {
        weakSelf.report = [objects firstObject];
        [self reloadViewWithData:pump];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reports.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Report"];
    Report *report = self.reports[indexPath.row];
    cell.textLabel.text = report.reportName;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.09];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportViewController *rvc = [[ReportViewController alloc] init];
    rvc.report = self.reports[indexPath.row];
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.reportHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (void) loadReports {
    
    //Get reports for that a perticular pump.
    
    [Report getReportsForPump:self.pump withBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.reports = objects;
            [self.tableView reloadData];
            [self endRefresh];
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    //    PFQuery *queryForReports = [Report query];
    //    [queryForReports findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //        if (!error) {
    //            self.reports = objects;
    //            [self.tableView reloadData];
    //            [self endRefresh];
    //        } else {
    //
    //            NSLog(@"Error: %@ %@", error, [error userInfo]);
    //        }
    //    }];
}

#pragma mark - Refresh Control
- (void)configRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(loadReports) forControlEvents:UIControlEventValueChanged];
}

-(void) endRefresh {
    [self.refreshControl endRefreshing];
    
}


#pragma mark - Custom Model Transaction
-(void) configureTapGestureOnChartView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChartViewTap:)];
    tapGesture.numberOfTapsRequired=1;
    [self.chartView addGestureRecognizer:tapGesture];
    
}

-(void) onChartViewTap:(UITapGestureRecognizer*) tapGesture {
    NSLog(@"I am tapped");
    //On tap open a modal
    StatsViewController *statsVC = [StatsViewController new];
    statsVC.modalPresentationStyle = UIModalPresentationCustom;
    statsVC.transitioningDelegate = self;
    [self presentViewController:statsVC animated:YES completion:nil];
    
    
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresenting = YES;
    return self;
    
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresenting = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if(self.isPresenting){
        
        PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:self.chartView.bounds];
        [barChart setXLabels:@[@"10/14",@"10/15",@"10/16",@"10/17",@"10/18",@"10/19",@"10/20"]];
        [barChart setYValues:@[@200,  @300, @250, @275, @200,@300,@400]];
        [barChart strokeChart];
        
        //        toViewController.view.frame = containerView.frame;
        toViewController.view.frame = self.chartView.frame;
        
        [containerView addSubview:toViewController.view];
        
        toViewController.view.alpha = 1;
        StatsViewController *statsView = (StatsViewController*)toViewController;
        statsView.animateView = [[UIView alloc] initWithFrame:statsView.view.bounds];
        statsView.animateView.backgroundColor = [UIColor blackColor];
        [statsView.view addSubview:statsView.animateView];
        //        statsView.animateView.frame = self.chartView.frame;
        NSLog(@"Frame:%f, %f",statsView.animateView.frame.origin.x, statsView.animateView.frame.origin.y );
        NSLog(@"Frame Chart View:%f,%f",self.chartView.frame.origin.x, self.chartView.frame.origin.y);
        
        
        [statsView.animateView addSubview:barChart];
        //        [toViewController.view addSubview:barChart];
//        toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [UIView animateWithDuration:0.5 animations:^{
          toViewController.view.frame = containerView.frame;
            statsView.animateView.frame = self.chartView.frame;
            
            
            toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 delay:0.5 usingSpringWithDamping:2 initialSpringVelocity:15 options:0 animations:^{
                statsView.animateView.frame = CGRectMake(statsView.animateView.frame.origin.x, 80, statsView.animateView.frame.size.width, statsView.animateView.frame.size.height);
                [statsView createLineChart1];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:0 animations:^{
                    [statsView moveLineChart1Down];
                } completion:^(BOOL finished) {
                    [transitionContext completeTransition:YES];
                }];
                
                
            }];
            
        }];
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.superview.transform = CGAffineTransformMakeScale(1, 1);

            fromViewController.view.frame = CGRectMake(fromViewController.view.frame.origin.x, fromViewController.view.frame.origin.y+500, fromViewController.view.frame.size.width, fromViewController.view.frame.size.width);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}

-(void) addStatusLabel:(NSString*)status {
    
    UILabel *lblStatusNew = [[UILabel alloc] initWithFrame:CGRectMake(self.lblStatus.frame.origin.x, self.lblStatus.frame.origin.y, 80, 40)];
    [lblStatusNew constructBorderedLabelWithText:status color:[UIColor redColor] angle:30];
    //    [self.lblStatus constructBorderedLabelWithText:status color:[UIColor redColor] angle:30];
    [self.view addSubview:lblStatusNew];
}

#pragma mark - ReportView Delegate
-(void)addReport {
    CreateReportViewController *cvc = [[CreateReportViewController alloc] init];
    cvc.pump = self.pump;
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:cvc];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:nvc animated:YES completion:nil];
}




- (IBAction)onAddReport:(id)sender {
    [self addReport];
}

-(void)reportSavedShowNextRoute {
    NSLog(@"I am the observer");
    NextPumpMapViewController *npVC = [NextPumpMapViewController new];
    [self presentViewController:npVC animated:YES completion:nil];
    
    
}
@end
