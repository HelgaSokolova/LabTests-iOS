//
//  DetailViewController.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/1/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "DetailViewController.h"
#import "DesignUtils.h"
#import "AppDelegate.h"
#import "detailTableCell.h"
#import "DetailHeaderCell.h"
#import "FBDatabase.h"

#import <FirebaseAnalytics/FirebaseAnalytics.h>

@implementation DetailViewController
@synthesize dataItem;

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"US"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"US" forKey:@"Reference_Range"];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"SI"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"SI" forKey:@"Reference_Range"];
    }
    [self loadHtmlFile];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 3000.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DetailHeaderCell class])];
    
    dotImages1 = @[@"Black.png", @"Gold.png", @"Gray.png", @"Green.png", @"Lavender", @"Light Blue.png", @"Light Green.png", @"Orange.png", @"Pink.png", @"Red.png", @"Royal Blue.png", @"Tan.png", @"White.png", @"Yellow.png", @"CSF.png", @"Pico70.png"];
}

-(void)loadHtmlFile {
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"notFirstRun"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Reference Range" message:@"How would you like the Reference Range to be displayed?\n\n(It can be changed under 'More')" delegate:self cancelButtonTitle:@"US" otherButtonTitles:@"SI", nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"notFirstRun"];
    }
    
    self.navigationItem.title = self.dataItem.name;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    
    self.dataItem.lastOpened = [NSDate dateWithTimeIntervalSinceNow:0];
    
    //Load the data
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.database saveLastUsedTimes];
    
    [FIRAnalytics logEventWithName:@"open_article" parameters:@{
                                                                @"article_name" : self.dataItem.name
                                                                }];
    
    if ([FBDatabase shared].usable) {
        data = [[[FBDatabase shared] articleWithNumericAddress:[self.dataItem.address integerValue]] mutableCopy];
    }
    
    if (!data) {
        NSError *error = nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.dataItem.address
                                                             ofType:@"json"];
        NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
        data = [NSJSONSerialization JSONObjectWithData:dataFromFile
                                               options:kNilOptions
                                                 error:&error];
        
        if (error != nil) {
            NSLog(@"Error: was not able to load messages.");
        }
    }
    
    // This creates a json file to export
    
//    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
//    
//    for (NSInteger x = 1; x <= 175; x++) {
//        NSError *error = nil;
//        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", x]
//                                                             ofType:@"json"];
//        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//            NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
//            NSDictionary *dataD = [NSJSONSerialization JSONObjectWithData:dataFromFile
//                                                                  options:kNilOptions
//                                                                    error:&error];
//            
//            if (dataD) {
//                mutableDict[[NSString stringWithFormat:@"%d", x]] = dataD;
//            }
//        } else {
//            mutableDict[[NSString stringWithFormat:@"%d", x]] = @{ @"No article" : @"No article" };
//        }
//    }
//    
//    
//    NSDictionary *dict = @{ @"Articles" : mutableDict };
//    
//    NSData *json1= [ NSJSONSerialization dataWithJSONObject :dict options:NSJSONWritingPrettyPrinted error:nil];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"docs.json"];
//    
//    [json1 writeToFile:path atomically:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.dataItem) {
        [self loadHtmlFile];
    }else {
        NSLog(@"No dataItem - load empty screen");
        self.navigationItem.title = @"";
    }
    //Checking if the article is favorite
    if (self.dataItem.isFavorite) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"star_filled_22"] style:UIBarButtonItemStyleDone target:self action:@selector(favorite)];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"star_nonfilled_22"] style:UIBarButtonItemStyleDone target:self action:@selector(favorite)];
    }
    
    [self.tableView reloadData];
    
}

