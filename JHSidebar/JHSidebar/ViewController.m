//
//  ViewController.m
//  JHSidebar
//
//  Created by Josh Holtz on 12/30/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "ViewController.h"

#import "JHSidebarViewController.h"

@interface ViewController ()<JHSidebarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.sidebarViewController setDelegate:self];
    [self.sidebarViewController enableTapGesture];
    [self.sidebarViewController enablePanGesture];
    [self.sidebarViewController setSlideMainViewWithLeftSidebar:YES];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"399-list1"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickLeft:)]];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"399-list1"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickRight:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JHSidebarDelegate

- (void)sidebar:(JHSidebarSide)side stateChanged:(JHSidebarState)state {
    NSLog(@"%@ is %@", (side == JHSidebarLeft ? @"Left Sidebar" : @"Right Sidebar"), (state == JHSidebarOpen ? @"Open" : @"Close"));
}

#pragma mark - Actions

- (void)onClickLeft:(id)sender {
    [self.sidebarViewController toggleLeftSidebar];
}

- (void)onClickRight:(id)sender {
    [self.sidebarViewController showRightSidebar:YES];
}

@end
