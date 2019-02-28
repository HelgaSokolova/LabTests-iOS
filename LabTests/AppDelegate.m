//
//  AppDelegate.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/1/16.
//  Copyright © 2016 AppMent. All rights reserved.
//


#import "DesignUtils.h"
#import "FBDatabase.h"
#import "AppDelegate.h"
#import "MKStoreKit.h"
#import "FirstTableViewController.h"
#import "DetailViewController.h"
#import "SplitViewController.h"

#import <iRate/iRate.h>
#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate
@synthesize database;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#warning Remember to outcomment!
    //Making the app 'ProVersion'
    //[[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ProVersion"];
    
    //Initiate the database
    self.database = [[Database alloc]init];
    
    [FIRApp configure];
    
    // iRate setup
    [iRate sharedInstance].usesUntilPrompt = 10;
    
    //Check for first run
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"notFirstRun"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"SI" forKey:@"Reference_Range"];
        [[UILabel appearance] setFont:[UIFont systemFontOfSize:16]];
        [[NSUserDefaults standardUserDefaults]setFloat:16 forKey:@"fontSize"];
    }

    //In-app purchases
    [[MKStoreKit sharedKit] startProductRequest];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Products available: %@", [[MKStoreKit sharedKit] availableProducts]);
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                                                          
                                                          NSLog(@"Purchased product with id: %@", [note object]);
                                                          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Succes!" message:@"You've bought the Pro Version!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                          [alert show];
                                                          [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ProVersion"];
                                                      }];
                                                      
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                                                          
                                                          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Purchase restored!" message:@"Your pro-version has succesfully been restored" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                          [alert show];
                                                          
                                                      }];
                                        
                                                      NSLog(@"Restored Purchases - show uialertview?");
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                                                          
                                                          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Restore failed" message:@"We couldn't restore your purchase - Please try again.\n\nIf the problem continues, send an e-mail to mail@mediconapps.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                          [alert show];
                                                          
                                                      }];
                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                  }];
    
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    //Overall design
    [[UITabBar appearance] setTintColor:[DesignUtils blueColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UIToolbar appearance] setTintColor:[DesignUtils blueColor]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[DesignUtils blueColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:17 weight:UIFontWeightMedium], NSFontAttributeName, nil]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSTimeInterval lastUpdated = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lastUpdatedDatabase"] doubleValue];
    
    if (![FBDatabase shared].usable || (lastUpdated + 60 * 24 * 60) <= [[NSDate date] timeIntervalSince1970]) {
        [[FBDatabase shared] retrieveArticles:^(BOOL completion) {
            if (completion) {
                [[NSUserDefaults standardUserDefaults] setValue:@([[NSDate date] timeIntervalSince1970]) forKey:@"lastUpdatedDatabase"];
            }
        }];
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
