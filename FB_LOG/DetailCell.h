//
//  DetailCell.h
//  FB_LOG
//
//  Created by Patipat on 11/5/2556 BE.
//  Copyright (c) 2556 Patipat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *l2;
@property (weak, nonatomic) IBOutlet UIButton *nameBL;
@property (weak, nonatomic) IBOutlet UIButton *btownpic;
@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *like;
@property (weak, nonatomic) IBOutlet UIImageView *ownerpic;
- (IBAction)nameB:(id)sender;
@end
