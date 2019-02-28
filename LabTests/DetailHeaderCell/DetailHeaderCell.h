//
//  DetailHeaderCell.h
//  LabTests
//
//  Created by Mihai on 15/08/2017.
//  Copyright © 2017 AppMent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PressButtonAction)(void);

@interface DetailHeaderCell : UITableViewCell

- (void)configureWithDetailString:(NSString *)detailString image:(UIImage *)image pressButtonAction:(PressButtonAction)pressButtonAction;

@end
