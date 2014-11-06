//
//  JHSidebarViewController.h
//  JHSidebar
//
//  Created by Josh Holtz on 12/30/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JHSidebarLeft, JHSidebarRight
} JHSidebarSide;

typedef enum {
    JHSidebarOpen, JHSidebarClosed
} JHSidebarState;

@protocol JHSidebarDelegate;

@interface JHSidebarViewController : UIViewController

@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

@property (nonatomic, assign) BOOL slideMainViewWithLeftSidebar;
@property (nonatomic, assign) BOOL slideMainViewWithRightSidebar;
@property (nonatomic, assign) CGFloat leftOpenAnimationLength;
@property (nonatomic, assign) CGFloat leftCloseAnimationLength;
@property (nonatomic, assign) CGFloat rightOpenAnimationLength;
@property (nonatomic, assign) CGFloat rightCloseAnimationLength;
@property (nonatomic, assign) NSInteger leftSidebarWidth;
@property (nonatomic, assign) NSInteger rightSidebarWidth;

@property (nonatomic, assign, getter=isLeftSidebarTapGestureEnabled) BOOL leftSidebarTapGestureEnabled;
@property (nonatomic, assign, getter=isRightSidebarTapGestureEnabled) BOOL rightSidebarTapGestureEnabled;

@property (nonatomic, assign) id<JHSidebarDelegate> delegate;

- (void)enableTapGesture;
- (void)enablePanGesture;

- (void)toggleLeftSidebar;
- (void)toggleRightSidebar;

- (void)showLeftSidebar:(BOOL)show;
- (void)showRightSidebar:(BOOL)show;

- (UIViewController *)instantiateMainViewController; // override
- (UIViewController *)instantiateLeftViewController; // override
- (UIViewController *)instantiateRightViewController; // override

@end

@interface UIViewController(JHSidebarViewController)

- (JHSidebarViewController*)sidebarViewController;

@end

@protocol JHSidebarDelegate <NSObject>

- (void)sidebar:(JHSidebarSide)side stateChanged:(JHSidebarState)state;

@end