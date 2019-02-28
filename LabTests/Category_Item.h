//
//  Category_Item.h
//  LabTests
//
//  Created by Jakob Mikkelsen on 1/6/16.
//  Copyright © 2016 AppMent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category_Item : NSObject{
    
    NSUInteger autoId;
    NSArray *parrents;
    NSString *name;
    NSString *description;
    NSString *logoFile;
}

-(id) initWithNode:(NSDictionary*)node num:(int)i;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *parrents;
@property (nonatomic) NSUInteger autoId;
@property (nonatomic, retain) NSString *logoFile;

@end
