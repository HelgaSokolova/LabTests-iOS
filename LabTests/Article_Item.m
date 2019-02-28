//
//  Article_Item.m
//  BloodTests
//
//  Created by Ole Gammelgaard Poulsen on 18/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//  --- UPDATED VERSION ---
//  Article_Item.m
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/6/16.
//  Copyright © 2016 AppMent. All rights reserved.


#import "Article_Item.h"


@implementation Article_Item
@synthesize name, lastOpened, categories, typeCode, address, subtitle, isFavorite,link,pubmed,flag,link0,link1,link2,link3,emedicine,url,pubname,wikiname,emediname,gname,publogo,wikilogo,emedilogo,glogo,linkcount,linkarray, htmlText, itemId;

-(id)initWithNode:(NSDictionary*)node num:(int)i; {

	if (self=[super init]) {
        
        itemId=i;
		categories = [node objectForKey:@"categories"];
		name = [node objectForKey:@"name"];
        typeCode = [[node objectForKey:@"type"]intValue];
        address = [node objectForKey:@"address"];
        linkcount = [[node objectForKey:@"linkcount"]intValue];
        lastOpened = [NSDate dateWithTimeIntervalSince1970:0];
        link = [node objectForKey:@"link"];
        pubmed = [node objectForKey:@"pubmed"];
        linkcount = [[node objectForKey:@"linkcount"]intValue];

        linkarray = [NSMutableArray new];
        for (int i =0;i<linkcount;i++)
        {
            NSString *link12 = [NSString stringWithFormat:@"Link%d",i];
            link0 = [NSMutableDictionary dictionaryWithDictionary:[node objectForKey:link12]];
            [linkarray addObject:link0];
        }
        
        link0 = [NSMutableDictionary dictionaryWithDictionary:[node objectForKey:@"Link0"]];
        link1 = [NSMutableDictionary dictionaryWithDictionary:[node objectForKey:@"Link1"]];
        link2 = [NSMutableDictionary dictionaryWithDictionary:[node objectForKey:@"Link2"]];
        link3 = [NSMutableDictionary dictionaryWithDictionary:[node objectForKey:@"Link3"]];

        pubmed = [link0 objectForKey:@"url"];
        pubname = [link0 objectForKey:@"name"];
        publogo = [link0 objectForKey:@"image"];
        
        link = [link1 objectForKey:@"url"];
        wikiname = [link1 objectForKey:@"name"];
        wikilogo = [link1 objectForKey:@"image"];
        
        emedicine = [link2 objectForKey:@"url"];
        emediname = [link2 objectForKey:@"name"];
        emedilogo = [link2 objectForKey:@"image"];
        
        url = [link3 objectForKey:@"url"];
        gname = [link3 objectForKey:@"name"];
        glogo = [link3 objectForKey:@"image"];
        
        flag = [node objectForKey:@"flag"];
        
        subtitle = [node objectForKey:@"subtitle"] ;
		if (subtitle == nil) {
			subtitle = @"";
		}
        
        //lastOpened = [NSDate dateWithTimeIntervalSince1970:0];
        subtitle = [node objectForKey:@"subtitle"];
        if (subtitle == nil) {
            subtitle = @"";
        }
        
        //For searching through the html files
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.address ofType:@"htm"];
        NSData  *data = [NSData dataWithContentsOfFile:filePath];
        self.htmlText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
	}
    
	return self;
}

- (NSComparisonResult) compareItemName:(Article_Item*)item {
    NSComparisonResult res;
    res= [[self name] compare:[item name]];
    return res;
}


- (NSComparisonResult) compareOpenedDate:(Article_Item*)item {
    NSComparisonResult res;
    res= [[self lastOpened] compare:[item lastOpened]];
    return -res;
}


@end
