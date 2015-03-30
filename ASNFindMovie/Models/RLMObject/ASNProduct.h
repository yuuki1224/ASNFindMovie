//
//  ASNProduct.h
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/29.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import <Realm/Realm.h>

@interface ASNProduct : RLMObject

@property NSString *productId;
@property NSString *name;
@property NSString *type; // movie, series, episode
@property NSData *productImageData;
@property NSString *plot;
@property NSString *publishedYear;

@property BOOL faved;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ASNProduct>
RLM_ARRAY_TYPE(ASNProduct)
