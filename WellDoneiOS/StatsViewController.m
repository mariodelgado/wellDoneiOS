//
//  StatsViewController.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/15/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

- (IBAction)onCanel:(id)sender;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - style View
- (void)styleView
{
    self.view.layer.cornerRadius = 5;
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOpacity:0.7];
    [self.view.layer setShadowOffset:CGSizeMake(-1, -1)];
}


- (IBAction)onCanel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
