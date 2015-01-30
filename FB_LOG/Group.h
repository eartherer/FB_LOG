//
//  Group.h
//  FB_LOG
//
//  Created by Patipat on 11/5/2556 BE.
//  Copyright (c) 2556 Patipat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject
@property (strong,nonatomic) NSString *imgno;
@property (strong, nonatomic) NSString *ownerid;
@property (strong, nonatomic) NSString *ownerpicpath;
@property (strong,nonatomic) NSString *name;
@property (strong, nonatomic) NSString *likecount;
@property (strong, nonatomic) NSString *commentcount;
@property (strong, nonatomic) NSString *imgpath;
@property (strong,nonatomic) NSString *timeupload;
@property (strong,nonatomic) NSString *imgpath_b;
@property (strong,nonatomic) NSString *caption;
@end
