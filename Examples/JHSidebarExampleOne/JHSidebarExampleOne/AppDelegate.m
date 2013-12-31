//
//  AppDelegate.m
//  JHSidebarExampleOne
//
//  Created by Josh Holtz on 12/30/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

#import <JHSidebar/JHSidebarViewController.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    // Initializes JHSidebarViewController
    self.sidebarViewController = [[JHSidebarViewController alloc] init];
    [self.sidebarViewController enableTapGesture]; // Enables tap on open sidebar to close
    [self.sidebarViewController enablePanGesture]; // Enables panning to open and close sidebars
    [self.sidebarViewController setSlideMainViewWithLeftSidebar:YES]; // Main view will slide with side bar instead of left side bar overlapping main view
    [self.sidebarViewController setSlideMainViewWithRightSidebar:YES];
    [self.sidebarViewController setRightSidebarWidth:220.0f]; // Sets width of right sidebar
    
    // Sets "main" view
    self.sidebarViewController.mainViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    
    // Sets "left sidebar"
    self.sidebarViewController.leftViewController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:[NSBundle mainBundle]];
    
    // Sets "right sidebar"
    self.sidebarViewController.rightViewController = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:[NSBundle mainBundle]];
    
    self.window.rootViewController = self.sidebarViewController;
    
    return YES;
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
