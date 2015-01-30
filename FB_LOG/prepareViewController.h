//
//  prepareViewController.h
//  FB_LOG
//
//  Created by Earther on 10/12/2013.
//  Copyright (c) 2013 Patipat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
@interface prepareViewController : UIViewController<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *like;
- (IBAction)exit:(id)sender;
- (IBAction)replay:(id)sender;
@property Group *data;
@end
