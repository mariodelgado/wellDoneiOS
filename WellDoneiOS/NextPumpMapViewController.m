//
//  NextPumpMapViewController.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/20/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "NextPumpMapViewController.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344
#define Y_OFFSET 284

@interface NextPumpMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *overLayView;
@property (weak, nonatomic) IBOutlet UILabel *lblPumpName;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeTaken;
@property (assign, nonatomic) CGPoint overLayCenter;
@property (assign, nonatomic) CGPoint overLayCenterOriginal;

@end

@implementation NextPumpMapViewController

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
    self.overLayCenterOriginal = CGPointMake(self.overLayView.center.x, self.overLayView.center.y);
    self.mapView.delegate = self;
    [self setPanGestureOnOverlayView];
   
    //This is only for testing delete it.
    PFQuery *pumpQuery = [Pump query];
    [pumpQuery whereKey:@"name" equalTo:@"Pump17"];
    NSArray *pumps = [pumpQuery findObjects];
    self.pumpFrom = [pumps firstObject];
    
    //Get Next close by broken pump.
    [Pump getPumpsCloseToLocation:self.pumpFrom.location withStatus:PumpStatusBroken block:^(NSArray *objects, NSError *error) {
        self.pumpTo = (Pump*)(objects[1]);
        self.lblPumpName.text = self.pumpTo.name;
        
        [self getDrivingTimeFromCurrentPump:self.pumpFrom.location ToNextPump:self.pumpTo.location];
        [self loadMapAtRegion];
        [self getDirections];

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
    NSLog(@"I am called!");
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
            pinView.image = [UIImage imageNamed:@"177-building"];
        }else {
            pinView.image = [UIImage imageNamed:@"07-map-marker"];
        }
        
    }
    else {
        [self.mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;

}

-(void)getDirections {
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.transportType = MKDirectionsTransportTypeWalking;

    
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
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 2.5;
    return renderer;
}

-(void) getDrivingTimeFromCurrentPump:(PFGeoPoint*)currentPumpLocation ToNextPump:(PFGeoPoint*)location {
    MKDirectionsRequest *directionRequest = [MKDirectionsRequest new];
    directionRequest.transportType = MKDirectionsTransportTypeAutomobile;
    
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
        self.lblTimeTaken.text = [NSString stringWithFormat:@"%d mins Away", (int)(response.expectedTravelTime/60) ];
        
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
                    
                
                self.overLayView.center = closed; //self.view.center;
//                self.blurView.center = closed;
            } else { //going down


                
                self.overLayView.center = self.overLayCenterOriginal;

//                self.blurView.frame = CGRectMake(0, self.initialY, self.view.frame.size.width, self.view.frame.size.height);

            }
            
        }];
    }
}









@end