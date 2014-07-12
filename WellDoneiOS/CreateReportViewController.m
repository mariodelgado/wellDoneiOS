//
//  CreateReportViewController.m
//  wellDoneReportPage
//
//  Created by Bhargava, Rajat on 7/8/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "CreateReportViewController.h"
#import <Parse/Parse.h>
#import "Report.h"

@interface CreateReportViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtReportNotes;
@property (weak, nonatomic) IBOutlet UITextField *reportName;
@property (strong, nonatomic)Pump *pump;
- (IBAction)onCamera:(id)sender;


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
    
//    PFObject *newReport = [PFObject objectWithClassName:@"Report"];
//    newReport[@"reportName"] = self.reportName.text;
//    newReport[@"reportNote"] = self.txtReportNotes.text;
    
//    [newReport saveInBackground];
    
//    Report *newReport = [Report object];
//    newReport.reportName = self.reportName.text;
//    newReport.reportNote = self.txtReportNotes.text;
    

//    NSArray *pumps = [Pump getListOfPumps];
//    Pump *pump = [pumps firstObject];
//    Report *newReport = [Report reportWithName:self.reportName.text note:self.txtReportNotes.text pump:pump];
//    
//    [newReport saveInBackground];
    
    [Pump getListOfPumpsWithBlock:^(NSArray *objects, NSError *error) {
        self.pump = (Pump *)objects[0];
        Report *newReport = [Report reportWithName:self.reportName.text note:self.txtReportNotes.text pump:self.pump];
        
        [newReport saveInBackground];
    }];
    
//    PFQuery *firstPumpQuery = [Pump query];
//    [firstPumpQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        self.pump = (Pump *)objects[0];
//        Report *newReport = [Report reportWithName:self.reportName.text note:self.txtReportNotes.text pump:self.pump];
//        
//        [newReport saveInBackground];
//    }];
//    
    
   

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCamera:(id)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else {
        NSLog(@"Photos not availabe");
    }
}
@end
