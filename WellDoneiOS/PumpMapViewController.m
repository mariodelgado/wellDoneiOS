//
//  PumpMapViewController.m
//  WellDoneiOS
//
//  Created by Aparna Jain on 7/12/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "PumpMapViewController.h"
#import "PumpDetailViewController.h"

#define METERS_PER_MILE 1609.344

@interface PumpMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) NSArray *pumpViewControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *bottomPanGestureRecognizer;
@property (nonatomic, assign) CGPoint bottomContainerCenter;

- (UIViewController *)pumpViewControllerAtIndex:(int)index;
- (IBAction)onBottomPan:(UIPanGestureRecognizer *)sender;
@end

@implementation PumpMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        PumpDetailViewController *firstPumpViewController = [[PumpDetailViewController alloc] init];
        //        firstPumpViewController.pump = //;
        firstPumpViewController.view.backgroundColor = [UIColor redColor];
        
        PumpDetailViewController *secondPumpViewController = [[PumpDetailViewController alloc] init];
        secondPumpViewController.view.backgroundColor = [UIColor blueColor];
        
        // TODO: Only if there are performance issues with 20 view controllers, then switch to using a dictionary and lazy create the view controllers. The key of the dictionary is the index of the pump.
        self.pumpViewControllers = @[firstPumpViewController, secondPumpViewController];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPumps];
    //    [self prepareMapLoad];
    self.mapView.delegate = self;
    
    self.bottomPanGestureRecognizer.delegate = self;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self addChildViewController:self.pageViewController];
    

    self.pageViewController.delegate = self;
    //TODO: fix this warning
    self.pageViewController.dataSource = self;
    
    self.pageViewController.view.frame = self.viewContainer.bounds;
    [self.viewContainer addSubview:self.pageViewController.view];
    
    [self.pageViewController setViewControllers:@[self.pumpViewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    int index = [self.pumpViewControllers indexOfObject:viewController];
    
    if (index > 0) {
        return [self pumpViewControllerAtIndex:index - 1];
    } else {
        return nil;
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    int index = [self.pumpViewControllers indexOfObject:viewController];
    
    if (index < self.pumpViewControllers.count - 1) {
        return [self pumpViewControllerAtIndex:index + 1];
    } else {
        return nil;
    }
}

- (UIViewController *)pumpViewControllerAtIndex:(int)index {
    return self.pumpViewControllers[index];
}

- (IBAction)onBottomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    NSLog(@"self view y %f",self.view.frame.origin.y);
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touch = [panGestureRecognizer locationInView:self.viewContainer];
        if (touch.y > 50) {
            // Cancel current gesture
        }
        self.bottomContainerCenter = self.viewContainer.center;
        // Disable Page View Controller
        
        if (fabs(velocity.y) > fabs(velocity.x)) {
            [self disablePageViewController];
        }
        
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.viewContainer.center = CGPointMake(self.bottomContainerCenter.x, self.bottomContainerCenter.y + translation.y);
        
        if (fabs(velocity.y) > fabs(velocity.x)) {
            [self disablePageViewController];
        } else {
            [self enablePageViewController];
        }
        
        
        
        if (velocity.y > 0) {
            self.viewContainer.alpha = 0.5;
            
        }
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Enable Page View Controller
        [UIView animateWithDuration:1 animations:^{
            if (velocity.y < 0) {
                self.viewContainer.center = self.view.center;
            } else if (velocity.y > 0) { //going down
                self.viewContainer.frame = CGRectMake(0, 500, self.view.frame.size.width, self.view.frame.size.height);
                self.viewContainer.alpha = 1;
            }
        }];
        
        [self enablePageViewController];
    }
}
- (void) disablePageViewController{
    for (UIScrollView *view  in self.pageViewController.view.subviews) {
        if([view isKindOfClass:[UIScrollView class]]){
            view.scrollEnabled = NO;
        }
    }
}
- (void) enablePageViewController{
    for (UIScrollView *view  in self.pageViewController.view.subviews) {
        if([view isKindOfClass:[UIScrollView class]]){
            view.scrollEnabled = YES;
        }
    }
}

- (void) setUpView {
    //TODO: remove this line
    self.pump = self.pumps[0];
    [self prepareMapLoad];
    for (Pump *p in self.pumps) {
        [self plotPump:p];
    }
}
- (void) loadPumps {
    PFQuery *queryForReports = [Pump query];
    [queryForReports findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.pumps = objects;
            [self setUpView];
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)prepareMapLoad {
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = self.pump.location.latitude;
    coordinate.longitude = self.pump.location.longitude;
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE)];
}
-(void)onListButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)plotPump:(Pump *)pump {
    //NSLog(@"%f %f", pump.coordinate.latitude, pump.coordinate.longitude);
    [self.mapView addAnnotation:pump];
}

#pragma mark MapView delegate methods
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    if(annotation != self.mapView.userLocation)
    {
        static NSString *defaultPinID = @"map.welldone";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];

        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"07-map-marker"];
    }
    else {
        [self.mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews
{
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        [UIView animateWithDuration:0.9
                         animations:^{ annView.frame = endFrame; }];
    }
}

@end
