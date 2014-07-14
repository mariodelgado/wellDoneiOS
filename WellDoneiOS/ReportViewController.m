//
//  ReportViewController.m
//  wellDoneReportPage
//
//  Created by Bhargava, Rajat on 7/6/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "ReportViewController.h"
#import "UILabel+BorderedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "CreateReportViewController.h"

@interface ReportViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pumpImage;
@property (weak, nonatomic) IBOutlet UILabel *lblReportName;
@property (weak, nonatomic) IBOutlet UILabel *lblDateCreated;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblNotes;
- (IBAction)onCreateReport:(id)sender;

@end

@implementation ReportViewController

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
    
    UIImage *img = [UIImage imageNamed:@"NewYork.jpg"];
    self.pumpImage.image = img;
    self.pumpImage.clipsToBounds = YES;
    self.navigationController.navigationBarHidden = NO;

    [self loadDataFromModel];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) loadDataFromModel {
    self.lblReportName.text = self.report.reportName;
    self.lblDateCreated.text = @"12:00 :43 - March 4, 2015";
    //self.lblStatus.text = @"Fixed";
    self.lblNotes.text = self.report.reportNote;
    UILabel *lblStatusNew = [[UILabel alloc] initWithFrame:CGRectMake(self.lblStatus.frame.origin.x, self.lblStatus.frame.origin.y, 80, 40)];
    [lblStatusNew constructBorderedLabelWithText:@"Fixed" color:[UIColor redColor] angle:30];
    [self.view addSubview:lblStatusNew];
    
    //show images
     [self.report.reportImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        self.pumpImage.image = image;
        self.pumpImage.clipsToBounds = YES;
    }];
    
    
    
    
    
    
}


- (IBAction)onCreateReport:(id)sender {
    CreateReportViewController *cvc = [[CreateReportViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:cvc];
    [self presentViewController:nvc animated:YES completion:nil];
    
}
@end
