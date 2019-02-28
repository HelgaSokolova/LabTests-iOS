//
//  SplitViewController.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 3/30/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "SplitViewController.h"
#import "DetailViewController.h"

@interface SplitViewController ()

@end

@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //Setting up the splitviewcontrollers
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = self.displayModeButtonItem;
    self.navigationController.topViewController.navigationItem.leftItemsSupplementBackButton = YES;
    self.preferredDisplayMode =  UISplitViewControllerDisplayModeAllVisible;
    self.preferredPrimaryColumnWidthFraction = 0.5;
    self.maximumPrimaryColumnWidth = 320;
    self.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]]
        && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]]
        && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] dataItem] == nil)) {
        // If the detail controller doesn't have an item, display the primary view controller instead
        return YES;
    }
    
    return NO;
    
}

- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController
separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController{
    
    if ([primaryViewController isKindOfClass:[UINavigationController class]]) {
        for (UIViewController *controller in [(UINavigationController *)primaryViewController viewControllers]) {
            if ([controller isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)controller visibleViewController] isKindOfClass:[DetailViewController class]]) {
                return controller;
            }
        }
    }
    
    // No detail view present
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *detailView = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    
    // Ensure back button is enabled
    UIViewController *controller = [detailView visibleViewController];
    controller.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    controller.navigationItem.leftItemsSupplementBackButton = YES;
    
    return detailView;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
