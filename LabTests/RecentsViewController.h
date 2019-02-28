//
//  RecentsViewController.h
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/6/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

@import UIKit;
#import "Article_Item.h"

@interface RecentsViewController : UITableViewController

@property (retain, nonatomic) NSMutableArray *recents;
@property (retain, nonatomic) Article_Item *selectedArticle_Item;
@end

