//
//  ASNMovieTableViewCell.h
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASNMovieTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *productId;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedYearLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIButton *favButton;

- (IBAction)tappedFavButton:(id)sender;

@end
