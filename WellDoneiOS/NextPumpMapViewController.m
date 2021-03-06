//
//  NextPumpMapViewController.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/20/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "NextPumpMapViewController.h"
#import <MapKit/MapKit.h>
#import <LiveFrost.h>
#import "AFNetworkReachabilityManager.h"
#import "CWStatusBarNotification.h"
#import "Reachability.h"

#define METERS_PER_MILE 1609.344
#define Y_OFFSET 194

NSString * const NextPumpSavedNotification = @"NextPumpSavedNotification";

@interface NextPumpMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *overLayView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
//@property (weak, nonatomic) IBOutlet UILabel *lblPumpName;
//@property (weak, nonatomic) IBOutlet UILabel *lblTimeTaken;
@property (weak, nonatomic) IBOutlet UIImageView *mapIcon;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;
@property (assign, nonatomic) CGPoint overLayCenter;
@property (assign, nonatomic) CGPoint overLayCenterOriginal;
- (IBAction)onClose:(id)sender;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) CWStatusBarNotification *notification;
@property (assign, nonatomic) BOOL isThereNetwork;
@property (weak, nonatomic) IBOutlet UILabel *nextPumpName;
@property (weak, nonatomic) IBOutlet UILabel *nextPumpDistance;


@property (weak, nonatomic) IBOutlet UIImageView *downArrod;


@end

@implementation NextPumpMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isThereNetwork = YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.overLayCenterOriginal = CGPointMake(self.overLayView.center.x, self.overLayView.center.y);
    self.mapView.delegate = self;
    [self setPanGestureOnOverlayView];
    
    self.mapIcon.transform = CGAffineTransformMakeScale(0, 0);
    self.checkMark.transform = CGAffineTransformMakeScale(0, 0);
    
    self.nextPumpDistance.layer.opacity = 0;
    self.nextPumpName.layer.opacity = 0;
    
    self.downArrod.transform = CGAffineTransformMakeRotation(M_PI);
    
    //Get Next close by broken pump.
    [Pump getPumpsCloseToLocation:self.pumpFrom.location withStatus:PumpStatusBroken block:^(NSArray *objects, NSError *error) {
        self.pumpTo = (Pump*)(objects[1]); 
        self.nextPumpName.text = self.pumpTo.name;
        
        [self getDrivingTimeFromCurrentPump:self.pumpFrom.location ToNextPump:self.pumpTo.location];
        [self loadMapAtRegion];
        [self getDirections];
        
        
        [UIView animateWithDuration:.2 delay:0.8 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.mapIcon.layer.opacity = 0.62;
            
            self.mapIcon.transform = CGAffineTransformMakeScale(1, 1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.4 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.mapIcon.center = CGPointMake(160, 174);
                
                self.checkMark.transform = CGAffineTransformMakeScale(1, 1);
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.mapIcon.center = CGPointMake(160, 174);
                    
                } completion:^(BOOL finished) {
                    
                    
                }];
                
            }];
            
        }];

    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMapAtRegion {
    
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.pumpFrom.location.latitude;
    coordinate.longitude = self.pumpFrom.location.longitude;
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE) animated:YES];
    
    [self.mapView addAnnotation:self.pumpFrom];
    [self.mapView addAnnotation:self.pumpTo];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    Pump *pump = (Pump *)annotation;
    MKAnnotationView *pinView = nil;
    if(annotation != self.mapView.userLocation)
    {
        static NSString *defaultPinID = @"map.welldone";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        if (pump == self.pumpTo) {
            pinView.image = [UIImage imageNamed:@"mMarkerBad"];
        }else {
            pinView.image = [UIImage imageNamed:@"mMarkerGood"];
        }
        
    }
    else {
        [self.mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
    
}

-(void)getDirections {
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    
    CLLocationCoordinate2D currentLocation;
    currentLocation.latitude = self.pumpFrom.location.latitude;
    currentLocation.longitude = self.pumpFrom.location.longitude;
    
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:currentLocation addressDictionary:nil]];
    request.source = source;
    
    CLLocationCoordinate2D nextLocation;
    nextLocation.latitude = self.pumpTo.location.latitude;
    nextLocation.longitude = self.pumpTo.location.longitude;
    
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:nextLocation addressDictionary:nil]];
    
    request.destination = destination;
    
    //    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions =[[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            // Handle Error
            NSLog(@"Error:%@",error.description);
        } else {
            NSLog(@"Log:%lu",(unsigned long)[response.routes count]);
            [self showRoute:response];
        }
    }];
    
    
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    //    for (MKRoute *route in response.routes)
    //    {
    //        [self.mapView
    //         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    //    }
    MKRoute *route = response.routes[0];
    [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    [self centerMapWithRespone:route];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
    renderer.strokeColor =  [UIColor colorWithRed:0 green:0.569 blue:1 alpha:1];
    renderer.lineWidth = 4;
    return renderer;
}

