//
//  ASNMovieTableViewCell.m
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import "ASNMovieTableViewCell.h"
#import "ASNProduct.h"
#import "ASNOmdbAPIClient.h"

@implementation ASNMovieTableViewCell
{
    BOOL _faved;
}

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    // Initialization code
    _faved = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Accessor

- (void)setProductId:(NSString *)productId
{
    if (productId != nil) {
        _productId = productId;
        ASNProduct *product = [ASNProduct objectForPrimaryKey:_productId];
        self.titleLabel.text = product.name;
        self.publishedYearLabel.text = product.publishedYear;
        if (product.faved) {
            [self.favButton setBackgroundImage:[UIImage imageNamed:@"favedStar"] forState:UIControlStateNormal];
        } else {
            [self.favButton setBackgroundImage:[UIImage imageNamed:@"unfavedStar"] forState:UIControlStateNormal];
        }
        
        if ([product.plot isEqualToString:@""]) {
            ASNOmdbAPIClient *client = [[ASNOmdbAPIClient alloc] init];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [client getMovieInfoById:_productId completion:^(NSDictionary *result, NSError *error) {
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
                    self.productImageView.image = [UIImage imageWithData:productImageData];
                });
            }];
        } else {
            self.productImageView.image = [UIImage imageWithData:product.productImageData];
        }
    }
}

#pragma mark - IBAction

- (IBAction)tappedFavButton:(id)sender {
    if (_faved) {
        [self.favButton setBackgroundImage:[UIImage imageNamed:@"unfavedStar"] forState:UIControlStateNormal];
        _faved = NO;
    } else {
        [self.favButton setBackgroundImage:[UIImage imageNamed:@"favedStar"] forState:UIControlStateNormal];
        _faved = YES;
    }
    [[RLMRealm defaultRealm] beginWriteTransaction];
    ASNProduct *product = [ASNProduct objectForPrimaryKey:self.productId];
    product.faved = _faved;
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

@end
