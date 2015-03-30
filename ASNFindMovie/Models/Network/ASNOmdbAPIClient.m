//
//  ASNOmdbAPIClient.m
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import "ASNOmdbAPIClient.h"

@implementation ASNOmdbAPIClient
{
    NSString *_omdbBasePath;
    NSURLSession *_session;
}

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _omdbBasePath = @"http://www.omdbapi.com";
        _session = [NSURLSession sharedSession];
    }
    return self;
}

#pragma mark - Instance Methods

- (void)searchMoviesByKeyword:(NSString *)keyword completion:(void (^)(NSArray *, NSError *))block
{
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?s=%@&y=&plot=short&r=json", _omdbBasePath, keyword]];
    
    NSURLSessionDataTask* dataTask = [_session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            block(nil, error);
            return;
        }
        NSDictionary *responseResult = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *movies = responseResult[@"Search"];
        
        block(movies, nil);
    }];
    [dataTask resume];
}

- (void)getMovieInfoById:(NSString *)movieId completion:(void (^)(NSDictionary *, NSError *))block
{
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/?i=%@&y=&plot=short&r=json", _omdbBasePath, movieId]];
    
    NSURLSessionDataTask* dataTask = [_session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            block(nil, error);
        }
        NSDictionary *movieDetail = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        block(movieDetail, nil);
    }];
    [dataTask resume];
}

@end
