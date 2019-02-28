//
//  FavoritesTableViewController.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/6/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "AppDelegate.h"
#import "DesignUtils.h"
#import "DetailViewController.h"

@interface FavoritesTableViewController () <UISplitViewControllerDelegate>

@end

@implementation FavoritesTableViewController
@synthesize selectedArticle_Item, favorites;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.favorites = [delegate.database getFavorites];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.title = @"Favorites";
    
    self.tableView.separatorColor = [DesignUtils blueColor];
    self.tableView.tableHeaderView.backgroundColor = [DesignUtils blueColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(toggleEdit)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)toggleEdit{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing)
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.favorites = [delegate.database getFavorites];
    [self.tableView reloadData];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        Article_Item *item = [self.favorites objectAtIndex:indexPath.row];
        item.isFavorite = NO;
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate.database saveFavorites];

        [self.favorites removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
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
    return [self.favorites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"favCell"];
    }
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    Article_Item *newArt = [self.favorites objectAtIndex:indexPath.row];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selectedArticle_Item = [self.favorites objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"presentDetail" sender:self];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    });
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"detail: %@", self.selectedArticle_Item.name);
    
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
    
}

@end
