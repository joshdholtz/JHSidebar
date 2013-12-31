# JHSidebar

Probably just another sidebar library but this is the way I wanted them done.

## Features

- Use through **storyboard segues** or good old fashion **code** (see examples below)
- Configure sidebars to slide over the main view or slide with the main view
- Configure the width of the sidebars
- Configure sidebar open and close animation time

## Installation

### Drop-in Classes
Clone the repository and drop in the .h and .m files from the "Classes" directory into your project.

### CocoaPods

JSONAPI is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod 'JSONAPI', :git => git@github.com:joshdholtz/JHSidebar.git

## Examples

### Storyboard Segues

### Good Old Fashion Code

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

Josh Holtz, josh@rokkincat.com

## License

JHSidebar is available under the MIT license. See the LICENSE file for more info.