-(void) getDrivingTimeFromCurrentPump:(PFGeoPoint*)currentPumpLocation ToNextPump:(PFGeoPoint*)location {
    MKDirectionsRequest *directionRequest = [MKDirectionsRequest new];
    directionRequest.transportType = MKDirectionsTransportTypeAny;
    
    CLLocationCoordinate2D currentLocation;
    currentLocation.latitude = currentPumpLocation.latitude;
    currentLocation.longitude = currentPumpLocation.longitude;
    
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:currentLocation addressDictionary:nil]];
    directionRequest.source = source;
    
    
    CLLocationCoordinate2D nextLocation;
    nextLocation.latitude = location.latitude;
    nextLocation.longitude = location.longitude;
    
    
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:nextLocation addressDictionary:nil]];
    directionRequest.destination = destination;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionRequest];
    
    [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
        NSLog(@"Response:%@",response);
        NSLog(@"ETA:%f",response.expectedTravelTime);
        self.nextPumpDistance.text = [NSString stringWithFormat:@"%d mins Away", (int)(response.expectedTravelTime/60) ];
        
    }];
    
    
    
}

-(void)setPanGestureOnOverlayView {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.overLayView addGestureRecognizer:panGestureRecognizer];
}


-(void)onPan:(UIPanGestureRecognizer*)panGestureRecognizer {
    
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.overLayCenter = self.overLayView.center;
        NSLog(@"Center: %f", self.overLayCenter.y);
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.overLayView.center = CGPointMake(self.overLayCenter.x, self.overLayCenter.y + translation.y);
        
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"PanGesture Ended");
        // Enable Page View Controller
        [UIView animateWithDuration:0.5 animations:^{
            if (velocity.y < 0) {
                
                CGPoint closed = CGPointMake(self.view.center.x, self.view.center.y - Y_OFFSET);
                
                //                    CGRect annotationRect = CGRectMake(0, 0, 320, GESTURE1_Y_OFFSET);
                //                    MKCoordinateRegion adjustedRegion = [self.mapView convertRect:annotationRect toRegionFromView:self.mapView];
                self.blurView.layer.opacity = 0;
                
                self.nextPumpDistance.layer.opacity = 1;
                self.nextPumpName.layer.opacity = 1;
                self.downArrod.transform = CGAffineTransformMakeRotation(M_PI /2);
                self.downArrod.layer.opacity = 0;
                
                self.overLayView.center = closed; //self.view.center;
                //                self.blurView.center = closed;
            } else { //going down
                self.blurView.layer.opacity = 1;
                
                self.nextPumpDistance.layer.opacity = 0;
                self.nextPumpName.layer.opacity = 0;
                self.downArrod.transform = CGAffineTransformMakeRotation(M_PI);
                self.downArrod.layer.opacity = 1;
                
                
                self.overLayView.center = self.overLayCenterOriginal;
                
                //                self.blurView.frame = CGRectMake(0, self.initialY, self.view.frame.size.width, self.view.frame.size.height);
                
            }
            
        }];
    }
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.pumpTo) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NextPumpSavedNotification object:self userInfo:@{@"nextPump":self.pumpTo}];
        }
        
    }];
}


-(void) centerMapWithRespone:(MKRoute *)route
{
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90.0;
    CLLocationDegrees maxLon = -180.0;
    CLLocationDegrees minLat = 90.0;
    CLLocationDegrees minLon = 180.0;
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:self.pumpFrom.location.latitude longitude:self.pumpFrom.location.longitude];
    CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:self.pumpTo.location.latitude longitude:self.pumpTo.location.longitude];
    NSArray *routes = @[currentLocation, toLocation];
    
    for(int idx = 0; idx < routes.count; idx++)
    {
        CLLocation* currentLocation = [routes objectAtIndex:idx];
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    region.center.latitude     = (maxLat + minLat) / 2.0;
    region.center.longitude    = (maxLon + minLon) / 2.0;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    
    region.span.latitudeDelta  = ((maxLat - minLat)<0.0)?100.0:(maxLat - minLat);
    region.span.latitudeDelta = region.span.latitudeDelta *1.8;
    region.span.longitudeDelta = ((maxLon - minLon)<0.0)?100.0:(maxLon - minLon);
    region.span.longitudeDelta = region.span.longitudeDelta *1.8;
    [self.mapView setRegion:region animated:YES];
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

- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    self.isThereNetwork = [reachability isReachable];
    
    //    if ([reachability isReachable]) {
    //        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //
    //    } else {
    //        [self performSegueWithIdentifier:@"noInternet" sender:self];
    //    }
}


@end
