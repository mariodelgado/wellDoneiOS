//
//  CreateReportViewController.h
//  wellDoneReportPage
//
//  Created by Bhargava, Rajat on 7/8/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pump.h"

extern NSString *const ReportSavedNotification;

@interface CreateReportViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) Pump *pump; 

@end