-(void)favorite {
        if (self.dataItem.isFavorite) {
        [self.dataItem setIsFavorite:NO];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"star_nonfilled_22"] style:UIBarButtonItemStyleDone target:self action:@selector(favorite)];
    }
    else {
        [self.dataItem setIsFavorite:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"star_filled_22"] style:UIBarButtonItemStyleDone target:self action:@selector(favorite)];
    }
    
    [FIRAnalytics logEventWithName:@"article_favourite" parameters:@{
                                                                     @"article_name" : self.dataItem.name,
                                                                     @"is_favourite" : @(self.dataItem.isFavorite)
                                                                     }];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.database saveFavorites];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    [view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    //Create custom view to display section header...
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, tableView.frame.size.width, 20)];
    [label setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightBold]];
    [label setTextColor:[DesignUtils blueColor]];
    
    [label setText:[[[data valueForKey:@"Article"] valueForKey:@"header"]objectAtIndex:section]];
    //[label setText:[[data valueForKey:@"header"]objectAtIndex:section]];

    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]]; //your background color...
    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([data valueForKey:@"Article"]) {
        if ([[data valueForKey:@"Article"] valueForKey:@"header"] && [[[data valueForKey:@"Article"] valueForKey:@"header"] isKindOfClass:[NSArray class]]) {
            return [[[data valueForKey:@"Article"] valueForKey:@"header"] count];
        }
    }
    
    return [[[data valueForKey:@"Article"] valueForKey:@"header"]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Created sanity check
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Reference_Range"]isEqualToString:@"SI"]) {
        if ([[[data valueForKey:@"Article"]valueForKey:@"paragraph_SI"] objectAtIndex:section]) {
            return [[[[data valueForKey:@"Article"]valueForKey:@"paragraph_SI"] objectAtIndex:section] count];
        } else {
            NSLog(@"No paragraph_SI found...");
        }
    } else {
        if ([[[data valueForKey:@"Article"]valueForKey:@"paragraph_US"] objectAtIndex:section]) {
            return [[[[data valueForKey:@"Article"]valueForKey:@"paragraph_US"] objectAtIndex:section] count];
        } else {
            NSLog(@"No paragraph_US found...");
        }
    }
    
    return [[[[data valueForKey:@"Article"]valueForKey:@"paragraph_US"] objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"tableViewCell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = @"";
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    NSString *displayString;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Reference_Range"]isEqualToString:@"SI"]) {
            displayString = [[[[data valueForKey:@"Article"]valueForKey:@"paragraph_SI"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    } else {
            displayString = [[[[data valueForKey:@"Article"]valueForKey:@"paragraph_US"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [displayString length])];
    cell.textLabel.attributedText = attributedString;
    cell.accessoryView = nil;
    
    //Setting the text/image for the cell (not possible for cell in section 0).
    if ([displayString containsString:@".png"]) {
        detailTableCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        if (!cell1) {
            cell1 = [[detailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
        }
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell1.imageViewImage.image = [UIImage imageNamed:displayString];
        return cell1;
    }
    
    //Setting up the dot_image
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        DetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailHeaderCell class])];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImage *image = nil;
        
        NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults]objectForKey:@"customDots"]mutableCopy];
        
        if([dict objectForKey:[NSString stringWithFormat:@"%@",self.dataItem.address]] != nil) {
            image = [UIImage imageNamed:[dict objectForKey:self.dataItem.address]];
        } else {
            image = [UIImage imageNamed:[[data valueForKey:@"dot_image"] objectAtIndex:indexPath.row]];
        }

        [cell configureWithDetailString:displayString image:image pressButtonAction:^{
            [self changeButtonColor];
        }];
        
        return cell;
    }
    
    return cell;
}

-(IBAction)buttonChanged:(id)sender {
    
    [self.popupController dismissPopupControllerAnimated:YES];
    UIButton *tmpButton = (UIButton *)sender;
    
    NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults]objectForKey:@"customDots"]mutableCopy];
    if (!dict) {
        dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[dotImages1 objectAtIndex:tmpButton.tag-300] forKey:[NSString stringWithFormat:@"%@",self.dataItem.address]];
    } else {
        [dict setObject:[dotImages1 objectAtIndex:tmpButton.tag-300] forKey:[NSString stringWithFormat:@"%@",self.dataItem.address]];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"customDots"];
    
    [self.tableView reloadData];
    
}

-(IBAction)changeButtonColor {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"C H A N G E   T H E   C O L O R" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.85, 45)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    button.layer.cornerRadius = 4.0f;
    button.backgroundColor = [DesignUtils blueColor];
    button.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
    };
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    titleLabel.textColor = [DesignUtils blueColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, [[UIScreen mainScreen] bounds].size.width*0.85, 100)];
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    [scrollView setPagingEnabled:NO];
    scrollView.showsHorizontalScrollIndicator = NO;

    int multiply = 0;
    for (NSString *image in dotImages1) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10+(70*multiply), 20, 60, 60)];
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonChanged:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 300+multiply;
        [scrollView addSubview:button];
        multiply++;
    }
    
    scrollView.contentSize = CGSizeMake(10+(70*dotImages1.count), 100);
    [scrollView setScrollEnabled:YES];
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, scrollView, button]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = CNPPopupStyleActionSheet;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
    
}

@end
