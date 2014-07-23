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
#import "ImageCollectionViewCell.h"
#import "MMPickerView.h"
#import "CWStatusBarNotification.h"
#import "AFNetworkReachabilityManager.h"
#import "Reachability.h"



NSString * const ReportSavedNotification = @"ReportSavedNotification";

@interface CreateReportViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtReportNotes;
@property (weak, nonatomic) IBOutlet UITextField *reportName;
- (IBAction)onCamera:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@property (strong, nonatomic)NSMutableArray *imageDataToSave;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic)CWStatusBarNotification *notification;
@property (assign, nonatomic) BOOL isThereNetwork;



- (IBAction)onStatus:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;
- (IBAction)onSubmit:(id)sender;


@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *onDismissKeyboard;


@end

@implementation CreateReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.imageDataToSave = [NSMutableArray array];
      
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
        
    }
    return self;
    

}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.reportName.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    [self.imageCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageCellectionViewCell"];
    [self.view sendSubviewToBack: self.blurView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
   // [self.dataArray addObject:self.bgImage];

    self.imageCollectionView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.9 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bgImage.layer.opacity = 0.4;
    } completion:^(BOOL finished) {
        nil;
    }];
//
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//
//
//    
    [self.imageCollectionView setCollectionViewLayout:flowLayout];
    [self loadInitialViews];
    
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem= cancel;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor redColor];
    
//   //Internet
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    self.isThereNetwork = [self connected];
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) onSave {
    NSLog(@"I am in Save");
     __block Report *newReport;
    newReport = [Report reportWithName:self.reportName.text note:self.txtReportNotes.text pump:self.pump status:self.btnStatus.titleLabel.text];
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    self.isThereNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:@"isReachable"];
    if (self.isThereNetwork) {
        NSLog(@"isConntect:%hhd",[self connected]);
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:[self.imageDataToSave firstObject]];
       
        
       
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                newReport.reportImage = imageFile;
                
                
                [newReport saveInBackground];
                self.pump.status = self.btnStatus.titleLabel.text;
                [self.pump saveInBackground];
                [self notificationWithMessage:@"Report Successfully Submitted"];
                
            }
            if (newReport) {
                [self.delegate addReportToArray:newReport];
            }
            
        }];
    } else {
        NSLog(@"No internet");
        if (newReport) {
            [self.delegate addReportToArray:newReport];
        }
        self.pump.status = self.btnStatus.titleLabel.text; //So that status change.
        [self notificationWithMessage:@"Report Will Be Submitted When Network Available"];
    }
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
//    }];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ReportSavedNotification object:self userInfo:@{@"currentPump":self.pump}];
        
    }];
    
    
    
}

-(void) onCancel {
   
    [self dismissViewControllerAnimated:YES completion:nil];

    
//   
//    [UIView animateWithDuration:0.9 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.bgImage.layer.opacity = 0;
//    } completion:^(BOOL finished) {
//        nil;
//    }];
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


#pragma mark - camera
-(void)onCamera {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self.dataArray addObject:image];
    [self.imageCollectionView reloadData];
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//     NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
//    [self.imageDataToSave addObject:imageData];
    
   
    
//    // Resize image
//    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
//    [image drawInRect: CGRectMake(0, 0, 640, 960)];
//    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    // Upload image
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
//   // [self uploadImage:imageData];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    //    return [sectionArray count];
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self.dataArray count];
    
    
}



// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"imageCellectionViewCell";
    
    
    
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.layer.opacity = 1;
    cell.layer.opaque = NO;
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell.selectedBackgroundView removeFromSuperview];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.superview.layer.backgroundColor = [UIColor clearColor].CGColor;





    if (indexPath.section == 0) {
        
//        UIImage *image = [UIImage imageNamed:@"addPhoto1"];
//        [self.dataArray addObject:image];
        


        UITapGestureRecognizer *tabGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCamera)];
        cell.superview.backgroundColor = [UIColor clearColor];
        [cell addGestureRecognizer:tabGesture];
        
    }
    

    
    //NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.row];
    //
    //    NSString *cellData = [self.dataArray objectAtIndex:indexPath.section];
    //
    //    [cell.name setText:cellData];
    
    cell.imageView.image = [self.dataArray objectAtIndex:indexPath.section];
    cell.imageView.backgroundColor = [UIColor clearColor];
    cell.imageView.clipsToBounds = YES;
    
    
    return cell;
}



-(void)loadInitialViews {
    self.btnStatus.titleLabel.text = self.pump.status;
    UIImage *image = [UIImage imageNamed:@"addPhoto1"];

    [self.dataArray addObject:image];
    
}


-(void)showUIPicker {
    
    NSArray *strings = @[PumpStatusGood, PumpStatusBroken];
    
    [MMPickerView showPickerViewInView:self.view
                           withStrings:strings
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                self.btnStatus.titleLabel.text = selectedString;
                                
                            }];
    
}





- (IBAction)onStatus:(id)sender {
    [self showUIPicker];
}


#pragma textFieldDelegate
//This will make the keyboard dissapear
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onSubmit:(id)sender {
    [self onSave];
}


-(void)notificationWithMessage:(NSString*)message {
    self.notification = [CWStatusBarNotification new];
    self.notification.notificationLabelBackgroundColor = [UIColor darkGrayColor];
    self.notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    
    
    [self.notification displayNotificationWithMessage:message
                                          forDuration:5.0f];
}

#pragma mark - See if there is internet
- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

//- (void)reachabilityDidChange:(NSNotification *)notification {
//    Reachability *reachability = (Reachability *)[notification object];
//    self.isThereNetwork = [reachability isReachable];
//}



@end
