//
//  FeedDetailViewController.h
//  FB_LOG
//
//  Created by Earther on 11/12/2013.
//  Copyright (c) 2013 Patipat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
@interface FeedDetailViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property Group *data;
@property (weak, nonatomic) IBOutlet UIImageView *thumnail;
@property (weak, nonatomic) IBOutlet UIButton *lbOwner;
@property (weak, nonatomic) IBOutlet UIButton *lbLike;
@property (weak, nonatomic) IBOutlet UILabel *lbUptime;
@property (weak, nonatomic) IBOutlet UILabel *lbhlike;
- (IBAction)likefeed:(id)sender;
- (IBAction)commentgo:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UITextField *commenttext;
@property (weak, nonatomic) IBOutlet UITableView *tbView;

@end
