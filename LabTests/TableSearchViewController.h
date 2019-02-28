//
//  Copyright (c) 2015 Fish Hook LLC. All rights reserved.
//

@import UIKit;
#import "Article_Item.h"

@interface TableSearchViewController : UITableViewController

@property (retain, nonatomic) NSMutableArray *articles;
@property (retain, nonatomic) NSMutableArray *searchResults;
@property (retain, nonatomic) Article_Item *selectedArticle_Item;

@end
