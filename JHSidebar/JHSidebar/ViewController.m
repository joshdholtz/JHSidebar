//
//  ViewController.m
//  JHSidebar
//
//  Created by Josh Holtz on 12/30/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "ViewController.h"

#import "JHSidebarViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"SidebarViewController - %@", self.sidebarViewController);
    [self.sidebarViewController enableTapGesture];
    [self.sidebarViewController setSlideMainViewWithLeftSidebar:YES];
    [self.sidebarViewController setSlideMainViewWithRightSidebar:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickOpenLeft:(id)sender {
    [self.sidebarViewController showLeftSidebar:YES];
}

- (IBAction)onClickOpenRight:(id)sender {
    [self.sidebarViewController showRightSidebar:YES];
}

@end
