//
//  Copyright (c) 2015 Fish Hook LLC. All rights reserved.
//

@import UIKit;
#import "Article_Item.h"

@interface TableResultsViewController : UITableViewController

@property (nonatomic, strong) NSArray *filteredArticles;
@property (retain, nonatomic) Article_Item *selectedArticle_Item;

@end
