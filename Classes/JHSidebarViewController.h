//
//  JHSidebarViewController.h
//  JHSidebar
//
//  Created by Josh Holtz on 12/30/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHSidebarViewController : UIViewController

@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

@property (nonatomic, assign) NSInteger leftSidebarWidth;
@property (nonatomic, assign) NSInteger rightSidebarWidth;

- (void)showLeftSidebar:(BOOL)show;
- (void)showRightSidebar:(BOOL)show;

@end

// We add a category of UIViewController to let childViewControllers easily access their parent SWRevealViewController
@interface UIViewController(JHSidebarViewController)

- (JHSidebarViewController*)sidebarViewController;

@end

#pragma mark - JHSidebarStoryboardSegue

@interface JHSidebarStoryboardSegue : UIStoryboardSegue

@property (strong) void(^performBlock)( JHSidebarStoryboardSegue* segue, UIViewController* sourceViewController, UIViewController* destinationViewController );

@end