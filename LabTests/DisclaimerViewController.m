//
//  DisclaimerViewController.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/11/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController
@synthesize web;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Disclaimer";
    
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"infotext" ofType:@"htm"];
    
    // make a file: URL out of the path
    NSURL *instructionsURL = [NSURL fileURLWithPath:path];
    [web loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
    web.scalesPageToFit = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
