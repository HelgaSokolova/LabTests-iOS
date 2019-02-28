//
//  SecondTableViewController.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/6/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "SecondTableViewController.h"
#import "AppDelegate.h"
#import "Article_Item.h"
#import "DetailViewController.h"
#import "DesignUtils.h"
#import "MKStoreKit.h"
#import <StoreKit/StoreKit.h>

@interface SecondTableViewController ()

@end

@implementation SecondTableViewController
@synthesize articles, categoryId, selectedArticle_Item;

#pragma mark - UISplitViewControllerDelegate
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.articles = [delegate.database getItemsOfCategory:self.categoryId];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [DesignUtils blueColor];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.articles = [delegate.database getItemsOfCategory:self.categoryId];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleSecondTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    Article_Item *newArt = [self.articles objectAtIndex:indexPath.row];
    cell.textLabel.text = newArt.name;
    cell.detailTextLabel.text = newArt.subtitle;
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ProVersion"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        if([newArt.address integerValue] > 119){
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"54-lock.png"]];
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedArticle_Item = [self.articles objectAtIndex:indexPath.row];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ProVersion"]) {
        [self performSegueWithIdentifier:@"presentDetail" sender:self];
        
    } else {
        if ([self.selectedArticle_Item.address integerValue] > 119) {
            SKProduct *product = [[[MKStoreKit sharedKit] availableProducts]objectAtIndex:0];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:product.priceLocale];
            
            NSString *formattedPrice = [NSString stringWithFormat:@"Pro Version - %@", [numberFormatter stringFromNumber:product.price]];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:formattedPrice message:@"This article is among the 55 articles, which is only available in the Pro Version. Tap 'Buy' to unlock these articles" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy", nil];
            [alert show];
            
            
        } else {
            [self performSegueWithIdentifier:@"presentDetail" sender:self];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
    } else if (buttonIndex == 1) {
        
        [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:@"ProVersion"];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                          object:nil
                                                           queue:[[NSOperationQueue alloc] init]
                                                      usingBlock:^(NSNotification *note) {
                                                          
                                                          sleep(1);
                                                          [self.tableView reloadData];
                                                          
                                                      }];

    }
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"detail: %@", self.selectedArticle_Item.name);
    
    UINavigationController *nav = segue.destinationViewController;
    nav.topViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    nav.topViewController.navigationItem.leftItemsSupplementBackButton = YES;
    
    DetailViewController *detail = (DetailViewController *)nav.topViewController;
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 187, 40)];
    tlabel.text = self.selectedArticle_Item.name;
    tlabel.textColor = [UIColor whiteColor];
    tlabel.textAlignment = NSTextAlignmentCenter;
    tlabel.backgroundColor = [UIColor clearColor];
    tlabel.adjustsFontSizeToFitWidth = YES;
    detail.navigationItem.titleView = tlabel;
    
    detail.dataItem = self.selectedArticle_Item;
    [detail.tableView reloadData];
}

@end
