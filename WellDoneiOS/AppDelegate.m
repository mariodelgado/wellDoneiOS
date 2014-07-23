//
//  AppDelegate.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/9/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "PumpsListViewController.h"
#import "ReportViewController.h"
#import "Report.h"
#import "Pump.h"
#import "PumpMapViewController.h"
#import "PumpsListViewController.h"
#import "LoginViewController.h"
#import "onboardingViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "Reachability.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Pump registerSubclass];
    [Report registerSubclass];
    [Parse setApplicationId:@"XR5W6MLXuh81taNlbhRQ82mLlzOxmfLnv0isdvvi"
                  clientKey:@"jp00u3EcjTA4ZRh5dBNGC8mTgbak2U0anLlPrswW"];
    
    
    self.notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[onboardingViewController alloc] init]];
//  UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[PumpsListViewController alloc] init]];
    
    
    
    self.window.rootViewController = nvc;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    //Internet
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    // Start Monitoring
    [reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];

    //Intial Internet is YES ..Assumption
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isReachable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    BOOL isReachable;
    if (reachability.isReachable) {
        isReachable = YES;
    } else {
        isReachable = NO;
    }
    [[NSUserDefaults standardUserDefaults] setBool:isReachable forKey:@"isReachable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





@end
