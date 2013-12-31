//
//  ViewController.m
//  JHSidebarExampleOne
//
//  Created by Josh Holtz on 12/30/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "ViewController.h"

#import <JHSidebar/JHSidebarViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"399-list1"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickLeft:)]];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"399-list1"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickRight:)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickLeft:(id)sender {
    [self.sidebarViewController showLeftSidebar:YES];
}

- (void)onClickRight:(id)sender {
    [self.sidebarViewController showRightSidebar:YES];
}

@end
