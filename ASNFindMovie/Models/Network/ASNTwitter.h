//
//  ASNTwitter.h
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ASNTwitter : NSObject

- (void)searchTweetsByKeyword:(NSString *)keyword completion:(void (^)(NSArray *tweets, NSError *error))block;

@end
