//
//  AppDelegate.h
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/1/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) Database *database;
@property (strong, nonatomic) UIWindow *window;


@end

