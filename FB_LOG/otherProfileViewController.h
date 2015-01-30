//
//  otherProfileViewController.h
//  FB_LOG
//
//  Created by Earther on 11/12/2013.
//  Copyright (c) 2013 Patipat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface otherProfileViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property NSString *uid;


@end
