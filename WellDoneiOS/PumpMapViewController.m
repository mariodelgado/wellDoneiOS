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
#import "AppDelegate.h"
#import "NextPumpMapViewController.h"
#import "CWStatusBarNotification.h"
#import "Report.h"
#import "MHPrettyDate.h"



#define METERS_PER_MILE 1609.344
#define GESTURE1_Y_OFFSET 243
#define MAP_POSITION_OFFSET 170
#define BROKEN_STATUS "BROKEN"


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
@property (weak, nonatomic) IBOutlet UIView *lightenView;
@property (nonatomic, assign) BOOL firstSwipe;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) CWStatusBarNotification *notification;




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

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportSavedShowNextRoute:) name:ReportSavedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToNextPump:) name:NextPumpSavedNotification object:nil];
        



    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    //    [self loadPumpFromPushNotification];
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleDone target:self action:@selector(onListButtonClick)];
    [listButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = listButton;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    UIImage* logoImage = [UIImage imageNamed:@"navBarHeader"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
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
    self.darkenView.layer.opacity = 0;
    self.lightenView.layer.opacity = 1;
    
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
    
    [NSTimer scheduledTimerWithTimeInterval:35.0f
                                     target:self selector:@selector(notif1:) userInfo:nil repeats:YES];
    
    
    [NSTimer scheduledTimerWithTimeInterval:65.0f
                                     target:self selector:@selector(notif2:) userInfo:nil repeats:YES];
}

-(void) notif1: (NSTimer *) timer {
    self.notification = [CWStatusBarNotification new];
    self.notification.notificationLabelBackgroundColor = [UIColor darkGrayColor];
    self.notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    [self.notification displayNotificationWithMessage:@"Pump 15 Status Changed to Fixed"
                                          forDuration:2.0f];
    
}


-(void) notif2: (NSTimer *) timer {
    self.notification = [CWStatusBarNotification new];
    self.notification.notificationLabelBackgroundColor = [UIColor colorWithRed:211/255.0f green:32/255.0f blue:0/255.0f alpha:1.0f];
    self.notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    [self.notification displayNotificationWithMessage:@"Pump 15 Status Changed to Broken"
                                          forDuration:3.0f];
    
}


- (int)loadPumpFromPushNotification {
    NSDictionary *pushPayload = [(AppDelegate *)[[UIApplication sharedApplication] delegate] notificationPayload];
    if (pushPayload) {
        NSString *pumpName = pushPayload[@"pumpName"];
        int index = 0;
        for (Pump *p in self.pumps) {
            index++;
            if ([p.name isEqualToString:pumpName]) {
                return index-1;
            }
        }
    }
    return 0;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) drawRect:(CGRect)viewContainer {
    [[UIColor colorWithWhite:0.0 alpha:0.5] setFill];
    UIRectFillUsingBlendMode( viewContainer , kCGBlendModeSoftLight);
}

- (void)viewWillAppear:(BOOL)animated{
    //  self.navigationController.navigationBarHidden = YES;
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
    if (self.firstSwipe == NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Light" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Animate" object:nil];
    }
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
        self.bottomContainerCenter = self.darkenView.center;
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
        self.darkenView.center = CGPointMake(self.bottomContainerCenter.x, self.bottomContainerCenter.y + translation.y);
        self.lightenView.center = CGPointMake(self.bottomContainerCenter.x, self.bottomContainerCenter.y + translation.y);
        
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Enable Page View Controller
        
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (velocity.y < 0) {
                CGPoint stop1;
                if (self.firstSwipe) {
                    self.darkenView.layer.opacity = .8;
                    self.lightenView.layer.opacity = 0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Light" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Animate" object:nil];
                    stop1 = CGPointMake(self.view.center.x, self.view.center.y + GESTURE1_Y_OFFSET);
                    self.firstSwipe = NO;
                    [self loadMapAtRegion: CGPointMake(0, MAP_POSITION_OFFSET)];
                }else{
                    stop1 = CGPointMake(self.view.center.x, self.view.center.y + 64); //set new height here
                    
                }
                self.viewContainer.center = stop1; //self.view.center;
                self.blurView.center = stop1;
                self.darkenView.center = stop1;
                self.lightenView.center = stop1;
            } else { //going down
                self.viewContainer.frame = CGRectMake(0, self.initialY, self.view.frame.size.width, self.view.frame.size.height);
                self.viewContainer.alpha = 1;
                self.blurView.frame = CGRectMake(0, self.initialY, self.view.frame.size.width, self.view.frame.size.height);
                self.darkenView.frame = CGRectMake(0, self.initialY, self.view.frame.size.width, self.view.frame.size.height);
                self.lightenView.frame = CGRectMake(0, self.initialY, self.view.frame.size.width, self.view.frame.size.height);
                self.darkenView.layer.opacity = 0;
                self.lightenView.layer.opacity = 1;
                self.firstSwipe = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Dark" object:nil];
            }
            
            
        } completion:^(BOOL finished) {
            nil;
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
- (void) setUpView: (int)index {
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
    [self.pageViewController setViewControllers:@[self.pumpViewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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
            int index;
            self.pumps = objects;
            //TODO: remove this line and tie it to a pump being clicked on the list view?

            if (!self.index) {//coming from the list view
                 index = [self loadPumpFromPushNotification];
                self.pump = self.pumps[index];
            }else {
                index = self.index;
                self.pump = self.pumps[self.index];

            }
            __weak PumpMapViewController *weakSelf = self;
            [Report getReportsForPump:self.pump withBlock:^(NSArray *objects, NSError *error) {
                Report *report = [objects firstObject];
                weakSelf.pump.lastUpdatedAt = [weakSelf giveMePrettyDate:report.updatedAt];
            }];
            [self setUpView: index];
            self.notification = [CWStatusBarNotification new];
            self.notification.notificationLabelBackgroundColor = [UIColor darkGrayColor];
            self.notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
            
            [self.notification displayNotificationWithMessage:@"Pumps Loaded."
                                                  forDuration:2.0f];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            self.notification = [CWStatusBarNotification new];
            
            [self.notification displayNotificationWithMessage:@"Download Error - No Internet Connection"
                                                  forDuration:1.0f];
        }
    }];
}
- (NSString *)giveMePrettyDate:(NSDate *)date {
    if (date) {
        return [MHPrettyDate prettyDateFromDate:date withFormat:MHPrettyDateLongRelativeTime];
    }else {
        return @"4 Hours Ago";
    }
}

