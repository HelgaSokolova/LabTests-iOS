//
//  InfoViewController.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/11/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "InfoViewController.h"
#import "DesignUtils.h"
#import "MKStoreKit.h"
#import "AppDelegate.h"
@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"More";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"SI" forKey:@"Reference_Range"];
    }
    if(segment.selectedSegmentIndex == 1)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"US" forKey:@"Reference_Range"];
    }
}

- (void)changeFont:(UISegmentedControl *)segment
{
    NSLog(@"change");
    CGFloat size = 14;
    if(segment.selectedSegmentIndex == 0)
    {
        size = 14;
    }
    if(segment.selectedSegmentIndex == 1)
    {
        size = 16;
    }
    if(segment.selectedSegmentIndex == 2)
    {
        size = 19;
    }
    
    [[NSUserDefaults standardUserDefaults]setFloat:size forKey:@"fontSize"];
    [[UILabel appearance] setFont:[UIFont systemFontOfSize:size]];
    
    [self.tableView reloadInputViews];
    [self.tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    [view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    //Create custom view to display section header...
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, tableView.frame.size.width, 20)];
    [label setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular]];
    [label setTextColor:[DesignUtils blueColor]];
    
    if (section == 0) {
        [label setText:@"GENERAL"];
    }
    if (section == 1) {
        [label setText:@"IN-APP PURCHASE"];
    }
//    if (section == 2) {
//        [label setText:@"LINKS"];
//    }
    if (section == 2) {
        [label setText:@"APP DETAILS"];
    }
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]]; //your background color...
    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    if (section == 1) {
        return 1;
    }
//    if (section == 2) {
//        return 5;
//    }
    if (section == 2) {
        return 1;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"tableViewCell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    cell.detailTextLabel.text = @"";
    [cell.textLabel setFont:[UIFont systemFontOfSize:[[NSUserDefaults standardUserDefaults]floatForKey:@"fontSize"]]];
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            static NSString *CellIdentifier = @"tableViewCell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            cell.detailTextLabel.text = @"";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            [cell.textLabel setFont:[UIFont systemFontOfSize:[[NSUserDefaults standardUserDefaults]floatForKey:@"fontSize"]]];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:(UITableViewCellAccessoryNone)];
            cell.textLabel.text = @"Reference Range";
            UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"SI", @"US", nil]];
            [control addTarget:self action:@selector(MySegmentControlAction:) forControlEvents:UIControlEventValueChanged];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Reference_Range"]isEqualToString:@"SI"]) {
                control.selectedSegmentIndex = 0;
            } else {
                control.selectedSegmentIndex = 1;
            }
            control.tintColor = [DesignUtils blueColor];
            //control.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            control.frame = CGRectMake(0, 0, 150, 30);
            cell.accessoryView = control;
            return cell;
        }
        if (indexPath.row == 1) {
            
            static NSString *CellIdentifier = @"tableViewCell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
            cell.detailTextLabel.text = @"";
            [cell.textLabel setFont:[UIFont systemFontOfSize:[[NSUserDefaults standardUserDefaults]floatForKey:@"fontSize"]]];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:(UITableViewCellAccessoryNone)];
            cell.textLabel.text = @"Text size";
            UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Small", @"Medium", @"Large", nil]];
            [control addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventValueChanged];
            if ([[NSUserDefaults standardUserDefaults]floatForKey:@"fontSize"]==14) {
                control.selectedSegmentIndex = 0;
            } else if ([[NSUserDefaults standardUserDefaults]floatForKey:@"fontSize"]==16) {
                control.selectedSegmentIndex = 1;
            } else if ([[NSUserDefaults standardUserDefaults]floatForKey:@"fontSize"]==19) {
                control.selectedSegmentIndex = 2;
            }
            control.tintColor = [DesignUtils blueColor];
            //control.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            control.frame = CGRectMake(0, 0, 200, 30);
            cell.accessoryView = control;
            return cell;
            
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Send Feedback";
            return cell;
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"Disclaimer";
            return cell;
        }
        if (indexPath.row == 4) {
            cell.textLabel.text = @"Reset tube colors";
            return cell;
        }
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = @"Restore in-app purchases";
        return cell;
    }
    /*else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Medical Lab Tests";
            return cell;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"ECG Atlas";
            return cell;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"Memo2 Notebook";
            return cell;
            
        }
        else if (indexPath.row == 3) {
            cell.textLabel.text = @"Pupil Gauge";
            return cell;
        }
        else if (indexPath.row == 4) {
            cell.textLabel.text = @"Childhood Diseases";
            return cell;
        }
    }*/
    else if (indexPath.section == 2) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", version, build];
        cell.textLabel.text = [NSString stringWithFormat:@"Version"];
        [cell setAccessoryType:(UITableViewCellAccessoryNone)];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailcontroller = [[MFMailComposeViewController alloc] init];
                [mailcontroller setMailComposeDelegate:self];
                [mailcontroller setToRecipients:[NSArray arrayWithObject:@"mail@mediconapps.com"]];
                [mailcontroller setSubject:@"Feedback on LabTests"];
                [mailcontroller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:mailcontroller animated: YES completion:nil];
            }
        }
        else if (indexPath.row==3)
        {
            [self performSegueWithIdentifier:@"presentDisclaimer" sender:self];
        }
        else if (indexPath.row==4)
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"customDots"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Reset completed" message:@"The color of the tubes have been reset" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    if (indexPath.section == 1) {
        [[MKStoreKit sharedKit] restorePurchases];
    }
    
    /*if (indexPath.section == 2) {
        if (indexPath.row==0) {
            NSLog(@"Medical Lab Tests");
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id374536482"]];
        }
        else if (indexPath.row==1) {
            NSLog(@"ECG Atlas");
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id366846035"]];
        }
        else if (indexPath.row==2) {
            NSLog(@"Memo2 Notebook");
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id412703835"]];
        }
        else if (indexPath.row==3) {
            NSLog(@"Pupil Gauge");
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id416890737"]];
        }
        else if (indexPath.row==4) {
            NSLog(@"Childhood Diseases");
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id322980239"]];
        }
    }*/

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent: {
            NSLog(@"You sent the email.");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sent!" message:@"Your e-mail was succesfully sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
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
