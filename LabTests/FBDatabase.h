//
//  FBDatabase.h
//  LabTests
//
//  Created by Mihai on 17/08/2017.
//  Copyright © 2017 AppMent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBDatabase : NSObject

@property (nonatomic, strong, readonly) NSDictionary *articles;
@property (nonatomic, assign, readonly) BOOL usable;

+ (instancetype)shared;
- (void)retrieveArticles:(void (^)(BOOL))completion;
- (NSDictionary *)articleWithNumericAddress:(NSInteger)numericAddress;

@end
