//
//  ASNSettingsView.m
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import "ASNSettingsView.h"

@implementation ASNSettingsView

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    // default Settings
    self.sortSettings = ASNSettingsSortName;
    self.filterSettings = 0x7;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            UITableViewCell *tappedCell = [tableView cellForRowAtIndexPath:indexPath];
            if (indexPath.row == ASNSettingsSortName) {
                tappedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                NSIndexPath *otherIndexPath = [NSIndexPath indexPathForItem:ASNSettingsSortPublishedDate inSection:0];
                UITableViewCell *otherCell = [tableView cellForRowAtIndexPath:otherIndexPath];
                otherCell.accessoryType = UITableViewCellAccessoryNone;
                self.sortSettings = ASNSettingsSortName;
            } else if (indexPath.row == ASNSettingsSortPublishedDate) {
                tappedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                NSIndexPath *otherIndexPath = [NSIndexPath indexPathForItem:ASNSettingsSortName inSection:0];
                UITableViewCell *otherCell = [tableView cellForRowAtIndexPath:otherIndexPath];
                otherCell.accessoryType = UITableViewCellAccessoryNone;
                self.sortSettings = ASNSettingsSortPublishedDate;
            }
            break;
        }
        case 1: {
            UITableViewCell *tappedCell = [tableView cellForRowAtIndexPath:indexPath];
            switch (indexPath.row) {
                case 0: {
                    if (self.filterSettings & ASNSettingsFilterMovie) {
                        self.filterSettings = self.filterSettings & 0x6;
                        tappedCell.accessoryType = UITableViewCellAccessoryNone;
                    } else {
                        self.filterSettings = self.filterSettings | ASNSettingsFilterMovie;
                        tappedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                }
                case 1: {
                    if (self.filterSettings & ASNSettingsFilterSeries) {
                        self.filterSettings = self.filterSettings & 0x5;
                        tappedCell.accessoryType = UITableViewCellAccessoryNone;
                    } else {
                        self.filterSettings = self.filterSettings | ASNSettingsFilterSeries;
                        tappedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                }
                case 2: {
                    if (self.filterSettings & ASNSettingsFilterEpisode) {
                        self.filterSettings = self.filterSettings & 0x3;
                        tappedCell.accessoryType = UITableViewCellAccessoryNone;
                    } else {
                        self.filterSettings = self.filterSettings | ASNSettingsFilterEpisode;
                        tappedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Sort";
            break;
        case 1:
            return @"Filter";
            break;
        default:
            break;
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *settingsCell;
    switch (indexPath.section) {
        case 0: {
            settingsCell = [tableView dequeueReusableCellWithIdentifier:@"ASNSettingsSortTableViewCell"];
            UILabel *sortLabel = (UILabel *)[settingsCell viewWithTag:1];
            if (indexPath.row == self.sortSettings) {
                settingsCell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                settingsCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            switch (indexPath.row) {
                case ASNSettingsSortName:
                    sortLabel.text = @"Ordered By Name";
                    break;
                case ASNSettingsSortPublishedDate:
                    sortLabel.text = @"Ordered By Published Date";
                    break;
                default:
                    break;
            }
            break;
        }
        case 1: {
            settingsCell = [tableView dequeueReusableCellWithIdentifier:@"ASNSettingsFilterTableViewCell"];
            UILabel *filterLabel = (UILabel *)[settingsCell viewWithTag:1];
            switch (indexPath.row) {
                case 0: {
                    filterLabel.text = @"Movie";
                    if (self.filterSettings & ASNSettingsFilterMovie) {
                        settingsCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    } else {
                        settingsCell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                }
                case 1: {
                    filterLabel.text = @"Series";
                    if (self.filterSettings & ASNSettingsFilterSeries) {
                        settingsCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    } else {
                        settingsCell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                }
                case 2: {
                    filterLabel.text = @"Episode";
                    if (self.filterSettings & ASNSettingsFilterEpisode) {
                        settingsCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    } else {
                        settingsCell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return settingsCell;
}

#pragma mark - IBAction

- (IBAction)tappedDone:(id)sender
{
    [self.delegate didTappedDoneButton:self];
}

@end
