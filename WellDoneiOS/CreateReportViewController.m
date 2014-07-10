//
//  CreateReportViewController.m
//  wellDoneReportPage
//
//  Created by Bhargava, Rajat on 7/8/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "CreateReportViewController.h"
#import <Parse/Parse.h>

@interface CreateReportViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtReportNotes;
@property (weak, nonatomic) IBOutlet UITextField *reportName;

@end

@implementation CreateReportViewController

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
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
    self.navigationItem.rightBarButtonItem= save;
    
  
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onSave {
    
    PFObject *newReport = [PFObject objectWithClassName:@"Report"];
    newReport[@"reportName"] = self.reportName.text;
    newReport[@"reportNote"] = self.txtReportNotes.text;
    
    [newReport saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
