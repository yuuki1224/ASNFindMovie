//
//  ASNProduct.m
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/29.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import "ASNProduct.h"

@implementation ASNProduct

+ (NSString *)primaryKey {
    return @"productId";
}

+ (NSDictionary *)defaultPropertyValues
{
    NSData *data = [[NSData alloc] init];
    return @{
             @"productImageData": data,
             @"plot": @""
             };
}

@end
