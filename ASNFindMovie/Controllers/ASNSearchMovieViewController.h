//
//  ASNSearchMovieViewController.h
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASNSettingsView.h"

@interface ASNSearchMovieViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ASNSettingsViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *moviesTable;

- (IBAction)tappedSettingsButton:(id)sender;

@end
