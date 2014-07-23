//
//  LoginViewController.m
//  FaceBook4
//
//  Created by Tyler Miller on 6/17/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "LoginViewController.h"
#import "PumpMapViewController.h"
#import "PumpsListViewController.h"

@interface LoginViewController ()
- (IBAction)onLoginButtonClick:(id)sender;

//Close Keyboard on Tap
- (IBAction)onTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *fieldBackground;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
    
    //Set Status Bar Tint Color
    [self setNeedsStatusBarAppearanceUpdate];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    [self.loadingIndicator setHidden:YES];
    [self.loadingIndicator setHidesWhenStopped:YES];
    [self.loadingIndicator setColor:[UIColor blackColor]];
    
    self.navigationController.navigationBarHidden = YES;
    
}


//Set Status Bar Tint Color
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onLoginButtonClick:(id)sender {
    
    [self.loadingIndicator setHidden:NO];
    [self.loadingIndicator startAnimating];
    [self performSelector:@selector(performLogin) withObject:nil afterDelay:2];
    
    
}

- (void)performLogin {
    if (self.usernameField.text.length > 0 && [self.passwordField.text isEqualToString:@"p"]) {
        // PumpMapViewController *pumpMapViewController = [[PumpMapViewController alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[PumpsListViewController alloc] init]];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Incorrect password"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self.loadingIndicator stopAnimating];
    [self.view endEditing:YES];
}

//- (void)willShowKeyboard:(NSNotification *)notification {
//    NSDictionary *userInfo = [notification userInfo];
//    
//    // Get the keyboard height and width from the notification
//    // Size varies depending on OS, language, orientation
//    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
//    
//    // Get the animation duration and curve from the notification
//    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration = durationValue.doubleValue;
//    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
//    UIViewAnimationCurve animationCurve = curveValue.intValue;
//    
//    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
//    [UIView animateWithDuration:animationDuration
//                          delay:0.0
//                        options:(animationCurve << 16)
//                     animations:^{
//                         self.usernameField.center = CGPointMake(self.usernameField.center.x, self.usernameField.center.y-60);
//                         self.passwordField.center = CGPointMake(self.passwordField.center.x, self.passwordField.center.y-60);
//                         self.fieldBackground.center = CGPointMake(self.fieldBackground.center.x, self.fieldBackground.center.y-60);
//                         self.loginButton.center = CGPointMake(self.loginButton.center.x, self.loginButton.center.y-60);
//                         self.facebookImage.center = CGPointMake(self.facebookImage.center.x, self.facebookImage.center.y-50);
//                     }
//                     completion:nil];
//}
//
//- (void)willHideKeyboard:(NSNotification *)notification {
//    NSDictionary *userInfo = [notification userInfo];
//    
//    // Get the animation duration and curve from the notification
//    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration = durationValue.doubleValue;
//    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
//    UIViewAnimationCurve animationCurve = curveValue.intValue;
//    
//    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
//    [UIView animateWithDuration:animationDuration
//                          delay:0.0
//                        options:(animationCurve << 16)
//                     animations:^{
//                         self.usernameField.center = CGPointMake(self.usernameField.center.x, self.usernameField.center.y+60);
//                         self.passwordField.center = CGPointMake(self.passwordField.center.x, self.passwordField.center.y+60);
//                         self.fieldBackground.center = CGPointMake(self.fieldBackground.center.x, self.fieldBackground.center.y+60);
//                         self.loginButton.center = CGPointMake(self.loginButton.center.x, self.loginButton.center.y+60);
//                         self.facebookImage.center = CGPointMake(self.facebookImage.center.x, self.facebookImage.center.y+50);
//                     }
//                     completion:nil];
//    
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Adjust position up
    NSLog(@"I need to move up");
    
    if (textField == self.passwordField)
    {
        self.usernameField.center = CGPointMake(self.usernameField.center.x, self.usernameField.center.y-60);
        self.passwordField.center = CGPointMake(self.passwordField.center.x, self.passwordField.center.y-60);
        self.fieldBackground.center = CGPointMake(self.fieldBackground.center.x, self.fieldBackground.center.y-60);
        self.loginButton.center = CGPointMake(self.loginButton.center.x, self.loginButton.center.y-60);
        self.facebookImage.center = CGPointMake(self.facebookImage.center.x, self.facebookImage.center.y-50);
    }
    else
    {
        
    
    [UIView animateWithDuration: .54
                          delay: 0
         usingSpringWithDamping: 1
          initialSpringVelocity: 0
                        options: 0
                     animations: ^
     {
         self.usernameField.center = CGPointMake(self.usernameField.center.x, self.usernameField.center.y-60);
         self.passwordField.center = CGPointMake(self.passwordField.center.x, self.passwordField.center.y-60);
         self.fieldBackground.center = CGPointMake(self.fieldBackground.center.x, self.fieldBackground.center.y-60);
         self.loginButton.center = CGPointMake(self.loginButton.center.x, self.loginButton.center.y-60);
         self.facebookImage.center = CGPointMake(self.facebookImage.center.x, self.facebookImage.center.y-50);
     }
                     completion: nil
     ];
    
    } }

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Adjust position down
    NSLog(@"I need to move down");
    
    [UIView animateWithDuration: .54
                          delay: 0
         usingSpringWithDamping: 1
          initialSpringVelocity: 0
                        options: 0
                     animations: ^
     {
         self.usernameField.center = CGPointMake(self.usernameField.center.x, self.usernameField.center.y+60);
         self.passwordField.center = CGPointMake(self.passwordField.center.x, self.passwordField.center.y+60);
         self.fieldBackground.center = CGPointMake(self.fieldBackground.center.x, self.fieldBackground.center.y+60);
         self.loginButton.center = CGPointMake(self.loginButton.center.x, self.loginButton.center.y+60);
         self.facebookImage.center = CGPointMake(self.facebookImage.center.x, self.facebookImage.center.y+50);
     }
                     completion: nil
     ];
}

@end
