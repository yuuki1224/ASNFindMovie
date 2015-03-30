//
//  ASNTwitter.m
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import "ASNTwitter.h"

@implementation ASNTwitter
{
    NSString *_searchURL;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _searchURL = @"https://api.twitter.com/1.1/search/tweets.json";
    }
    return self;
}

- (void)searchTweetsByKeyword:(NSString *)keyword completion:(void (^)(NSArray *, NSError *))block
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (granted) {
            NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
            
            for (ACAccount *account in accountArray) {
                if ([account.accountType.identifier isEqualToString:@"com.apple.twitter"]) {
                    NSURL *url = [NSURL URLWithString:_searchURL];
                    NSDictionary *params = @{
                                             @"q": keyword
                                             };
                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                            requestMethod:SLRequestMethodGET
                                                                      URL:url
                                                               parameters:params];
                    [request setAccount:[accountArray objectAtIndex:0]];
                    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                        NSArray *tweetResponses = result[@"statuses"];
                        NSMutableArray *searchedTweet = [[NSMutableArray alloc] init];
                        for (NSDictionary *tweetResponse in tweetResponses) {
                            NSMutableDictionary *tweet = [[NSMutableDictionary alloc] init];
                            
                            [tweet setObject:[tweetResponse valueForKeyPath:@"user.name"] forKey:@"name"];
                            [tweet setObject:[tweetResponse valueForKeyPath:@"user.screen_name"] forKey:@"twitterId"];
                            [tweet setObject:[tweetResponse valueForKeyPath:@"user.profile_image_url"] forKey:@"image"];
                            [tweet setObject:[tweetResponse valueForKeyPath:@"text"] forKey:@"text"];
                            [tweet setObject:[tweetResponse valueForKeyPath:@"created_at"] forKey:@"createdAt"];
                            
                            [searchedTweet addObject:[tweet copy]];
                        }
                        
                        block([searchedTweet copy], nil);
                    }];
                }
            }
        } else{
            NSError *error = [NSError errorWithDomain:@"Not allowed use social account" code:1 userInfo:nil];
            block(nil, error);
        }
    }];
}

@end
