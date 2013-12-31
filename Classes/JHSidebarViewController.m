//
//  JHSidebarViewController.m
//  JHSidebar
//
//  Created by Josh Holtz on 12/30/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#define kJHSidebarMain @"JHSidebarMain"
#define kJHSidebarLeft @"JHSidebarLeft"
#define kJHSidebarRight @"JHSidebarRight"

#import "JHSidebarViewController.h"

@interface JHSidebarViewController ()

@property (nonatomic, strong) UIView *viewContainerMain;
@property (nonatomic, strong) UIView *viewContainerLeft;
@property (nonatomic, strong) UIView *viewContainerRight;

@end

@implementation JHSidebarViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _leftSidebarWidth = 270.0f;
    _rightSidebarWidth = 270.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    // Load main view and sidebar views from storyboard
    if (self.storyboard && _mainViewController == nil){
        // Trying main sequeue
        @try {
            [self performSegueWithIdentifier:kJHSidebarMain sender:nil];
        } @catch(NSException *exception) { }
        
        // Trying left sequeue
        @try {
            [self performSegueWithIdentifier:kJHSidebarLeft sender:nil];
        } @catch(NSException *exception) { }
        
        // Trying right sequeue
        @try {
            [self performSegueWithIdentifier:kJHSidebarRight sender:nil];
        } @catch(NSException *exception) { }
    }
    
}

- (void)prepareForSegue:(JHSidebarStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kJHSidebarMain]) {
        [self setMainViewController:segue.destinationViewController];
    } else if ([segue.identifier isEqualToString:kJHSidebarLeft]) {
        [self setLeftViewController:segue.destinationViewController];
    } if ([segue.identifier isEqualToString:kJHSidebarRight]) {
        [self setRightViewController:segue.destinationViewController];
    }
    
}

#pragma mark - Public

- (void)showLeftSidebar:(BOOL)show {
    // Initializes left sidebar view if not already attached
    if (_viewContainerLeft == nil) {
        _viewContainerLeft = [[UIView alloc] initWithFrame:CGRectMake(-CGRectGetWidth(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        
        UIView *viewContainerLeftInner = [[UIView alloc] initWithFrame:_viewContainerLeft.frame];
        [_viewContainerLeft addSubview:viewContainerLeftInner];
        
        CGRect frame = viewContainerLeftInner.frame;
        frame.origin.x = _leftSidebarWidth - viewContainerLeftInner.frame.size.width;
        [viewContainerLeftInner setFrame:frame];
        
        [self.view addSubview:_viewContainerLeft];
        
        [viewContainerLeftInner addSubview:_leftViewController.view];
    }
    
    // Shows and hides left sidebar view
    if (show == YES) {
        
        CGRect frame = _viewContainerLeft.frame;
        frame.origin.x = 0;
        
        [UIView animateWithDuration:0.35 animations:^{
            [_viewContainerLeft setFrame:frame];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        
    }
}

- (void)showRightSidebar:(BOOL)show {
    // Initializes left sidebar view if not already attached
    if (_viewContainerRight == nil) {
        _viewContainerRight = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        
        UIView *viewContainerRightInner = [[UIView alloc] initWithFrame:_viewContainerRight.frame];
        [_viewContainerRight addSubview:viewContainerRightInner];
        
        CGRect frame = viewContainerRightInner.frame;
        frame.origin.x = viewContainerRightInner.frame.size.width - _rightSidebarWidth;
        [viewContainerRightInner setFrame:frame];
        
        [self.view addSubview:_viewContainerRight];
        
        [viewContainerRightInner addSubview:_rightViewController.view];
    }
    
    // Shows and hides left sidebar view
    if (show == YES) {
        
        CGRect frame = _viewContainerRight.frame;
        frame.origin.x = 0;
        
        [UIView animateWithDuration:0.35 animations:^{
            [_viewContainerRight setFrame:frame];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        NSLog(@"Show - NO");
    }
}

#pragma mark - Setting views

- (void)setMainViewController:(UIViewController *)mainViewController {
    if (_mainViewController != nil) return;
    
    _mainViewController = mainViewController;
    [self addChildViewController:self.mainViewController];
    
    _viewContainerMain = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:_viewContainerMain atIndex:0];
    
    [_viewContainerMain addSubview:_mainViewController.view];
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (_leftViewController != nil) return;
    
    _leftViewController = leftViewController;
    [self addChildViewController:self.leftViewController];
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    if (_rightViewController != nil) return;
    
    _rightViewController = rightViewController;
    [self addChildViewController:self.leftViewController];
}

@end

@implementation UIViewController(JHSidebarViewController)

- (JHSidebarViewController*)sidebarViewController
{
    UIViewController *parent = self;
    Class revealClass = [JHSidebarViewController class];
    
    while ( nil != (parent = [parent parentViewController]) && ![parent isKindOfClass:revealClass] )
    {
    }
    
    return (id)parent;
}

@end

@implementation JHSidebarStoryboardSegue

- (void)perform {
    
}

@end