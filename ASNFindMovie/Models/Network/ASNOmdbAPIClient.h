//
//  ASNOmdbAPIClient.h
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import <Foundation/Foundation.h>

// http://www.omdbapi.com/
@interface ASNOmdbAPIClient : NSObject

- (void)searchMoviesByKeyword:(NSString *)keyword completion:(void (^)(NSArray *results, NSError *error))block;
- (void)getMovieInfoById:(NSString *)id completion:(void (^)(NSDictionary *result, NSError *error))block;

@end
