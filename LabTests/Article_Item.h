//
//  Article_Item.h
//  BloodTests
//
//  Created by Ole Gammelgaard Poulsen on 18/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//  --- UPDATED VERSION ---
//  Article_Item.h
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/6/16.
//  Copyright © 2016 AppMent. All rights reserved.

#import <Foundation/Foundation.h>


@interface Article_Item : NSObject {
    
}

//For searching through the html files

@property (nonatomic, readonly) NSUInteger itemId;
@property (nonatomic,retain) NSString *htmlText;

-(id)initWithNode:(NSDictionary*)node num:(int)i;

@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, retain) NSDate *lastOpened;
@property (nonatomic) int typeCode;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic, readonly) NSString *link;
@property (nonatomic, readonly) NSString *pubmed;
@property (nonatomic, readonly) NSString *flag;

@property (nonatomic ,retain)NSMutableDictionary *link0;
@property (nonatomic ,retain)NSMutableDictionary *link1;
@property (nonatomic ,retain)NSMutableDictionary *link2;
@property (nonatomic ,retain)NSMutableDictionary *link3;

@property (nonatomic,retain)NSString *emedicine;
@property (nonatomic,retain)NSString *url;
@property (nonatomic,retain)NSString *pubname;
@property (nonatomic,retain)NSString *wikiname;
@property (nonatomic,retain)NSString *emediname;
@property (nonatomic,retain)NSString *gname;
@property (nonatomic,retain)NSString *publogo;
@property (nonatomic,retain)NSString *wikilogo;
@property (nonatomic,retain)NSString *emedilogo;
@property (nonatomic,retain)NSString *glogo;

@property (nonatomic)int linkcount;
@property (nonatomic,retain)NSMutableArray *linkarray;

@end
