//
//  ASNFavListViewController.m
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import "ASNFavListViewController.h"
#import <Realm/Realm.h>
#import "ASNProduct.h"

@interface ASNFavListViewController ()

@end

@implementation ASNFavListViewController
{
    RLMResults *_favedProducts;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _favedProducts = [ASNProduct objectsWhere:@"faved=YES"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_favedProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ASNFavListTableCell"];
    ASNProduct *product = [_favedProducts objectAtIndex:indexPath.row];
    UIImageView *productImage = (UIImageView *)[cell viewWithTag:1];
    UILabel *productName = (UILabel *)[cell viewWithTag:2];
    
    productImage.image = [UIImage imageWithData:product.productImageData];
    productName.text = product.name;
    
    return cell;
}

#pragma mark - IBAction

- (IBAction)tappedBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
