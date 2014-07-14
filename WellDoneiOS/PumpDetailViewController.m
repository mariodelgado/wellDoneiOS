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

@interface PumpDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdated;
@property (weak, nonatomic) IBOutlet UIImageView *imgPump;
@property (weak, nonatomic) IBOutlet UILabel *lblDecsription;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *reports;
@property(nonatomic,strong)UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *chartView;
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

    
}
- (void)loadChart {
    JBLineChartView *lineChartView = [[JBLineChartView alloc] init];
    lineChartView.delegate = self;
    lineChartView.dataSource = self;
    lineChartView.frame = self.chartView.bounds;
    [lineChartView reloadData];
    [self.chartView addSubview:lineChartView];
}
- (void)setPump:(Pump *)pump{
    self.lblName.text = pump.name;
    self.lblDecsription.text = pump.description;
    self.imgPump.image = [UIImage imageNamed:@"pump.jpeg"];
    __block Report *report;
    __weak PumpDetailViewController *weakSelf = self;
    [Report getReportsForPump:pump
                    withBlock:^(NSArray *objects, NSError *error) {
                        report = [objects firstObject];
                        NSLog(@"report obj %@", report);
                        
                        NSDateFormatter *_formatter;
                        
                        _formatter = [[NSDateFormatter alloc] init];
                        [_formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
                        
                        weakSelf.lblLastUpdated.text = [NSString stringWithFormat:@"%@", report.updatedAt];
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

@end
