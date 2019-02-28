//
//  FirstTableViewController.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/6/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "FirstTableViewController.h"
#import "SecondTableViewController.h"
#import "AppDelegate.h"
#import "DesignUtils.h"
#import "MKStoreKit.h"

//Items
#import "Category_Item.h"
#import <iRate/iRate.h>

@interface FirstTableViewController () {
    NSInteger categoryId;
    NSString *categoryName;
}

@property (nonatomic, assign) BOOL didDisplayAlert;

@end

@implementation FirstTableViewController
@synthesize categories;

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
    
    [self promptUserForUpgradeIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.categories = [delegate.database allCategories];
    
    self.title = @"Categories";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.splitViewController.delegate = self;
    self.tableView.separatorColor = [DesignUtils blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)promptUserForUpgradeIfNeeded {
    if (!self.didDisplayAlert) {
        if ([iRate sharedInstance].usesCount % 5 == 0 &&
            [iRate sharedInstance].usesCount != 0 &&
            ![[MKStoreKit sharedKit] isProductPurchased:@"ProVersion"]) {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Upgrade now" message:@"Unlock all Lab Tests and upgrade to the full version" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Upgrade" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"ProVersion"];
                
                [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                                  object:nil
                                                                   queue:[[NSOperationQueue alloc] init]
                                                              usingBlock:^(NSNotification *note) {
                                                                  
                                                                  sleep(1);
                                                                  [self.tableView reloadData];
                                                                  
                                                              }];
            }]];
            
            self.didDisplayAlert = YES;
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    Category_Item *newCat = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = newCat.name;
    cell.imageView.image = [UIImage imageNamed:newCat.logoFile];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Category_Item *newCat = [self.categories objectAtIndex:indexPath.row];
    categoryId = newCat.autoId;
    categoryName = newCat.name;
    [self performSegueWithIdentifier:@"showArticles" sender:self];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SecondTableViewController *second = [segue destinationViewController];
    [second setCategoryId:categoryId];
    second.navigationItem.title = categoryName;

}

@end
