//
//  ABFPhotoViewController.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFChatInfo;

@interface ABFPhotoViewController : UIViewController

@property(nonatomic,strong) ABFChatInfo *model;
@property(nonatomic,assign) NSInteger   index;

@end
