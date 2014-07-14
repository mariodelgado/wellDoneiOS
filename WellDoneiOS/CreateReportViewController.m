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
#import "imageCollectionViewCell.h"

@interface CreateReportViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtReportNotes;
@property (weak, nonatomic) IBOutlet UITextField *reportName;
@property (strong, nonatomic)Pump *pump;
- (IBAction)onCamera:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (strong, nonatomic)NSMutableArray *dataArray;


@end

@implementation CreateReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    [self.imageCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageCellectionViewCell"];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.imageCollectionView setCollectionViewLayout:flowLayout];
    
    [self loadInitialViews];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
    self.navigationItem.rightBarButtonItem= save;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onSave {
    
    
    [Pump getListOfPumpsWithBlock:^(NSArray *objects, NSError *error) {
        self.pump = (Pump *)objects[0];
        Report *newReport = [Report reportWithName:self.reportName.text note:self.txtReportNotes.text pump:self.pump];
        
        [newReport saveInBackground];
    }];
    
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
    
    if (indexPath.section == 0) {
        UITapGestureRecognizer *tabGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCamera)];
        [cell addGestureRecognizer:tabGesture];
    }
    
    
    //NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.row];
    //
    //    NSString *cellData = [self.dataArray objectAtIndex:indexPath.section];
    //
    //    [cell.name setText:cellData];
    
    cell.imageView.image = [self.dataArray objectAtIndex:indexPath.section];
    cell.imageView.clipsToBounds = YES;
    
    return cell;
}

-(void)loadInitialViews {
    //    NSMutableArray *firstSection = [[NSMutableArray alloc] init]; NSMutableArray *secondSection = [[NSMutableArray alloc] init];
    //    for (int i=0; i<8; i++) {
    //        [firstSection addObject:[NSString stringWithFormat:@"Cell %d", i]];
    //        [secondSection addObject:[NSString stringWithFormat:@"item %d", i]];
    //    }
    //    // self.dataArray = [[NSArray alloc] initWithObjects:firstSection, nil];
    //    self.dataArray = firstSection;
    UIImage *image = [UIImage imageNamed:@"camera"];
    [self.dataArray addObject:image];
    
    
}


@end
