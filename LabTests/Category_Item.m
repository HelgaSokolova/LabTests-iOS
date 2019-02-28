//
//  Category_Item.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/6/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import "Category_Item.h"

@implementation Category_Item

@synthesize name, parrents, autoId, logoFile;

-(id) initWithNode:(NSDictionary*)node num:(int)i {
    if (self=[super init]) {
        autoId = i;
        parrents = [node objectForKey:@"parrents"];
        name = [node objectForKey:@"name"];
        description = [node objectForKey:@"description"];
        logoFile = [node objectForKey:@"logo"];
    }
    return self;
}

@end
