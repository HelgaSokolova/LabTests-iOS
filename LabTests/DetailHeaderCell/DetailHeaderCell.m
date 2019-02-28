//
//  DetailHeaderCell.m
//  LabTests
//
//  Created by Mihai on 15/08/2017.
//  Copyright © 2017 AppMent. All rights reserved.
//

#import "DetailHeaderCell.h"



@interface DetailHeaderCell ()

@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondaryDetailLabel;
@property (nonatomic, weak) IBOutlet UIButton *detailButton;
@property (nonatomic, copy) PressButtonAction pressButtonAction;

@end

@implementation DetailHeaderCell

- (void)configureWithDetailString:(NSString *)detailString image:(UIImage *)image pressButtonAction:(PressButtonAction)pressButtonAction {
    self.pressButtonAction = pressButtonAction;
    self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.detailLabel.numberOfLines = 0;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(self.detailButton.frame) - 3 * 15.0f; // we need to compute this size manually because it is wrong at runtime. 15 represents the padding (3 times - 1 for label leading; 1 for label trailing; 1 for button trailing)
   
    NSInteger numberOfCharactersInFirstLabel = 0;
    
    for (NSInteger i = detailString.length; i >= 0; i--) {
        NSString *substring = [detailString substringToIndex:i];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:substring
                                                                             attributes:@{ NSFontAttributeName : self.detailLabel.font, NSParagraphStyleAttributeName : paragraphStyle}];
        
        CGSize size = CGSizeMake(width, CGFLOAT_MAX);
        
        CGRect textFrame = [attributedText.string boundingRectWithSize:size
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                         attributes:@{ NSFontAttributeName : self.detailLabel.font, NSParagraphStyleAttributeName : paragraphStyle}
                                                        context:nil];
        
        if (CGRectGetHeight(textFrame) <= 75.0f) {
            numberOfCharactersInFirstLabel = i;
            break;
        }
    }
    
    NSMutableString *firstLabelString = [[detailString substringToIndex:numberOfCharactersInFirstLabel] mutableCopy];
    
    if (firstLabelString.length != detailString.length) {
        while (![firstLabelString hasSuffix:@" "]) {
            firstLabelString = [[firstLabelString stringByReplacingCharactersInRange:NSMakeRange(firstLabelString.length-1, 1) withString:@""] mutableCopy];
            numberOfCharactersInFirstLabel -= 1;
        }
        
        NSString *secondLabelString = [detailString substringWithRange:NSMakeRange(numberOfCharactersInFirstLabel, detailString.length - numberOfCharactersInFirstLabel)];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:firstLabelString];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, numberOfCharactersInFirstLabel)];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:secondLabelString];
        [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, secondLabelString.length)];
        
        self.detailLabel.attributedText = attributedString;
        self.secondaryDetailLabel.attributedText = attributedString2;
    } else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:firstLabelString];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, numberOfCharactersInFirstLabel)];
        self.detailLabel.attributedText = attributedString;
    }
    
    [self.detailButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.detailButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapButton:(UIButton *)sender {
    self.pressButtonAction();
}

@end
