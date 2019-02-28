//
//  DisclaimerViewController.h
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/11/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisclaimerViewController : UIViewController <UIWebViewDelegate,UINavigationBarDelegate,UIScrollViewDelegate,UINavigationControllerDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *web;
@end
