//
//  ASNSettingsView.h
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import <UIKit/UIKit.h>

// sort
typedef NS_ENUM(NSInteger, ASNSettingsSort) {
    ASNSettingsSortName = 0,
    ASNSettingsSortPublishedDate
};

// filter
typedef NS_OPTIONS(NSUInteger, ASNSettingsFilter) {
    ASNSettingsFilterNone = 0,
    ASNSettingsFilterMovie = 1 << 0,
    ASNSettingsFilterSeries = 1 << 1,
    ASNSettingsFilterEpisode = 1 << 2,
};

@class ASNSettingsView;

@protocol ASNSettingsViewDelegate <NSObject>

- (void)didTappedDoneButton:(ASNSettingsView *)settingsView;

@end

@interface ASNSettingsView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *settingsTable;

@property (nonatomic) ASNSettingsSort sortSettings;
@property (nonatomic) ASNSettingsFilter filterSettings;

@property (nonatomic, weak) id<ASNSettingsViewDelegate> delegate;

- (IBAction)tappedDone:(id)sender;

@end
