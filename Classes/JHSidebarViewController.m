//
//  JHSidebarViewController.m
//  JHSidebar
//
//  Created by Josh Holtz on 12/30/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#define kSidebarMainIdentifier         @"JHMainView"
#define kSidebarLeftIdentifier         @"JHLeftSidebar"
#define kSidebarRightIdentifier        @"JHRightSidebar"

#import "JHSidebarViewController.h"

@interface JHSidebarViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *viewContainerMain;
@property (nonatomic, strong) UIView *viewContainerLeft;
@property (nonatomic, strong) UIView *viewContainerRight;

@property (nonatomic, strong) UIView *viewContainerInnerLeft;
@property (nonatomic, strong) UIView *viewContainerInnerRight;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureLeftSidebar;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRightSidebar;

@property (nonatomic, assign) CGPoint panGestureStartPoint;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureMain;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureLeftSidebar;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRightSidebar;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _operationQueue = [@[] mutableCopy];
    
    _slideMainViewWithLeftSidebar = NO;
    _slideMainViewWithRightSidebar = NO;
    
    _leftOpenAnimationLength = 0.35;
    _leftCloseAnimationLength = 0.35f;
    _rightOpenAnimationLength = 0.35f;
    _rightCloseAnimationLength = 0.35f;
    
    _leftSidebarWidth = 270.0f;
    _rightSidebarWidth = 270.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Creating left container view (same size as self.view)
    if (_viewContainerLeft == nil) {
        CGRect windowRect = [[UIScreen mainScreen] bounds];
        CGRect frame = windowRect;
        
        _viewContainerLeft = [[UIView alloc] initWithFrame:CGRectMake(-CGRectGetWidth(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [_viewContainerLeft setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    
    // Creating right container view (same size as self.view)
    if (_viewContainerRight == nil) {
        CGRect windowRect = [[UIScreen mainScreen] bounds];
        CGRect frame = windowRect;
        
        _viewContainerRight = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [_viewContainerRight setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    
    for (OperationBlock block in _operationQueue) {
        block(self);
    }
    [_operationQueue removeAllObjects];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *viewController = self.mainViewController;
    if ([viewController respondsToSelector:@selector(preferredStatusBarStyle)]) {
        return [viewController preferredStatusBarStyle];
    }
    
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    UIViewController *viewController = self.mainViewController;
    if ([viewController respondsToSelector:@selector(prefersStatusBarHidden)]) {
        return [viewController prefersStatusBarHidden];
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    
    [super loadView];
    
    if (_mainViewController == nil){
        UIViewController *mainVC = [self instantiateMainViewController];
        if (mainVC) {
            [self setMainViewController:mainVC];
        }
        UIViewController *leftVC = [self instantiateLeftViewController];
        if (leftVC) {
            [self setLeftViewController:leftVC];
        }
        UIViewController *rightVC = [self instantiateRightViewController];
        if (rightVC) {
            [self setRightViewController:rightVC];
        }
    }
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isEqual:_tapGestureLeftSidebar]) {
        // point must be right of the left sidebar (in the open space)
        CGPoint point = [touch locationInView:self.view];
        return point.x > _leftSidebarWidth;
    }
    else if ([gestureRecognizer isEqual:_tapGestureRightSidebar]) {
        // point must be left of the right sidebar (in the open space)
        CGPoint point = [touch locationInView:self.view];
        CGFloat width = CGRectGetWidth(self.view.frame) - _rightSidebarWidth;
        return point.x < width;
    }

    return YES;
}

#pragma mark - Public

- (void)enableTapGesture {
    
    // Adding tap gesture to close left sidebar
    if (_tapGestureLeftSidebar == nil) {
        [_operationQueue addObject:^(JHSidebarViewController *sidebarViewController){
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onTapCloseLeftSidebar:)];
            tgr.delegate = sidebarViewController;
            [sidebarViewController.viewContainerLeft addGestureRecognizer:tgr];
            sidebarViewController.tapGestureLeftSidebar = tgr;
        }];
    }
    
    // Adding tap gesture to close right sidebar
    if (_tapGestureRightSidebar == nil) {
        [_operationQueue addObject:^(JHSidebarViewController *sidebarViewController){
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onTapCloseRightSidebar:)];
            tgr.delegate = sidebarViewController;
            [sidebarViewController.viewContainerRight addGestureRecognizer:tgr];
            sidebarViewController.tapGestureRightSidebar = tgr;
        }];
    }
    
    if (_viewContainerLeft != nil && _viewContainerRight != nil) {
        for (OperationBlock block in _operationQueue) {
            block(self);
        }
        [_operationQueue removeAllObjects];
    }
}

- (void)enablePanGesture {
 
    // Adding pan gesture to left sidebar
    if (_panGestureLeftSidebar == nil) {
        
        [_operationQueue addObject:^(JHSidebarViewController *sidebarViewController){
            sidebarViewController.panGestureLeftSidebar = [[UIPanGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onPanLeftSidebar:)];
            [sidebarViewController.panGestureLeftSidebar setDelegate:sidebarViewController];
            [sidebarViewController.viewContainerLeft addGestureRecognizer:sidebarViewController.panGestureLeftSidebar];
        }];
    }
    
    // Adidng pan gesture to right sidebar
    if (_panGestureRightSidebar == nil) {
        
        [_operationQueue addObject:^(JHSidebarViewController *sidebarViewController){
            sidebarViewController.panGestureRightSidebar = [[UIPanGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onPanRightSidebar:)];
            [sidebarViewController.panGestureRightSidebar setDelegate:sidebarViewController];
            [sidebarViewController.viewContainerRight addGestureRecognizer:sidebarViewController.panGestureRightSidebar];
        }];
    }
    
    // Adidng pan gesture to main
    if (_panGestureMain == nil) {
        
        [_operationQueue addObject:^(JHSidebarViewController *sidebarViewController){
            [sidebarViewController.viewContainerMain setUserInteractionEnabled:YES];
            sidebarViewController.panGestureMain = [[UIPanGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onPanMain:)];
            [sidebarViewController.panGestureMain setDelegate:sidebarViewController];
            [sidebarViewController.viewContainerMain addGestureRecognizer:sidebarViewController.panGestureMain];
        }];
    }
    
    if (_viewContainerLeft != nil && _viewContainerRight != nil) {
        for (OperationBlock block in _operationQueue) {
            block(self);
        }
        [_operationQueue removeAllObjects];
    }

}

- (void)toggleLeftSidebar {
    [self showLeftSidebar:![self isLeftMoreOpenThanClosed]];
}

- (void)toggleRightSidebar {
    [self showRightSidebar:![self isRightMoreOpenThanClosed]];
}

- (void)showLeftSidebar:(BOOL)show {
    if (_leftViewController == nil) return;
    
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
        
        [self hideLeftSidebar:NO];
        [UIView animateWithDuration:_leftOpenAnimationLength animations:^{
            [_viewContainerLeft setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            if ([_delegate respondsToSelector:@selector(sidebar:stateChanged:)]) {
                [_delegate sidebar:JHSidebarLeft stateChanged:JHSidebarOpen];
            }
        }];
    } else {
        
        CGRect frame = _viewContainerLeft.frame;
        frame.origin.x = -_leftSidebarWidth;
        
        CGRect mainFrame = _viewContainerMain.frame;
        if (_slideMainViewWithLeftSidebar == YES) {
            mainFrame.origin.x = 0.0f;
        }
        
        [UIView animateWithDuration:_leftCloseAnimationLength animations:^{
            [_viewContainerLeft setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            [self hideLeftSidebar:YES];
            if ([_delegate respondsToSelector:@selector(sidebar:stateChanged:)]) {
                [_delegate sidebar:JHSidebarLeft stateChanged:JHSidebarClosed];
            }
        }];
    }
}

- (void)showRightSidebar:(BOOL)show {
    if (_rightViewController == nil) return;
    
    // Initializes right sidebar view if not already attached
    [self attachRightSidebar];
    
    // Shows and hides right sidebar view
    if (show == YES) {
        
        CGRect frame = _viewContainerRight.frame;
        frame.origin.x = 0.0f;
        
        CGRect mainFrame = _viewContainerMain.frame;
        if (_slideMainViewWithRightSidebar == YES) {
            mainFrame.origin.x = -_rightSidebarWidth;
        }
        
        [self hideRightSidebar:NO];;
        [UIView animateWithDuration:_rightOpenAnimationLength animations:^{
            [_viewContainerRight setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            if ([_delegate respondsToSelector:@selector(sidebar:stateChanged:)]) {
                [_delegate sidebar:JHSidebarRight stateChanged:JHSidebarOpen];
            }
        }];
    } else {

        CGRect frame = _viewContainerRight.frame;
        frame.origin.x = _rightSidebarWidth;
        
        CGRect mainFrame = _viewContainerMain.frame;
        if (_slideMainViewWithRightSidebar == YES) {
            mainFrame.origin.x = 0.0f;
        }
        
        [UIView animateWithDuration:_rightCloseAnimationLength animations:^{
            [_viewContainerRight setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            [self hideRightSidebar:YES];
            if ([_delegate respondsToSelector:@selector(sidebar:stateChanged:)]) {
                [_delegate sidebar:JHSidebarRight stateChanged:JHSidebarClosed];
            }
        }];
    }
}

- (UIViewController *)instantiateMainViewController {
    return [self.storyboard instantiateViewControllerWithIdentifier:kSidebarMainIdentifier];
}

- (UIViewController *)instantiateLeftViewController {
    return [self.storyboard instantiateViewControllerWithIdentifier:kSidebarLeftIdentifier];
}

- (UIViewController *)instantiateRightViewController {
    return [self.storyboard instantiateViewControllerWithIdentifier:kSidebarRightIdentifier];
}

#pragma mark - Setting views

- (void)setMainViewController:(UIViewController *)mainViewController {
    if (_mainViewController != nil) return;
    
    _mainViewController = mainViewController;
    [self addChildViewController:self.mainViewController];
    
    CGRect windowRect = [[UIScreen mainScreen] bounds];
    _viewContainerMain = [[UIView alloc] initWithFrame:windowRect];
    [_viewContainerMain setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view insertSubview:_viewContainerMain atIndex:0];
    
    [_viewContainerMain addSubview:_mainViewController.view];

    // Adjust child view controller view to height of self.view
    CGRect frame = _mainViewController.view.frame;
    frame.size.height = CGRectGetHeight(_viewContainerMain.frame);
    [_mainViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_mainViewController.view setFrame:frame];
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (_leftViewController != nil) return;
    
    _leftViewController = leftViewController;
    [self addChildViewController:self.leftViewController];
    
    // Adjust child view controller view to height of self.view
    CGRect frame = _leftViewController.view.frame;
    frame.size.height = CGRectGetHeight(_viewContainerMain.frame);
    [_leftViewController.view setFrame:frame];
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    if (_rightViewController != nil) return;
    
    _rightViewController = rightViewController;
    [self addChildViewController:self.rightViewController];
    
    // Adjust child view controller view to height of self.view
    CGRect frame = _rightViewController.view.frame;
    frame.size.height = CGRectGetHeight(_viewContainerMain.frame);
    [_rightViewController.view setFrame:frame];
}

#pragma mark - Private

- (BOOL)isLeftMoreOpenThanClosed {
    if (_viewContainerInnerLeft == nil) return NO;
    
    NSInteger turningPoint = (_leftSidebarWidth / 2.0f);
    return (turningPoint > abs(CGRectGetMinX(_viewContainerLeft.frame)));
}

- (BOOL)isRightMoreOpenThanClosed {
    NSInteger turningPoint = (_rightSidebarWidth / 2.0f);
    return (turningPoint > CGRectGetMinX(_viewContainerRight.frame));
}

- (void)attachLeftSidebar {
    if (_viewContainerInnerLeft == nil) {
        CGRect frameContainer = _viewContainerLeft.frame;
        frameContainer.origin.x = -_leftSidebarWidth;
        [_viewContainerLeft setFrame:frameContainer];
        
        // Places an inner container (to the set width in the settings) inside the container view
        _viewContainerInnerLeft = [[UIView alloc] initWithFrame:_viewContainerLeft.frame];
        [_viewContainerInnerLeft setUserInteractionEnabled:YES];
        [_viewContainerInnerLeft setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [_viewContainerLeft addSubview:_viewContainerInnerLeft];
        
        if (_leftSidebarTapGestureEnabled) {
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapNone:)];
            [tgr setDelegate:self];
            [_viewContainerInnerLeft addGestureRecognizer:tgr];
        }
        
        CGRect frame = _viewContainerInnerLeft.frame;
        frame.origin.x = _leftSidebarWidth - _viewContainerInnerLeft.frame.size.width;
        [_viewContainerInnerLeft setFrame:frame];
        
        [self.view addSubview:_viewContainerLeft];
        
        // Adds left view controller subview
        [_viewContainerInnerLeft addSubview:_leftViewController.view];
        
        // Shrinking size of sidebar to set size
        CGRect frameSidebar = _leftViewController.view.frame;
        CGFloat maxX = CGRectGetMaxX(frameSidebar);
        frameSidebar.origin.y = 0;
        frameSidebar.size.width = _leftSidebarWidth;
        frameSidebar.origin.x = maxX - _leftSidebarWidth;
        [_leftViewController.view setFrame:frameSidebar];
    }
}

- (void)attachRightSidebar {
    if (_viewContainerInnerRight == nil) {
        CGRect frameContainer = _viewContainerRight.frame;
        frameContainer.origin.x = _rightSidebarWidth;
        [_viewContainerRight setFrame:frameContainer];
        
        // Places an inner container (to the set width in the settings) inside the container view
        _viewContainerInnerRight = [[UIView alloc] initWithFrame:_viewContainerRight.frame];
        [_viewContainerInnerRight setUserInteractionEnabled:YES];
        [_viewContainerInnerRight setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [_viewContainerRight addSubview:_viewContainerInnerRight];

        if (_rightSidebarTapGestureEnabled) {
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapNone:)];
            [tgr setDelegate:self];
            [_viewContainerInnerRight addGestureRecognizer:tgr];
        }
        
        CGRect frame = _viewContainerInnerRight.frame;
        frame.origin.x = CGRectGetWidth(_viewContainerInnerRight.frame) - _rightSidebarWidth;
        [_viewContainerInnerRight setFrame:frame];
        
        [self.view addSubview:_viewContainerRight];
        
        // Adds right view controller subview
        [_viewContainerInnerRight addSubview:_rightViewController.view];
        
        // Shrinking size of sidebar to set size
        CGRect frameSidebar = _rightViewController.view.frame;
        frameSidebar.origin.y = 0;
        frameSidebar.size.width = _rightSidebarWidth;
        frameSidebar.origin.x = 0;
        [_rightViewController.view setFrame:frameSidebar];
    }
}

- (void)hideLeftSidebar:(BOOL)hide {
    if (hide == YES) {
        [_viewContainerLeft setHidden:YES];
    } else {
        [_viewContainerLeft setHidden:NO];
    }
}

- (void)hideRightSidebar:(BOOL)hide {
    if (hide == YES) {
        [_viewContainerRight setHidden:YES];
    } else {

        [_viewContainerRight setHidden:NO];
    }
    
}

- (CGRect)frameForOrientation:(UIView*)view {
    CGPoint point = view.frame.origin;
    CGFloat width = CGRectGetWidth(view.frame);
    CGFloat height = CGRectGetHeight(view.frame);
    
    if (!UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGRectMake(point.x, point.y, width, height);
    }
    else {
        return CGRectMake(point.y, point.x, height, width);
    }
}

#pragma mark - Actions

- (void)onTapCloseLeftSidebar:(id)sender {
    [self showLeftSidebar:NO];
}

- (void)onTapCloseRightSidebar:(id)sender {
    [self showRightSidebar:NO];
}

- (void)onTapNone:(id)sender {
    NSLog(@"None");
}

- (void)onPanLeftSidebar:(UIPanGestureRecognizer*)pgr {
    if (pgr.state == UIGestureRecognizerStateBegan) {

    } else if (pgr.state == UIGestureRecognizerStateChanged) {
        
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view.superview];
        center = CGPointMake(center.x + translation.x,
                             center.y);
        
        BOOL isAtMax = (center.x + (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f)) < (CGRectGetWidth(self.view.frame) - _leftSidebarWidth);
        if (isAtMax == YES) {
            center.x = (CGRectGetWidth(self.view.frame) - _leftSidebarWidth) - (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f);
        }
        BOOL isAtMin = (center.x + (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f)) > CGRectGetWidth(self.view.frame);
        if (isAtMin == YES) {
            center.x = (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f);
        }
        pgr.view.center = center;
        
        if (_slideMainViewWithLeftSidebar == YES) {
            CGPoint center2 = _viewContainerMain.center;
            CGPoint translation2 = [pgr translationInView:_viewContainerMain.superview];
            center2 = CGPointMake(center2.x + translation2.x,
                                 center2.y);
            if (isAtMax == YES) {
                center2.x = CGRectGetWidth(_viewContainerMain.frame) / 2.0f;
            }
            if (isAtMin == YES) {
                center2.x = (CGRectGetWidth(_viewContainerMain.frame) / 2.0f) + _leftSidebarWidth;
            }
            
            _viewContainerMain.center = center2;
        }
        
        [pgr setTranslation:CGPointZero inView:pgr.view.superview];

    } else if (pgr.state == UIGestureRecognizerStateEnded) {
        [self showLeftSidebar:[self isLeftMoreOpenThanClosed]];
    }
}

- (void)onPanRightSidebar:(UIPanGestureRecognizer*)pgr {
    if (pgr.state == UIGestureRecognizerStateBegan) {
        
    } else if (pgr.state == UIGestureRecognizerStateChanged) {
        
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view.superview];
        center = CGPointMake(center.x + translation.x,
                             center.y);
        
        BOOL isAtMax = (center.x - (CGRectGetWidth(_viewContainerRight.frame) / 2.0f)) > _rightSidebarWidth;
        if (isAtMax == YES) {
            center.x = _rightSidebarWidth + (CGRectGetWidth(_viewContainerRight.frame) / 2.0f);
        }
        BOOL isAtMin = (center.x - (CGRectGetWidth(_viewContainerRight.frame) / 2.0f)) < 0.0f;
        if (isAtMin == YES) {
            center.x = (CGRectGetWidth(_viewContainerRight.frame) / 2.0f);
        }
        pgr.view.center = center;
        
        if (_slideMainViewWithRightSidebar == YES) {
            CGPoint center2 = _viewContainerMain.center;
            CGPoint translation2 = [pgr translationInView:_viewContainerMain.superview];
            center2 = CGPointMake(center2.x + translation2.x,
                                 center2.y);
            if (isAtMax == YES) {
                center2.x = CGRectGetWidth(_viewContainerMain.frame) / 2.0f;
            }
            if (isAtMin == YES) {
                center2.x = (CGRectGetWidth(_viewContainerMain.frame) - _rightSidebarWidth) - (CGRectGetWidth(_viewContainerMain.frame) / 2.0f);
            }
            _viewContainerMain.center = center2;
        }
        
        [pgr setTranslation:CGPointZero inView:pgr.view.superview];
        
    } else if (pgr.state == UIGestureRecognizerStateEnded) {
        [self showRightSidebar:[self isRightMoreOpenThanClosed]];
    }
}

