//
//  DetailViewController.h
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/1/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article_Item.h"
#import "CNPPopupController.h"

@interface DetailViewController : UITableViewController <UISplitViewControllerDelegate, UIAlertViewDelegate, CNPPopupControllerDelegate> {
    
    NSMutableDictionary *data;
    NSArray *dotImages1;
}

@property (nonatomic, readwrite) Article_Item *dataItem;
@property (nonatomic, strong) CNPPopupController *popupController;

@end
