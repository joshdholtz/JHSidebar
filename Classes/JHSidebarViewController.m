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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (void)enablePanGesture {
 
    // Adidng pan gesture to left sidebar
    if (_panGestureLeftSidebar == nil) {
        
        [_operationQueue addObject:^(JHSidebarViewController* sidebarViewController){
            sidebarViewController.panGestureLeftSidebar = [[UIPanGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onPanLeftSidebar:)];
            [sidebarViewController.viewContainerLeft addGestureRecognizer:sidebarViewController.panGestureLeftSidebar];
        }];
    }
    
    // Adidng pan gesture to right sidebar
    if (_panGestureRightSidebar == nil) {
        
        [_operationQueue addObject:^(JHSidebarViewController* sidebarViewController){
            sidebarViewController.panGestureRightSidebar = [[UIPanGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onPanRightSidebar:)];
            [sidebarViewController.viewContainerRight addGestureRecognizer:sidebarViewController.panGestureRightSidebar];
        }];
    }
    
    // Adidng pan gesture to main
    if (_panGestureMain == nil) {
        
        [_operationQueue addObject:^(JHSidebarViewController* sidebarViewController){
            [sidebarViewController.viewContainerMain setUserInteractionEnabled:YES];
            sidebarViewController.panGestureMain = [[UIPanGestureRecognizer alloc] initWithTarget:sidebarViewController action:@selector(onPanMain:)];
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
        
        [_viewContainerLeft setHidden:NO];
        [UIView animateWithDuration:_leftOpenAnimationLength animations:^{
            [_viewContainerLeft setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            
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
            [_viewContainerLeft setHidden:YES];
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
        frame.origin.x = 0;
        
        CGRect mainFrame = _viewContainerMain.frame;
        if (_slideMainViewWithRightSidebar == YES) {
            mainFrame.origin.x = -_rightSidebarWidth;
        }
        
        [_viewContainerRight setHidden:NO];
        [UIView animateWithDuration:_rightOpenAnimationLength animations:^{
            [_viewContainerRight setFrame:frame];
            [_viewContainerMain setFrame:mainFrame];
        } completion:^(BOOL finished) {
            
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
            [_viewContainerRight setHidden:YES];
        }];
    }
}

#pragma mark - Setting views

- (void)setMainViewController:(UIViewController *)mainViewController {
    if (_mainViewController != nil) return;
    
    _mainViewController = mainViewController;
    [self addChildViewController:self.mainViewController];
    
    _viewContainerMain = [[UIView alloc] initWithFrame:self.view.frame];
    [_viewContainerMain setBackgroundColor:[UIColor yellowColor]];
    [self.view insertSubview:_viewContainerMain atIndex:0];
    
    [_viewContainerMain addSubview:_mainViewController.view];

    // Adjust child view controller view to height of self.view
    CGRect frame = _mainViewController.view.frame;
    frame.size.height = CGRectGetHeight(_viewContainerMain.frame);
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
    NSInteger turningPoint = (CGRectGetWidth(self.view.frame) - (_leftSidebarWidth / 2.0f));
    return (turningPoint < CGRectGetMaxX(_viewContainerLeft.frame));
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
        
        CGRect frameContainer = _viewContainerRight.frame;
        frameContainer.origin.x = _rightSidebarWidth;
        [_viewContainerRight setFrame:frameContainer];
        
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

- (void)onPanLeftSidebar:(UIPanGestureRecognizer*)pgr {
    if (pgr.state == UIGestureRecognizerStateBegan) {

    } else if (pgr.state == UIGestureRecognizerStateChanged) {
        
        CGPoint center = pgr.view.center;
        CGPoint translation = [pgr translationInView:pgr.view.superview];
        center = CGPointMake(center.x + translation.x,
                             center.y);
        
        NSLog(@"Center - %f", center.x);
        NSLog(@"Right edge - %f", center.x + (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f));
        BOOL isAtMax = (center.x + (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f)) < (CGRectGetWidth(self.view.frame) - _leftSidebarWidth);
        if (isAtMax == YES) {
            center.x = (CGRectGetWidth(self.view.frame) - _leftSidebarWidth) - (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f);
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
        
        NSLog(@"Center - %f", center.x);
        NSLog(@"Left edge - %f", center.x - (CGRectGetWidth(_viewContainerRight.frame) / 2.0f));
        BOOL isAtMax = (center.x - (CGRectGetWidth(_viewContainerRight.frame) / 2.0f)) > _rightSidebarWidth;
        if (isAtMax == YES) {
            center.x = _rightSidebarWidth + (CGRectGetWidth(_viewContainerRight.frame) / 2.0f);
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
        
        if ((CGRectGetWidth(self.view.frame) / 2.0f) > _panGestureStartPoint.x) {
            if (_leftViewController != nil) {
                [_viewContainerLeft setHidden:NO];
                
                CGPoint center = _viewContainerLeft.center;
                CGPoint translation = [pgr translationInView:_viewContainerLeft];
                center = CGPointMake(center.x + translation.x,
                                     center.y);
                
                BOOL isAtMax = (center.x + (CGRectGetWidth(_viewContainerLeft.frame) / 2.0f)) > CGRectGetWidth(self.view.frame);
                if (isAtMax == YES) {
                    NSLog(@"IS AT MAX");
                    center.x = CGRectGetWidth(self.view.frame) / 2.0f;
                }
                _viewContainerLeft.center = center;
                
                // Translations main
                if (_slideMainViewWithLeftSidebar == YES) {
                    CGPoint center2 = pgr.view.center;
                    CGPoint translation2 = [pgr translationInView:pgr.view.superview];
                    center2 = CGPointMake(center2.x + translation2.x,
                                         center2.y);
                    if (isAtMax == YES) {
                        center2.x = _leftSidebarWidth + CGRectGetWidth(self.view.frame) / 2.0f;
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
                    NSLog(@"IS AT MAX");
                    center.x = CGRectGetWidth(self.view.frame) / 2.0f;
                }
                _viewContainerRight.center = center;
                
                // Translations main
                if (_slideMainViewWithRightSidebar == YES) {
                    CGPoint center2 = pgr.view.center;
                    CGPoint translation2 = [pgr translationInView:pgr.view.superview];
                    center2 = CGPointMake(center2.x + translation2.x,
                                         center2.y);
                    if (isAtMax == YES) {
                        center2.x = (CGRectGetWidth(self.view.frame)- _rightSidebarWidth) - (CGRectGetWidth(_viewContainerMain.frame) / 2.0f);
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