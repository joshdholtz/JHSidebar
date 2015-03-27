# JHSidebar

Probably just another sidebar library but this is the way I wanted them implemented.

## Features

- Use through Storyboard scenes or good old fashion **code** (see examples below)
- Configure sidebars to slide over the main view or slide with the main view
- Configure the width of the sidebars
- Configure sidebar open and close animation time
- Enable pan gestures for opening and closing sidebars
- Enable tap gesture to close sidebars
- Optional delegate for listening when the sidebars are opened or closed
- Access the JHSidebarViewController from any UIViewController by importing `#import <JHSidebar/JHSidebarViewController.h>`

## Installation

### Drop-in Classes
Clone the repository and drop in the .h and .m files from the "Classes" directory into your project.

### CocoaPods

JSONAPI is available through [CocoaPods](http://cocoapods.org), to install it simply add the following line to your Podfile:

    pod 'JHSidebar', '~> 0.1.3'

## Examples

### Open/Close/Toggle

````objc

- (void)onClickLeft:(id)sender {
    // Open left sidebar
    [self.sidebarViewController showLeftSidebar:YES];

    // Close left sidebar
    [self.sidebarViewController showLeftSidebar:NO];

    // Toggle left sidebar
    [self.sidebarViewController toggleLeftSidebar];
}

- (void)onClickRight:(id)sender {
    // Open right sidebar
    [self.sidebarViewController showRightSidebar:YES];

    // Close right sidebar
    [self.sidebarViewController showRightSidebar:NO];

    // Toggle right sidebar
    [self.sidebarViewController toggleRightSidebar];
}

````

### Setup - Storyboard

The main view, left sidebar, and right sidebar can be set up by naming scenes with the following default identifiers.

- JHMainView
- JHLeftSidebar
- JHRightSidebar

These are the default identifiers used to instantiate these view controllers from the Storyboard. If you'd like to override them or not use one you can override the following methods.

````objc
    - (UIViewController *)instantiateMainViewController; // override
    - (UIViewController *)instantiateLeftViewController; // override
    - (UIViewController *)instantiateRightViewController; // override
````

Either return a view controller or nil.

![](https://raw.github.com/joshdholtz/JHSidebar/master/Doc/example_storyboard.png)

### Setup - Good Old Fashion Code

If storyboards are not the route you want to take, you can initialize the JHSidebarViewController directly in your code by setting setting the main view controller and both, one, or none of the left and right sidebar view controllers.

AppDelegate.h
````objc

#import <UIKit/UIKit.h>

@class JHSidebarViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) JHSidebarViewController *sidebarViewController;

@end


````

AppDelegate.m
````objc

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
    [self.sidebarViewController setRightSidebarWidth:220.0f]; // Sets width of right sidebar
    
    // Sets "main view"
    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.sidebarViewController.mainViewController = navController;
    
    // Sets "left sidebar"
    self.sidebarViewController.leftViewController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:[NSBundle mainBundle]];
    
    // Sets "right sidebar"
    self.sidebarViewController.rightViewController = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:[NSBundle mainBundle]];
    
    self.window.rootViewController = self.sidebarViewController;
    
    return YES;
}

@end

````

## Author

Josh Holtz, josh@rokkincat.com, [@joshdholtz](https://twitter.com/joshdholtz)

## License

JHSidebar is available under the MIT license. See the LICENSE file for more info.