- (void)onPanMain:(UIPanGestureRecognizer*)pgr {
    if (pgr.state == UIGestureRecognizerStateBegan) {
        [self attachLeftSidebar];
        [self attachRightSidebar];
        
        _panGestureStartPoint = [pgr locationInView:_viewContainerMain];
    } else if (pgr.state == UIGestureRecognizerStateChanged) {
        
        if ((CGRectGetWidth(_viewContainerMain.frame) / 2.0f) > _panGestureStartPoint.x) {
            if (_leftViewController != nil) {
                [_viewContainerLeft setHidden:NO];
                
                CGPoint center = _viewContainerLeft.center;
                CGPoint translation = [pgr translationInView:_viewContainerLeft];
                center = CGPointMake(center.x + translation.x,
                                     center.y);
                
                BOOL isAtMax = (center.x + (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f)) > CGRectGetWidth(_viewContainerLeft.frame);
                if (isAtMax == YES) {
                    center.x = CGRectGetWidth(self.view.frame) / 2.0f;
                }
                BOOL isAtMin = (center.x + (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f)) < (CGRectGetWidth(self.view.frame) - _leftSidebarWidth);
                if (isAtMin == YES) {
                    center.x = (CGRectGetWidth(self.view.frame) - _leftSidebarWidth) - (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f);
                }
                _viewContainerLeft.center = center;
                
                // Translations main
                if (_slideMainViewWithLeftSidebar == YES) {
                    CGPoint center2 = pgr.view.center;
                    CGPoint translation2 = [pgr translationInView:pgr.view.superview];
                    center2 = CGPointMake(center2.x + translation2.x,
                                         center2.y);
                    if (isAtMax == YES) {
                        center2.x = _leftSidebarWidth + (CGRectGetWidth(_viewContainerMain.frame) / 2.0f);
                    }
                    if (isAtMin == YES) {
                        center2.x = CGRectGetWidth([self frameForOrientation:self.view]) / 2.0f;
                    }
                    pgr.view.center = center2;
                }
                
                [pgr setTranslation:CGPointZero inView:_viewContainerLeft];
            }
        } else {
            if (_rightViewController != nil) {
                [_viewContainerRight setHidden:NO];
                
                CGPoint center = _viewContainerRight.center;
                CGPoint translation = [pgr translationInView:_viewContainerRight];
                center = CGPointMake(center.x + translation.x,
                                     center.y);
                BOOL isAtMax = (center.x - (CGRectGetWidth(_viewContainerRight.frame) / 2.0f)) < 0;
                if (isAtMax == YES) {
                    center.x = CGRectGetWidth(_viewContainerMain.frame) / 2.0f;
                }
                BOOL isAtMin = (center.x - (CGRectGetWidth(_viewContainerRight.frame) / 2.0f)) > _rightSidebarWidth;
                if (isAtMin == YES) {
                    center.x = (CGRectGetWidth(_viewContainerRight.frame) / 2.0f) + _rightSidebarWidth;
                }
                _viewContainerRight.center = center;
                
                // Translations main
                if (_slideMainViewWithRightSidebar == YES) {
                    CGPoint center2 = pgr.view.center;
                    CGPoint translation2 = [pgr translationInView:pgr.view.superview];
                    center2 = CGPointMake(center2.x + translation2.x,
                                         center2.y);
                    if (isAtMax == YES) {
                        center2.x = (CGRectGetWidth(_viewContainerMain.frame)- _rightSidebarWidth) - (CGRectGetWidth(_viewContainerMain.frame) / 2.0f);
                    }
                    if (isAtMin == YES) {
                        center2.x = CGRectGetWidth(_viewContainerMain.frame) / 2.0f;
                    }
                    pgr.view.center = center2;
                }
                
                [pgr setTranslation:CGPointZero inView:_viewContainerRight];
            }
        }
        
    } else if (pgr.state == UIGestureRecognizerStateEnded) {
        if ((CGRectGetWidth(self.view.frame) / 2.0f) > _panGestureStartPoint.x) {
            [self showLeftSidebar:[self isLeftMoreOpenThanClosed]];
        } else {
            [self showRightSidebar:[self isRightMoreOpenThanClosed]];
        }
    }
}

@end

@implementation UIViewController(JHSidebarViewController)

- (JHSidebarViewController*)sidebarViewController {
    UIViewController *parent = self;
    Class revealClass = [JHSidebarViewController class];
    
    while ( nil != (parent = [parent parentViewController]) && ![parent isKindOfClass:revealClass] )
    {
    }
    
    return (id)parent;
}

@end
