//
//  NextPumpMapViewController.h
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/20/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Pump.h"

@interface NextPumpMapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong)Pump *pumpFrom;
@property (nonatomic, strong)Pump *pumpTo;
@end
