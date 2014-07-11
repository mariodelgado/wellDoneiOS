//
//  ListReportsViewController.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/10/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "ListReportsViewController.h"
#import "Report.h"
#import "ReportViewController.h"

@interface ListReportsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *reports;

@end

@implementation ListReportsViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadReports];
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
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
