//
//  Copyright (c) 2015 Fish Hook LLC. All rights reserved.
//

#import "TableSearchViewController.h"
#import "TableResultsViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "Article_Item.h"
#import "DesignUtils.h"
#import "MKStoreKit.h"
#import <StoreKit/StoreKit.h>

//----------------------------------------------------------------------------//

@interface TableSearchViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISplitViewControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) TableResultsViewController *resultsTableController;

@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

//----------------------------------------------------------------------------//

static NSString * CellIdentifier = @"search_cell";

//----------------------------------------------------------------------------//

@implementation TableSearchViewController
@synthesize articles, selectedArticle_Item;

- (BOOL)definesPresentationContext
{
    return YES;
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
    self.navigationController.navigationBar.translucent = YES;
}

-(void)willDismissSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.articles = [delegate.database allArticlesSorted];
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    self.title = @"Search";
    
    _resultsTableController = [[TableResultsViewController alloc] init];
    _resultsTableController.tableView.separatorColor = [DesignUtils blueColor];
    _resultsTableController.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    //self.searchController.searchBar.scopeButtonTitles = @[@"Titles and Subtitles", @"Everything"];

    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsTableController.tableView.delegate = self;
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    //self.searchController.searchBar.barTintColor = [DesignUtils blueColor];
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = YES; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others

    self.tableView.separatorColor = [DesignUtils blueColor];
    
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableHeaderView.backgroundColor = [DesignUtils blueColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
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
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryView = nil;
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    Article_Item *newArt = [self.articles objectAtIndex:indexPath.row];
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
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (self.searchController.isActive) {
        self.selectedArticle_Item = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        self.selectedArticle_Item = [self.articles objectAtIndex:indexPath.row];
    }
    
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

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    self.searchResults = [self.articles mutableCopy];

    self.searchResults = [[self.searchResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"SELF.name contains[cd] %@ OR SELF.subtitle contains[cd] %@", searchController.searchBar.text, searchController.searchBar.text, searchController.searchBar.text]] mutableCopy];
    
    TableResultsViewController *tableController = (TableResultsViewController *)self.searchController.searchResultsController;
    tableController.filteredArticles = self.searchResults;
    [tableController.tableView reloadData];
    
}

#pragma mark - UIStateRestoration

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
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
    
}

@end
