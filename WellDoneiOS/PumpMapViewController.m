//
//  PumpMapViewController.m
//  WellDoneiOS
//
//  Created by Aparna Jain on 7/12/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "PumpMapViewController.h"
#import "PumpDetailViewController.h"
#import <LiveFrost.h>


#define METERS_PER_MILE 1609.344
#define GESTURE1_Y_OFFSET 200


@interface PumpMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) NSMutableArray *pumpViewControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *bottomPanGestureRecognizer;
@property (nonatomic, assign) CGPoint bottomContainerCenter;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) CGFloat initialY;
@property (nonatomic, assign) BOOL firstLoad;
@property (weak, nonatomic) IBOutlet UIView *darkenView;
@property (nonatomic, assign) BOOL firstSwipe;



- (UIViewController *)pumpViewControllerAtIndex:(int)index;
- (IBAction)onBottomPan:(UIPanGestureRecognizer *)sender;
@end

@implementation PumpMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.firstLoad = YES;
        self.firstSwipe = YES;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self loadPumps];

    self.bottomPanGestureRecognizer.delegate = self;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self addChildViewController:self.pageViewController];
    

    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    self.pageViewController.view.frame = self.viewContainer.bounds;
    [self.viewContainer addSubview:self.pageViewController.view];    
    
    [self.pageViewController didMoveToParentViewController:self];
    self.initialY = self.viewContainer.frame.origin.y;
    
    self.blurView.center = CGPointMake(self.blurView.center.x, 900);
    self.viewContainer.center = CGPointMake(self.blurView.center.x, 900);
    self.viewContainer.layer.opacity = 0.0f;
    self.blurView.layer.opacity = 0.0f;

    [UIView animateWithDuration:.4 delay:1 usingSpringWithDamping:.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.blurView.center = CGPointMake(self.blurView.center.x, 745);
        self.viewContainer.center = CGPointMake(self.blurView.center.x, 745);
        self.viewContainer.layer.opacity = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.viewContainer.layer.opacity = 1.0f;
              self.blurView.layer.opacity = 1.0f;
        }];
    }];
}

