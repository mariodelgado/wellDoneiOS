//
//  PumpsMapViewController.m
//  WellDoneListMap
//
//  Created by Aparna Jain on 7/6/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "PumpsMapViewController.h"
#import "PumpLocation.h"

#define METERS_PER_MILE 1609.344

@interface PumpsMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation PumpsMapViewController

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
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleDone target:self action:@selector(onListButtonClick)];
    [listButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = listButton;
    [self plotPump];
    [self prepareMapLoad];
}
- (void)prepareMapLoad {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 37.79159;
    coordinate.longitude = -122.41212;
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE)];
}
-(void)onListButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)plotPump {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 37.79159;
    coordinate.longitude = -122.41212;
    PumpLocation *pump = [[PumpLocation alloc] initWithPumpName:@"Pump1" coordinate:coordinate];
    [self.mapView addAnnotation:pump];
}

- (NSArray *) pumpLatLongs {
    NSArray *pumpLocations = @[@{@"lat": @37.79159, @"lon": @-122.41212}, @{@"lat": @37.76248260039606, @"lon": @-122.43654705584049}];
    return pumpLocations;
    
//    , @{"lat": 37.7828, "lon": -122.42183}, @{"lat": 37.78791, "lon": -122.410768}, @{"lat": 37.78806, "lon": -122.41026}, @{"lat": 37.7808, "lon": -122.4702}, @{"lat": 37.80528, "lon": -122.41761}, @{"lat": 37.797161, "lon": -122.457831}, @{"lat": 37.78370724789609, "lon": -122.41082064807415}, @{"lat": 37.78695, "lon": -122.41143}, @{"lat": 37.55677, "lon": -122.30025}, @{"lat": 37.69742, "lon": -122.18802}, @{"lat": 37.65578, "lon": -122.40165}, @{"lat": 37.775, "lon": -122.418}, @{"lat": 37.78663, "lon": -122.40472}, @{"lat": 37.78698, "lon": -122.41171}, @{"lat": 37.78584, "lon": -122.40789}, @{"lat": 37.59224, "lon": -122.36265}, @{"lat": 37.78716, "lon": -122.41049}, @{"lat": 37.792298, "lon": -122.443018}];

    
}

@end
