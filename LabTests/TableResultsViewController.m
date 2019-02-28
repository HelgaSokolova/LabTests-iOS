//
//  Copyright (c) 2015 Fish Hook LLC. All rights reserved.
//

#import "TableResultsViewController.h"
#import "Article_Item.h"

//----------------------------------------------------------------------------//

@interface TableResultsViewController ()
@end

//----------------------------------------------------------------------------//

static NSString * CellIdentifier = @"Results_Cell";

//----------------------------------------------------------------------------//

@implementation TableResultsViewController
@synthesize selectedArticle_Item;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredArticles.count;
}

#pragma mark - Table View Data Source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    Article_Item *newArt = [self.filteredArticles objectAtIndex:indexPath.row];
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

@end
