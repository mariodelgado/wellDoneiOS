//
//  CreateReportViewController.h
//  wellDoneReportPage
//
//  Created by Bhargava, Rajat on 7/8/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "Report.h"
#import "Pump.h"

@protocol AddReportDelegate <NSObject>
-(void) addReportToArray:(Report*) report;

@end

@interface CreateReportViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) Pump *pump;
@property (weak, nonatomic) id <AddReportDelegate> delegate;

@end
