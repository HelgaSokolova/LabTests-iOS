//
//  detailTableCell.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/10/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "detailTableCell.h"

@implementation detailTableCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
