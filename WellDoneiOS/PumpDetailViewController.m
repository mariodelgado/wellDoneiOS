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

#import "MHPrettyDate.h"
#import "PNChart.h"
#import "ReportHeaderView.h"
#import "CreateReportViewController.h"
#import "UILabel+BorderedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Animations.h"



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

@property (nonatomic, assign) BOOL isPresenting;
@end

@implementation PumpDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.reportHeaderView = [ReportHeaderView new];
        
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
    self.imgPump.layer.borderColor = [UIColor lightGrayColor].CGColor; //change this to status color of pump
    self.imgPump.layer.borderWidth = 4;
    
    
}



- (void)loadChart {
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, -25, self.chartView.frame.size.width, self.chartView.frame.size.height -20)];
    [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    
    lineChart.backgroundColor = [UIColor clearColor];
    
    // Line Chart No.1
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // Line Chart No.2
    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2];
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
    self.imgPump.image = [UIImage imageNamed:@"pump.jpeg"];
    self.lblLastUpdated.text = [self giveMePrettyDate];
    self.lblStatus.text = pump.status;
    //[self addStatusLabel:pump.status]; //Was acting weired.
    
}

- (NSString *)giveMePrettyDate {
    if (self.report.updatedAt) {
        return [MHPrettyDate prettyDateFromDate:self.report.updatedAt withFormat:MHPrettyDateShortRelativeTime];
    }else {
        return @"NA";
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
    
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
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
    return 40.0f;
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
    return 2.0;
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
        
        [UIView animateWithDuration:1 animations:^{
            
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
            //            fromViewController.view.transform = CGAffineTransformMakeRotation(30* (M_PI/180));
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
    [self presentViewController:nvc animated:YES completion:nil];
}
- (IBAction)onAddReport:(id)sender {
    [self addReport];
}
@end