//
//  ViewController.h
//  FB_LOG
//
//  Created by Patipat on 10/29/2556 BE.
//  Copyright (c) 2556 Patipat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *weblabel;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)refreshprofile:(id)sender;
@property NSString *uid;
@end