-(void) drawRect:(CGRect)viewContainer {
    [[UIColor colorWithWhite:0.0 alpha:0.5] setFill];
    UIRectFillUsingBlendMode( viewContainer , kCGBlendModeSoftLight);
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark PageviewController data source methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    int index = (int)[self.pumpViewControllers indexOfObject:viewController];
    
    if (index > 0) {
        return [self pumpViewControllerAtIndex:index - 1];
    } else {
        return nil;
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    int index = (int)[self.pumpViewControllers indexOfObject:viewController];
    if (index < self.pumpViewControllers.count - 1) {
        return [self pumpViewControllerAtIndex:index + 1];
    } else {
        return nil;
    }
}

#pragma mark PageviewController delegate methods

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers NS_AVAILABLE_IOS(6_0){
        self.panGestureRecognizer.enabled = YES;
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    int index = (int)[self.pumpViewControllers indexOfObject:pageViewController.viewControllers[0]];
    self.pump = self.pumps[index];
}

- (UIViewController *)pumpViewControllerAtIndex:(int)index {
    return self.pumpViewControllers[index];
}

#pragma mark Pan handler

- (IBAction)onBottomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    self.panGestureRecognizer = panGestureRecognizer;
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    if (fabs(velocity.y) > fabs(velocity.x)) {
        [self disablePageViewController];
        panGestureRecognizer.enabled = YES;
    }else {
        [self enablePageViewController];
        panGestureRecognizer.enabled = NO;
    }

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touch = [panGestureRecognizer locationInView:self.viewContainer];
        if (touch.y > 50) {
            // Cancel current gesture
        }
        self.bottomContainerCenter = self.viewContainer.center;
        self.bottomContainerCenter = self.blurView.center;
        // Disable Page View Controller
        
        if (fabs(velocity.y) > fabs(velocity.x)) {
            [self disablePageViewController];
            panGestureRecognizer.enabled = YES;
        }else {
            [self enablePageViewController];
            panGestureRecognizer.enabled = NO;
        }

    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.viewContainer.center = CGPointMake(self.bottomContainerCenter.x, self.bottomContainerCenter.y + translation.y);
        self.blurView.center = CGPointMake(self.bottomContainerCenter.x, self.bottomContainerCenter.y + translation.y);
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Enable Page View Controller
        [UIView animateWithDuration:0.5 animations:^{
            if (velocity.y < 0) {
                CGPoint stop1;
                if (self.firstSwipe) {
                     stop1 = CGPointMake(self.view.center.x, self.view.center.y + GESTURE1_Y_OFFSET);
                    self.firstSwipe = NO;
                    CGRect annotationRect = CGRectMake(0, 0, 320, GESTURE1_Y_OFFSET);
                    MKCoordinateRegion adjustedRegion = [self.mapView convertRect:annotationRect toRegionFromView:self.mapView];
                    [self.mapView setRegion:adjustedRegion animated:YES];
                    [self loadMapAtRegion:CGPointMake(0, 200)];
                }else{
                     stop1 = CGPointMake(self.view.center.x, self.view.center.y);
                }
                self.viewContainer.center = stop1; //self.view.center;
                self.blurView.center = stop1;
            } else { //going down
                self.viewContainer.frame = CGRectMake(0, self.initialY, self.view.frame.size.width, self.view.frame.size.height);
                self.viewContainer.alpha = 1;
                self.blurView.frame = CGRectMake(0, self.initialY, self.view.frame.size.width, self.view.frame.size.height);
                self.firstSwipe = YES;
            }
 
        }];
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

#pragma mark- Setting up pageviews and adding annotations
- (void) setUpView {
    self.pumpViewControllers = [NSMutableArray array];
    for (Pump *p in self.pumps) {
        if(self.firstLoad){
            PumpDetailViewController *currPumpController = [[PumpDetailViewController alloc] init];
            // TODO: Only if there are performance issues with 20 view controllers, then switch to using a dictionary and lazy create the view controllers. The key of the dictionary is the index of the pump.
            currPumpController.pump = p;
            [self.pumpViewControllers addObject:currPumpController];
        }
    }
    self.firstLoad = NO;
    [self.pageViewController setViewControllers:@[self.pumpViewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}
- (void) plotAllPumpsInView {
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (Pump *p in self.pumps) {
           [self plotPump:p];
    }
}

//TODO: remove this call from here
- (void) loadPumps {
    PFQuery *queryForReports = [Pump query];
    [queryForReports findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.pumps = objects;
            //TODO: remove this line and tie it to a pump being clicked on the list view?
            self.pump = self.pumps[0];
            [self setUpView];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)setPump:(Pump *)pump {
    _pump = pump;
    [self loadMapAtRegion: CGPointMake(0, 0)];
    [self plotPump:pump];
    [self plotAllPumpsInView];
}

- (void)loadMapAtRegion: (CGPoint)offset {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.pump.location.latitude;
    coordinate.longitude = self.pump.location.longitude;
    if (offset.y != 0) {
            [self moveCenterByOffset:offset from:coordinate];
    }else{
            [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE) animated:YES];
    }



}
- (void)moveCenterByOffset:(CGPoint)offset from:(CLLocationCoordinate2D)coordinate
{
    CGPoint point = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
    point.x += offset.x;
    point.y += offset.y;
    CLLocationCoordinate2D center = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:center animated:YES];
}

- (void)plotPump:(Pump *)pump {
    [self.mapView addAnnotation:pump];
}

#pragma mark MapView delegate methods

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //add a delay here and test
//    [self.mapView selectAnnotation:self.pump animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{

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
        if (pump == self.pump) {
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0)
{
    Pump *selectedPump = (Pump *)view.annotation;
    if(selectedPump != self.pump){
        int index = [self.pumps indexOfObject:view.annotation];
        [self.pageViewController setViewControllers:@[self.pumpViewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.pump = selectedPump;
    }
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

-(void)onListButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
