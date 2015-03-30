//
//  ASNProductManager.h
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/29.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface ASNProductManager : NSObject

+ (instancetype)sharedInstance;
- (NSArray *)searchedProductsFromSearchedResult:(NSArray *)results;

@end
