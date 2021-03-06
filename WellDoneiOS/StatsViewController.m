//
//  StatsViewController.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/15/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "StatsViewController.h"
#import "PNChart.h"

@interface StatsViewController ()

- (IBAction)onCanel:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblGraphTitle;
@property (strong, nonatomic) IBOutlet UIView *viewGraph1;
@property (weak, nonatomic) IBOutlet UIView *viewGraph2;
@property (weak, nonatomic) IBOutlet UIView *backImage;
- (IBAction)onTouch:(id)sender;

@end

@implementation StatsViewController

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
    [self styleView];
//    [self lineChart1];
//    [self lineChart2];
    
//    [self.view sendSubviewToBack: self.backImage];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - style View
- (void)styleView
{
    self.view.layer.cornerRadius = 2;
    self.view.backgroundColor = [UIColor whiteColor];
}


- (IBAction)onCanel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) lineChart1 {
    //For LineChart
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 200.0)];
    [lineChart setXLabels:@[@"8/30",@"8/31",@"9/1",@"9/2",@"9/3",@"9/4",@"9/5"]];
    
    // Line Chart No.1
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @300, @250];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart No.2
    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2,@250,@180];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data01, data02];
    [lineChart strokeChart];
    
    UILabel *lblGraphTitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 300, 20)];
    lblGraphTitle.text = @"Water Usage Vs. Population";
    
    self.viewGraph1.backgroundColor = [UIColor whiteColor];
    [self.viewGraph1 addSubview:lineChart];
    [self.viewGraph1 addSubview:lblGraphTitle];
    
    [self.view sendSubviewToBack: self.backImage];
    
   
    
    
    
}

-(void) lineChart2 {
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.0)];
    [lineChart setXLabels:@[@"8/30",@"8/31",@"9/1",@"9/2",@"9/3",@"9/4",@"9/5"]];
    
    // Line Chart No.1
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @300, @250];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart No.2
    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2,@250,@180];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNTwitterColor;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data01, data02];
    [lineChart strokeChart];
    
    [self.viewGraph2 addSubview:lineChart];

    

}

-(void)createLineChart1 {
    self.viewGraph1 = [[UIView alloc]initWithFrame:CGRectMake(0, -500, SCREEN_WIDTH, 200)];
    [self.view addSubview:self.viewGraph1];
    [self.view sendSubviewToBack:self.viewGraph1];
    NSLog(@"Frame:%f, %f",self.viewGraph1.frame.origin.x, self.viewGraph1.frame.origin.y );
    NSLog(@"Frame Chart View:%f,%f",self.viewGraph1.frame.origin.x, self.viewGraph1.frame.origin.y);
    [self lineChart1];

}

-(void)moveLineChart1Down {
    self.viewGraph1.frame = CGRectMake(0, 240, SCREEN_WIDTH, 200);
}
- (IBAction)onTouch:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
