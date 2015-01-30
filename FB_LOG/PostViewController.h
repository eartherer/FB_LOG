//
//  PostViewController.h
//  FB_LOG
//
//  Created by Patipat on 12/6/2556 BE.
//  Copyright (c) 2556 Patipat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgg;
- (IBAction)upload:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *testl;
@property (weak, nonatomic) IBOutlet UITextField *cap;
- (IBAction)callActionSheet:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btupload;
@property (weak, nonatomic) IBOutlet UILabel *counter;


@end
