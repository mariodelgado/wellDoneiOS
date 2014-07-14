//
//  PumpMapViewController.h
//  WellDoneiOS
//
//  Created by Aparna Jain on 7/12/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Pump.h"

@interface PumpMapViewController : UIViewController<MKMapViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate>
@property  (nonatomic, strong) Pump *pump;
@property  (nonatomic, strong) NSArray *pumps;
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

@end
