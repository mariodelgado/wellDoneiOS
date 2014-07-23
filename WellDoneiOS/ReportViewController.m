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
#import "AFNetworking.h"
#import "TextMessageViewController.h"
#import "UIView+Animations.h"
#import "MHPrettyDate.h"

@interface ReportViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pumpImage;
@property (weak, nonatomic) IBOutlet UILabel *lblReportName;
@property (weak, nonatomic) IBOutlet UILabel *lblDateCreated;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblNotes;

@property (assign,nonatomic)BOOL isPresenting;

- (IBAction)onCreateReport:(id)sender;
- (IBAction)onSendSMS:(id)sender;


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
    self.lblDateCreated.text = [self giveMePrettyDate];
    self.lblStatus.text = self.report.status;
    self.lblNotes.text = self.report.reportNote;
//    UILabel *lblStatusNew = [[UILabel alloc] initWithFrame:CGRectMake(self.lblStatus.frame.origin.x, self.lblStatus.frame.origin.y, 80, 40)];
//    [lblStatusNew constructBorderedLabelWithText:@"Fixed" color:[UIColor redColor] angle:30];
//    [self.view addSubview:lblStatusNew];
    
    //show images
     [self.report.reportImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        self.pumpImage.image = image;
        self.pumpImage.clipsToBounds = YES;
    }];
    
    
    
    
    
    
}

- (NSString *)giveMePrettyDate {
    if (self.report.updatedAt) {
        return [MHPrettyDate prettyDateFromDate:self.report.updatedAt withFormat:MHPrettyDateLongRelativeTime];
    }else {
        return @"NA";
    }
}

- (IBAction)onCreateReport:(id)sender {
    CreateReportViewController *cvc = [[CreateReportViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:cvc];
    [self presentViewController:nvc animated:YES completion:nil];
    
}

- (IBAction)onSendSMS:(id)sender {
    
    //Show modal
    TextMessageViewController *textVC = [TextMessageViewController new];
    textVC.modalPresentationStyle = UIModalPresentationCustom;
    textVC.transitioningDelegate = self;
    textVC.pump = self.report.pump; 
    [self presentViewController:textVC animated:YES completion:nil];
    
    
}

#pragma mark - modal transition
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
        TextMessageViewController *smsView = (TextMessageViewController*)toViewController;
        CGRect originalSMSFrame = smsView.view.frame;
        
        smsView.view.frame = CGRectMake(10, 150, originalSMSFrame.size.width, originalSMSFrame.size.height);
        [containerView addSubview:toViewController.view];
        
        toViewController.view.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        
        [UIView animateWithDuration:1 animations:^{
            TextMessageViewController *smsView = (TextMessageViewController*)fromViewController;
            CGRect originalSMSFrame = smsView.view.frame;
            [fromViewController.view animateExitDownWithDuration:1 frame:CGRectMake(originalSMSFrame.origin.x, originalSMSFrame.origin.y+500, originalSMSFrame.size.width, originalSMSFrame.size.height)];
//            fromViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
            fromViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}



@end

