//
//  ASNProductManager.m
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/29.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import "ASNProductManager.h"
#import "ASNProduct.h"
#import "ASNOmdbAPIClient.h"

@implementation ASNProductManager

#pragma mark - Class Methods

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static ASNProductManager *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ASNProductManager alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - Instance Methods

- (NSArray *)searchedProductsFromSearchedResult:(NSArray *)results
{
    NSMutableArray *products = [[NSMutableArray alloc] init];
    for (NSDictionary *result in results) {
        NSString *imdbID = result[@"imdbID"];
        ASNProduct *product = [ASNProduct objectForPrimaryKey:imdbID];
        
        if (product == nil) {
            product = [[ASNProduct alloc] init];
            product.name = result[@"Title"];
            product.productId = imdbID;
            product.publishedYear = result[@"Year"];
            product.type = result[@"Type"];
            
            [[RLMRealm defaultRealm] beginWriteTransaction];
            [[RLMRealm defaultRealm] addObject:product];
            [[RLMRealm defaultRealm] commitWriteTransaction];
        }
        
        [products addObject:product];
    }
    
    return [products copy];
}

@end
