//
//  ASNDetailViewController.h
//  ASNFindMovie
//
//  Created by AsanoYuki on 2015/03/26.
//  Copyright (c) 2015年 AsanoYuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ASNDetailViewController : UIViewController<MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *productId;

@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextView *productPlot;
@property (weak, nonatomic) IBOutlet UITableView *tweetTable;

- (IBAction)tappedSendEmail:(id)sender;

@end