- (void)setPump:(Pump *)pump {
    _pump = pump;
    if (self.firstSwipe) {
        [self loadMapAtRegion:CGPointMake(0, 0)];
    }else {
        [self loadMapAtRegion: CGPointMake(0, MAP_POSITION_OFFSET)];
    }
    
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
            if([pump.status isEqualToString:@BROKEN_STATUS]){
                pinView.image = [UIImage imageNamed:@"mMarkerBadCurrent"];
                
            }else {
                pinView.image = [UIImage imageNamed:@"mMarkerGoodCurrent"];
            }
            
        }else {
            if([pump.status isEqualToString:@BROKEN_STATUS]){
                pinView.image = [UIImage imageNamed:@"mMarkerBad"];
                
            }else {
                pinView.image = [UIImage imageNamed:@"mMarkerGood"];
            }
            
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
        int index = (int)[self.pumps indexOfObject:view.annotation];
        [self.pageViewController setViewControllers:@[self.pumpViewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.pump = selectedPump;
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews
{
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, 0);
        annView.layer.opacity = 0;
        [UIView animateWithDuration:0.4
                         animations:^{ annView.layer.opacity = 1; }];
    }
}

-(void)onListButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)reportSavedShowNextRoute:(NSNotification*)notification {
    
    Pump *currentPump = (Pump*)notification.userInfo[@"currentPump"];
    NextPumpMapViewController *npVC = [NextPumpMapViewController new];
    npVC.pumpFrom = currentPump;
    [self presentViewController:npVC animated:YES completion:nil];
    
}

-(void)goToNextPump:(NSNotification*)notification {
    
    Pump *nextPump = (Pump*)notification.userInfo[@"nextPump"];
    NSLog(@"Next Pump to show:%@",nextPump);
    
}

@end
