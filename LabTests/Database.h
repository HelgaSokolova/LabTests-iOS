//
//  Database.h
//  BloodTests
//
//  Created by Ole Gammelgaard Poulsen on 18/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article_Item.h"
#import "Category_Item.h"

@interface Database : NSObject {

	NSMutableArray *allArticles;
	NSMutableArray *allArticlesSorted;
	NSMutableArray *allCategories;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, retain) NSDate *lastOpened;
@property (nonatomic, readonly) NSMutableArray *allArticles; 
@property (nonatomic, readonly) NSMutableArray *allArticlesSorted; 
@property (nonatomic, readonly) NSArray *allCategories; 

- (void) saveLastUsedTimes;
- (NSMutableArray*) getRecents;
- (NSMutableArray*)getSubcategoriesOf:(NSUInteger)cat;
- (NSMutableArray*) getItemsOfCategory:(NSUInteger)cat;
- (NSMutableArray*) getFavorites;
- (void) saveFavorites;
-(BOOL)clearRecents;

@end
