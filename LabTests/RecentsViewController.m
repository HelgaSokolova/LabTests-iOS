//
//  FavoritesTableViewController.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/6/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "RecentsViewController.h"
#import "AppDelegate.h"
#import "DesignUtils.h"
#import "DetailViewController.h"
#import "MKStoreKit.h"
#import <StoreKit/StoreKit.h>


@interface RecentsViewController () <UISplitViewControllerDelegate>

@end

@implementation RecentsViewController
@synthesize selectedArticle_Item, recents;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.recents = [delegate.database getRecents];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearRecents)];
    self.navigationItem.rightBarButtonItem = clearButton;
    self.title = @"Recents";
    
    self.tableView.separatorColor = [DesignUtils blueColor];
    self.tableView.tableHeaderView.backgroundColor = [DesignUtils blueColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
}

-(void)clearRecents {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([delegate.database clearRecents]) {
        self.recents = [delegate.database getRecents];
        [self.tableView reloadData];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.recents = [delegate.database getRecents];
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"recCell"];
    }
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    Article_Item *newArt = [self.recents objectAtIndex:indexPath.row];
    cell.textLabel.text = newArt.name;
    cell.detailTextLabel.text = newArt.subtitle;
    cell.textLabel.textColor = [UIColor darkGrayColor];
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
    self.selectedArticle_Item = [self.recents objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"presentDetail" sender:self];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationController.navigationBar.translucent = NO;
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
    
    if (selectedArticle_Item.typeCode!=2) {
    } else {
        
    }
    
}

@end
