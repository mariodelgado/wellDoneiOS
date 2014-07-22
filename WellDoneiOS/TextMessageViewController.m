//
//  TextMessageViewController.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/19/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "TextMessageViewController.h"
#import "AFNetworking.h"

@interface TextMessageViewController ()
- (IBAction)onSend:(id)sender;
- (IBAction)onCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtSMS;

@end

@implementation TextMessageViewController

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
    //get the Pump name
    self.txtSMS.text = self.pump.name;
    //Get the closed pump
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onSend:(id)sender {
    [self sendSMS];
    
}

- (NSMutableDictionary*) jsonDict
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    result[@"From"] =@"+14087136419";
    result[@"To"] =@"+16186969454";
    result[@"Body"] = self.txtSMS.text;
    
    return result;
    
}

- (void)sendSMS {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer
     setAuthorizationHeaderFieldWithUsername:@"AC371a1c80e474891a978040c2ffbe09f4"
     password:@"b6bf6dfe8a8ca922aba35a531076b2b3"];
    
    
    [manager POST:@"https://api.twilio.com/2010-04-01/Accounts/AC371a1c80e474891a978040c2ffbe09f4/Messages.json" parameters:[self jsonDict] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"Response Object:%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@",error);
        
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - style View
- (void)styleView
{
    self.view.layer.cornerRadius = 5;
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOpacity:0.7];
    [self.view.layer setShadowOffset:CGSizeMake(-1, -1)];
}

@end
