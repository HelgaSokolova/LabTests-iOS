//
//  SecondTableViewController.h
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/6/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article_Item.h"

@interface SecondTableViewController : UITableViewController

@property (retain, nonatomic) NSMutableArray *articles;
@property (retain, nonatomic) Article_Item *selectedArticle_Item;
@property (nonatomic) NSInteger categoryId;

@end
