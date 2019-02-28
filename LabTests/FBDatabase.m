//
//  FBDatabase.m
//  LabTests
//
//  Created by Mihai on 17/08/2017.
//  Copyright © 2017 AppMent. All rights reserved.
//

#import "FBDatabase.h"
#import <FirebaseDatabase/FirebaseDatabase.h>

@interface FBDatabase ()

@property (nonatomic, strong) FIRDatabaseReference *ref;
@property (nonatomic, assign, readwrite) BOOL usable;
@property (nonatomic, strong) NSDictionary *articles;

@end


@implementation FBDatabase

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static FBDatabase *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
        shared.ref = [[FIRDatabase database] reference];
        [shared retrieveArticles:^(BOOL completion) {
            shared.usable = completion;
        }];
    });
    
    return shared;
}

- (void)retrieveArticles:(void (^)(BOOL))completion {
    [[_ref child:@"Articles"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot.valueInExportFormat isKindOfClass:[NSDictionary class]]) {
            NSDictionary *someArticleDict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)snapshot.valueInExportFormat];

            NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
            mutableDictionary[@"Articles"] = [self flattenDictionary:someArticleDict forKey:@"Articles"];
            
            self.articles = mutableDictionary;
            
            completion(YES);
            return;
        }
        
        completion(NO);
    } withCancelBlock:^(NSError * _Nonnull error) {
        completion(NO);
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (id)flattenDictionary:(NSDictionary *)dict forKey:(NSString *)key {
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSInteger i = 0; i<dict.allKeys.count; i++) {
        array[i] = @"***"; // just to make sure the array is not empty
    }
    
    if ([[NSScanner scannerWithString:dict.allKeys.firstObject] scanInt:nil]) {
        for (NSString *key in dict.allKeys) {
            if ([dict[key] isKindOfClass:[NSDictionary class]]) {
                id obj = [self flattenDictionary:dict[key] forKey:key];
                array[[key integerValue]] = obj;
            } else {
                array[[key integerValue]] = dict[key];
            }
            
            // we need to place the objects according to the incoming key, so as not to change the order of the elements within the array - that's why we use the key as index
        }
        
        [array removeObjectIdenticalTo:@"***"];
        
        return array;
    } else {
        NSMutableDictionary *dictionary = [NSMutableDictionary new];
        
        for (NSString *key in dict.allKeys) {
            if ([dict[key] isKindOfClass:[NSDictionary class]]) {
                id obj = [self flattenDictionary:dict[key] forKey:key];
                dictionary[key] = obj;
            } else {
                dictionary[key] = dict[key];
            }
        }
        
        return dictionary;
    }
}

- (NSDictionary *)articleWithNumericAddress:(NSInteger)numericAddress {
    NSArray *array = self.articles[@"Articles"];
    
    if (numericAddress - 1 < array.count) {  // -1 due to 0 indexing
        return array[numericAddress - 1];
    }
    
    return nil;
}

@end
