//
//  DesignUtils.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 2/1/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "DesignUtils.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation DesignUtils
+ (UIColor*) blueColor {
    return UIColorFromRGB(0x66C0CF);
}

@end
