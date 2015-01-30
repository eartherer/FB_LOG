//
//  SLideViewController.h
//  FB_LOG
//
//  Created by Patipat on 11/5/2556 BE.
//  Copyright (c) 2556 Patipat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *window;
@property (weak, nonatomic) IBOutlet UIProgressView *progressline;
- (IBAction)refreshfeed:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
