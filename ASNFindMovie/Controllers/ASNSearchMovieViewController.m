//
//  ASNSearchMovieViewController.m
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import "ASNSearchMovieViewController.h"
#import "ASNDetailViewController.h"
#import "ASNMovieTableViewCell.h"
#import "ASNOmdbAPIClient.h"
#import "ASNSettingsView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ASNProductManager.h"
#import "ASNProduct.h"

@interface ASNSearchMovieViewController ()

@end

@implementation ASNSearchMovieViewController
{
    // search Result
    NSArray *_searchedProducts;
    
    // filtered and sorted Movies
    NSArray *_orderedShowingProducts;
    
    ASNSettingsView *_settingsView;
    UIView *_backmaskView;
}

#pragma mark - LiceCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.moviesTable.delegate = self;
    self.moviesTable.dataSource = self;
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *ASNSettingsVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ASNSettingsViewController"];
    _settingsView = (ASNSettingsView *)ASNSettingsVC.view;
    _settingsView.frame = CGRectMake(0, 0, 290, 310);
    _settingsView.delegate = self;
    
    _backmaskView = [[UIView alloc] initWithFrame:self.view.frame];
    _backmaskView.backgroundColor = [UIColor blackColor];
    _backmaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (NSArray *)_orderedShowingMoviesWithProducts:(NSArray *)product sort:(ASNSettingsSort)sort filter:(ASNSettingsFilter)filter
{
    NSMutableArray *filteredProduct = [self _filteredProductsWithProducts:product filter:filter];
    return [self _sortedProductsWithProducts:filteredProduct sort:sort];
}

- (NSMutableArray *)_filteredProductsWithProducts:(NSArray *)products filter:(ASNSettingsFilter)filter
{
    NSMutableArray *filterArray = [NSMutableArray array];
    if (filter & ASNSettingsFilterMovie) {
        [filterArray addObject:@"movie"];
    }
    if (filter & ASNSettingsFilterSeries) {
        [filterArray addObject:@"series"];
    }
    if (filter & ASNSettingsFilterEpisode) {
        [filterArray addObject:@"episode"];
    }
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"type IN %@", filterArray];
    NSMutableArray *allProduct = [products mutableCopy];
    [allProduct filterUsingPredicate:filterPredicate];
    return allProduct;
}

- (NSArray *)_sortedProductsWithProducts:(NSMutableArray *)products sort:(ASNSettingsSort)sort
{
    [products sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        // NSOrderedAscending, NSOrderedSame, NSOrderedDescending
        ASNProduct *product1 = (ASNProduct *)obj1;
        ASNProduct *product2 = (ASNProduct *)obj2;
        
        if (sort == ASNSettingsSortName) {
            NSString *product1Name = product1.name;
            NSString *product2Name = product2.name;
            return [product1Name compare:product2Name];
        } else if (sort == ASNSettingsSortPublishedDate) {
            NSString *product1Year = product1.publishedYear;
            NSString *product2Year = product2.publishedYear;
            return [product1Year compare:product2Year];
        }
        return NSOrderedSame;
    }];

    return [products copy];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASNMovieTableViewCell *selectedCell = (ASNMovieTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ASNDetailViewController *detailViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ASNDetailViewController"];
    detailViewController.productId = selectedCell.productId;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_orderedShowingProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASNMovieTableViewCell *cell = (ASNMovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ASNMovieTableViewCell"];
    
    ASNProduct *product = (ASNProduct *)_orderedShowingProducts[indexPath.row];
    cell.productId = product.productId;
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    ASNOmdbAPIClient *client = [[ASNOmdbAPIClient alloc] init];
    
    [SVProgressHUD show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [client searchMoviesByKeyword:searchBar.text completion:^(NSArray *results, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (error != nil) {
            return;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            _searchedProducts = [[ASNProductManager sharedInstance] searchedProductsFromSearchedResult:results];
            _orderedShowingProducts = [self _orderedShowingMoviesWithProducts:_searchedProducts sort:_settingsView.sortSettings filter:_settingsView.filterSettings];
            [self.moviesTable reloadData];
            [SVProgressHUD dismiss];
        });
    }];
}

#pragma mark - ASNSettingsViewDelegate

- (void)didTappedDoneButton:(ASNSettingsView *)settingsView
{
    [_backmaskView removeFromSuperview];
    [_settingsView removeFromSuperview];
    
    _orderedShowingProducts = [self _orderedShowingMoviesWithProducts:_searchedProducts sort:settingsView.sortSettings filter:settingsView.filterSettings];
    [self.moviesTable reloadData];
}

#pragma mark - IBAction

- (IBAction)tappedSettingsButton:(id)sender
{
    [self.navigationController.view addSubview:_backmaskView];
    _settingsView.frame = CGRectMake(
                                     (CGRectGetWidth(self.view.frame)-CGRectGetWidth(_settingsView.frame))/2,
                                     CGRectGetHeight(self.view.frame),
                                     CGRectGetWidth(_settingsView.frame),
                                     CGRectGetHeight(_settingsView.frame));
    [_backmaskView addSubview:_settingsView];
    
    [UIView animateWithDuration:0.2 animations:^{
        _settingsView.frame = CGRectOffset(_settingsView.frame, 0, -550);
        _backmaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    }];
}

@end
