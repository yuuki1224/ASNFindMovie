//
//  ASNDetailViewController.m
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import "ASNDetailViewController.h"
#import "ASNOmdbAPIClient.h"
#import <MessageUI/MessageUI.h>
#import "ASNTwitter.h"
#import "ASNProduct.h"

@interface ASNDetailViewController ()
{
    NSString *_title;
    NSString *_imageURL;
    NSString *_plot;
    
    NSArray *_recentTweets;
    
    MFMailComposeViewController *_mailVC;
}

@end

@implementation ASNDetailViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mailVC = [[MFMailComposeViewController alloc] init];
    _mailVC.mailComposeDelegate = self;
    
    ASNOmdbAPIClient *client = [[ASNOmdbAPIClient alloc] init];
    ASNTwitter *twitter = [[ASNTwitter alloc] init];
    
    ASNProduct *product = [ASNProduct objectForPrimaryKey:self.productId];
    if ([product.plot isEqualToString:@""]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [client getMovieInfoById:self.productId completion:^(NSDictionary *result, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSString *plot;
            if ([result[@"Plot"] isEqualToString:@"N/A"]) {
                plot = @"No Plot";
            } else {
                plot = result[@"Plot"];
            }
            
            NSString *imageURL = result[@"Poster"];
            NSData *productImageData;
            if ([imageURL isEqualToString:@"N/A"]) {
                UIImage *productImage = [UIImage imageNamed:@"noImage"];
                productImageData = UIImagePNGRepresentation(productImage);
            } else {
                productImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            }
            
            [[RLMRealm defaultRealm] beginWriteTransaction];
            ASNProduct *product = [ASNProduct objectForPrimaryKey:_productId];
            product.plot = plot;
            product.productImageData = productImageData;
            [[RLMRealm defaultRealm] commitWriteTransaction];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.productTitleLabel.text = product.name;
                self.productImageView.image = [UIImage imageWithData:product.productImageData];
                self.productPlot.text = product.plot;
            });
        }];
    } else {
        self.productTitleLabel.text = product.name;
        self.productImageView.image = [UIImage imageWithData:product.productImageData];
        self.productPlot.text = product.plot;
    }
    
    // Update Twitter Status
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [twitter searchTweetsByKeyword:product.name completion:^(NSArray *tweets, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _recentTweets = tweets;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tweetTable reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDateSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_recentTweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"ASNDetailTweetCell"];
    NSDictionary *tweetInfo = [_recentTweets objectAtIndex:indexPath.row];
    
    UIImageView *tweetImageView = (UIImageView *)[tweetCell viewWithTag:5];
    NSData *tweetImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:tweetInfo[@"image"]]];
    UIImage *tweetImage = [UIImage imageWithData:tweetImageData];
    tweetImageView.image = tweetImage;
    
    UILabel *tweetName = (UILabel *)[tweetCell viewWithTag:2];
    tweetName.text = tweetInfo[@"name"];
    
    UILabel *tweetAccountID = (UILabel *)[tweetCell viewWithTag:3];
    tweetAccountID.text = tweetInfo[@"twitterId"];
    
    UILabel *tweetContent = (UILabel *)[tweetCell viewWithTag:4];
    tweetContent.text = tweetInfo[@"text"];
    
    return tweetCell;
}

#pragma mark - IBAction

- (IBAction)tappedSendEmail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        NSString *subject = self.productTitleLabel.text;
        NSString *message = [NSString stringWithFormat:@"I recommend this movie to you! %@", self.productTitleLabel.text];
        
        [_mailVC setSubject:subject];
        [_mailVC setMessageBody:message isHTML:NO];
        
        [self presentViewController:_mailVC animated:YES completion:nil];
    } else {
        // Alert
    }
}

@end
