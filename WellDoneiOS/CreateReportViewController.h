//
//  CreateReportViewController.h
//  wellDoneReportPage
//
//  Created by Bhargava, Rajat on 7/8/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pump.h"



@interface CreateReportViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) Pump *pump; 

@end
