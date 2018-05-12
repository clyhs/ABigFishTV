//
//  ABFPlayerViewController.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/2.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFTelevisionInfo;

@interface ABFPlayerViewController : UIViewController
/*
 视频播放器的播放地址
 */
@property(nonatomic,copy) NSString            *playUrl;

@property(nonatomic,copy) NSString            *tvTitle;

@property(nonatomic,strong) ABFTelevisionInfo *model;

@property(nonatomic,assign) NSInteger         uid;

@end
