//
//  Database.m
//  BloodTests
//
//  Created by Ole Gammelgaard Poulsen on 18/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "Database.h"
#import "Article_Item.h"

@implementation Database

@synthesize allArticles, allCategories, allArticlesSorted, name, lastOpened;

- (id) init {
	if (self=[super init]) {
        
        NSDictionary *db = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mainDatabase" ofType:@"plist"]];
		allArticles = [[NSMutableArray alloc] init];
        
		int i = 1;
		for (NSDictionary *arrayItem in (NSArray*)[db objectForKey:@"Articles"]) {
			Article_Item *newItem = [[Article_Item alloc] initWithNode:arrayItem num:i++];
            [allArticles addObject:newItem];
		}
        
        NSString *filePath2=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"lastOpenedTimes.plist"];
        NSMutableDictionary *values =[NSMutableDictionary dictionaryWithContentsOfFile:filePath2];
        for (Article_Item *item in allArticles) {
			NSDate *time = [values valueForKey:[NSString stringWithFormat:@"%ld",(long)item.itemId]];
            if (time==nil) time = [NSDate dateWithTimeIntervalSince1970:0];
            item.lastOpened = time;
		}
		
        // read favorites
        NSString *filePath3=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"favorites.plist"];
        NSMutableDictionary *favValues=[NSMutableDictionary dictionaryWithContentsOfFile:filePath3];
		for (Article_Item *item in allArticles) {
			BOOL fav = [[favValues valueForKey:[NSString stringWithFormat:@"%ld",(long)item.itemId]] boolValue];
			item.isFavorite = fav;
		}
		
		// sort alphabetic
		allArticlesSorted = [allArticles mutableCopy];
		[allArticlesSorted sortUsingSelector:@selector(compareItemName:)];
		
		//load categories
		allCategories=[[NSMutableArray alloc] init];
		NSArray *rawCategories=[db objectForKey:@"Categories"];
		i=1;
		for (NSDictionary *arrayItem in rawCategories) {
			Category_Item *newCat = [[Category_Item alloc] initWithNode:arrayItem num:i++];
            [allCategories addObject:newCat];
		}
		
	}
	return self;
}

-(BOOL)clearRecents {
    
    NSString *filePath2=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"lastOpenedTimes.plist"];
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    [values writeToFile:filePath2 atomically:YES];
    
    for (Article_Item *item in allArticles) {
        item.lastOpened = [NSDate dateWithTimeIntervalSince1970:0];;
    }
    
    return YES;
}

- (void)saveLastUsedTimes {
    
    NSString *filePath2=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"lastOpenedTimes.plist"];
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    NSLog(@"1saveLastUsedTimes: %@", values);
	for (Article_Item *item in allArticles) {
        if (1==[item.lastOpened compare:[NSDate dateWithTimeIntervalSince1970:1]])
			[values setValue:item.lastOpened forKey:[NSString stringWithFormat:@"%ld",(long)item.itemId]];
	}
	[values writeToFile:filePath2 atomically:YES];
    
}

- (void)saveFavorites {
    
    NSString *filepath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"favorites.plist"];
	NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
	for (Article_Item *item in allArticles) {
        if (item.isFavorite) {
			[values setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",(long)item.itemId]];
            NSLog(@"saveFavorites: %@", values);
        }
	}
    
	[values writeToFile:filepath atomically:YES];
    NSLog(@"saveFavorites: %@", values);
}

- (NSMutableArray*)getRecents {
    
	NSMutableArray *opened=[[NSMutableArray alloc] init];
	for (Article_Item *item in allArticles) {
		if (1 == [item.lastOpened compare:[NSDate dateWithTimeIntervalSince1970:1]])
			[opened  addObject:item];
	}
	
	[opened sortUsingSelector:@selector(compareOpenedDate:)];
	
	int numExceed = (int)opened.count-9;
	for (int i=0; i<numExceed; i++) {
		[opened removeLastObject];
	}
	
    return opened;
}

- (NSMutableArray*)getFavorites {
	NSMutableArray *favs=[[NSMutableArray alloc] init];
	for (Article_Item *item in allArticles) {
        if (item.isFavorite) {
			[favs  addObject:item];
            NSLog(@"Favorite: %@",favs);
        }
	}
	
	[favs sortUsingSelector:@selector(compareItemName:)];
    return favs;
}

- (NSMutableArray*)getSubcategoriesOf:(NSUInteger)cat {
	NSMutableArray *tempArray=[[NSMutableArray alloc] init];
	for (Category_Item *category in allCategories) {
		for (NSNumber *parrentId in category.parrents) {
			if ([parrentId integerValue]==cat) {
				[tempArray addObject:category];
				continue;
			}
		}
	}
    return tempArray;
}

- (NSMutableArray*) getItemsOfCategory:(NSUInteger)cat {
	NSMutableArray *found=[[NSMutableArray alloc] init];
	for (Article_Item *item in allArticles) {
		for (NSNumber *categoryNum in item.categories) {
			if ([categoryNum integerValue]==cat)
				[found addObject:item];
		}
	}
	
	[found sortUsingSelector:@selector(compareItemName:)];
    return found;
}

- (NSComparisonResult) compareItemName:(Article_Item*)item {
    NSComparisonResult res;
    res = [[self name] compare:[item name]];
    return res;
}
- (NSComparisonResult) compareOpenedDate:(Article_Item*)item {
    NSComparisonResult res;
    res = [[self lastOpened] compare:[item lastOpened]];
    return -res;
}

- (void) setFavoriteStatus:(BOOL)isFav forItemNamed:(NSString*)title {
	for (Article_Item *item in allArticles) {
		if ([item.name isEqualToString:title])
        {
            NSLog(@"item.name=%@",item.name);
			item.isFavorite = isFav;
            NSLog(@"database  = %i",item.isFavorite);
            NSLog(@"title is database = %@",title);
        }
	}
	
}



@end
