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

@property (nonatomic, assign) BOOL isPresenting; 
@end

@implementation PumpDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setupx after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadReports];
    [self loadChart];
    [self reloadViewWithData:self.pump];
    [self configureTapGestureOnChartView];



    
}
- (void)loadChart {
    JBLineChartView *lineChartView = [[JBLineChartView alloc] init];
    lineChartView.delegate = self;
    lineChartView.dataSource = self;
    
    lineChartView.frame = self.chartView.bounds;
    [lineChartView reloadData];
    [self.chartView addSubview:lineChartView];
    self.report = [[Report alloc] init];
}
- (void)reloadViewWithData: (Pump *)pump {
    self.lblName.text = pump.name;
    self.lblDecsription.text = pump.descriptionText;
    self.imgPump.image = [UIImage imageNamed:@"pump.jpeg"];
    self.lblLastUpdated.text = [NSString stringWithFormat:@"%@", self.report.updatedAt];

}
- (void)setPump:(Pump *)pump{
    _pump = pump;

//    __block Report *report;
    __weak PumpDetailViewController *weakSelf = self;
    [Report getReportsForPump:pump withBlock:^(NSArray *objects, NSError *error) {
                        weakSelf.report = [objects firstObject];
                        NSDateFormatter *_formatter;
                        _formatter = [[NSDateFormatter alloc] init];
                        [_formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportViewController *rvc = [[ReportViewController alloc] init];
    rvc.report = self.reports[indexPath.row];
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void) loadReports {
    PFQuery *queryForReports = [Report query];
    [queryForReports findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.reports = objects;
            [self.tableView reloadData];
            [self endRefresh];
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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

#pragma mark linechart delegates
- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 2; // number of lines in chart
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return 5; // number of values for a line
}
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex+1)*(horizontalIndex + 1); // y-position (y-axis) of point at horizontalIndex (x-axis)
}
- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor redColor]; // color of line in chart
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 1; // width of line in chart
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleDashed; // style of line in chart
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
        toViewController.view.frame = containerView.frame;
        [containerView addSubview:toViewController.view];
        
        toViewController.view.alpha = 0;
        toViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [UIView animateWithDuration:1 animations:^{
            toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        
        [UIView animateWithDuration:1 animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
            fromViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}

@end
