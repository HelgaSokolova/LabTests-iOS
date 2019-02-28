//
//  FavoritesTableViewController.h
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/6/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

@import UIKit;
#import "Article_Item.h"

@interface FavoritesTableViewController : UITableViewController

@property (retain, nonatomic) NSMutableArray *favorites;
@property (retain, nonatomic) Article_Item *selectedArticle_Item;
@end
