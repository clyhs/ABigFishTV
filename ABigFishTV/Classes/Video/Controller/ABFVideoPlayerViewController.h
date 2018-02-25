//
//  ABFVideoPlayerViewController.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/10.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABFVideoInfo.h"

@interface ABFVideoPlayerViewController : UIViewController

/*
 视频播放器的播放地址
 */
@property(nonatomic,copy) NSString *playUrl;

@property(nonatomic,copy) NSString *tvTitle;

@property(nonatomic,assign) NSInteger uid;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) ABFVideoInfo *model;

@end
