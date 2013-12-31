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

@property (nonatomic, strong) UIView *viewContainerInnerLeft;
@property (nonatomic, strong) UIView *viewContainerInnerRight;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureLeftSidebar;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRightSidebar;

@property (nonatomic, strong) NSMutableArray *operationQueue;

@end

typedef void (^OperationBlock)(JHSidebarViewController *sidebarViewController);

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
    _operationQueue = [NSMutableArray array];
    
    _slideMainViewWithLeftSidebar = NO;
    _slideMainViewWithRightSidebar = NO;
    
    _leftOpenAnimationLength = 0.35;
    _leftCloseAnimationLength = 0.35f;
    _rightOpenAnimationLength = 0.35f;
    _rightCloseAnimationLength = 0.35f;
    
    _leftSidebarWidth = 270.0f;
    _rightSidebarWidth = 270.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Creating left container view (same size as self.view)
    if (_viewContainerLeft == nil) {
        _viewContainerLeft = [[UIView alloc] initWithFrame:CGRectMake(-CGRectGetWidth(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    }
    
    // Creating right container view (same size as self.view)
    if (_viewContainerRight == nil) {
        _viewContainerRight = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    }
    
    for (OperationBlock block in _operationQueue) {
        block(self);
    }
    [_operationQueue removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
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

- (void)enableTapGesture {
    
    // Adidng tap gesture to close left sidebar
    if (_tapGestureLeftSidebar == nil) {
        
        [_operationQueue addObject:^(JHSidebarViewController* sidebarViewController){
            sidebarViewController.tapGestureLeftSidebar = [[UITapGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onTapCloseLeftSidebar:)];
            [sidebarViewController.viewContainerLeft addGestureRecognizer:sidebarViewController.tapGestureLeftSidebar];
        }];
    }
    
    // Adidng tap gesture to close right sidebar
    if (_tapGestureRightSidebar == nil) {
        
        [_operationQueue addObject:^(JHSidebarViewController* sidebarViewController){
            sidebarViewController.tapGestureRightSidebar = [[UITapGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onTapCloseRightSidebar:)];
            [sidebarViewController.viewContainerRight addGestureRecognizer:sidebarViewController.tapGestureRightSidebar];
        }];
    }
    
    if (_viewContainerLeft != nil && _viewContainerRight != nil) {
        for (OperationBlock block in _operationQueue) {
            block(self);
        }
        [_operationQueue removeAllObjects];
    }
}

- (void)showLeftSidebar:(BOOL)show {
    // Initializes left sidebar view if not already attached
    [self attachLeftSidebar];
    
    // Shows and hides left sidebar view
    if (show == YES) {
        
        CGRect frame = _viewContainerLeft.frame;
        frame.origin.x = 0;
        
        CGRect mainFrame = _viewContainerMain.frame;
        if (_slideMainViewWithLeftSidebar == YES) {
            mainFrame.origin.x = _leftSidebarWidth;
        }
        
        [UIView animateWithDuration:_leftOpenAnimationLength animations:^{
            [_viewContainerLeft setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        
        CGRect frame = _viewContainerLeft.frame;
        frame.origin.x = -CGRectGetWidth(_viewContainerLeft.frame);
        
        CGRect mainFrame = _viewContainerMain.frame;
        if (_slideMainViewWithLeftSidebar == YES) {
            mainFrame.origin.x = 0.0f;;
        }
        
        [UIView animateWithDuration:_leftCloseAnimationLength animations:^{
            [_viewContainerLeft setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showRightSidebar:(BOOL)show {
    // Initializes right sidebar view if not already attached
    [self attachRightSidebar];
    
    // Shows and hides right sidebar view
    if (show == YES) {
        
        CGRect frame = _viewContainerRight.frame;
        frame.origin.x = 0;
        
        CGRect mainFrame = _viewContainerMain.frame;
        if (_slideMainViewWithRightSidebar == YES) {
            mainFrame.origin.x = -_rightSidebarWidth;
        }
        
        [UIView animateWithDuration:_rightOpenAnimationLength animations:^{
            [_viewContainerRight setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            
        }];
    } else {

        CGRect frame = _viewContainerRight.frame;
        frame.origin.x = CGRectGetWidth(self.view.frame);
        
        CGRect mainFrame = _viewContainerMain.frame;
        if (_slideMainViewWithRightSidebar == YES) {
            mainFrame.origin.x = 0.0f;
        }
        
        [UIView animateWithDuration:_rightCloseAnimationLength animations:^{
            [_viewContainerRight setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            
        }];
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

#pragma mark - Private

- (void)attachLeftSidebar {
    if (_viewContainerInnerLeft == nil) {
        
        // Places an inner container (to the set width in the settings) inside the container view
        _viewContainerInnerLeft = [[UIView alloc] initWithFrame:_viewContainerLeft.frame];
        [_viewContainerLeft addSubview:_viewContainerInnerLeft];
        
        CGRect frame = _viewContainerInnerLeft.frame;
        frame.origin.x = _leftSidebarWidth - _viewContainerInnerLeft.frame.size.width;
        [_viewContainerInnerLeft setFrame:frame];
        
        [self.view addSubview:_viewContainerLeft];
        
        // Adds left view controller subview
        [_viewContainerInnerLeft addSubview:_leftViewController.view];
    }
}

- (void)attachRightSidebar {
    if (_viewContainerInnerRight == nil) {
        
        // Places an inner container (to the set width in the settings) inside the container view
        _viewContainerInnerRight = [[UIView alloc] initWithFrame:_viewContainerRight.frame];
        [_viewContainerRight addSubview:_viewContainerInnerRight];
        
        CGRect frame = _viewContainerInnerRight.frame;
        frame.origin.x = _viewContainerInnerRight.frame.size.width - _rightSidebarWidth;
        [_viewContainerInnerRight setFrame:frame];
        
        [self.view addSubview:_viewContainerRight];
        
        // Adds right view controller subview
        [_viewContainerInnerRight addSubview:_rightViewController.view];
    }
}

#pragma mark - Actions

- (void)onTapCloseLeftSidebar:(id)sender {
    [self showLeftSidebar:NO];
}

- (void)onTapCloseRightSidebar:(id)sender {
    [self showRightSidebar:NO];
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