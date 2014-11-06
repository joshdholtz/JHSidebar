//
//  RightViewController.m
//  JHSidebar
//
//  Created by Brennan Stehling on 11/6/14.
//  Copyright (c) 2014 Josh Holtz. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RightViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
}

#pragma mark - UITableViewDataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"Menu Item %lu", (unsigned long)indexPath.row + 1];
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Menu Item %lu", (unsigned long)indexPath.row + 1);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    });
}

@end
