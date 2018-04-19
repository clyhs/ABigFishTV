//
//  ABFPlayerModel.h
//  ABigFishPlayer
//
//  Created by 陈立宇 on 2018/3/24.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ABFPlayerModel : NSObject

/** 视频标题 */
@property(nonatomic,copy)     NSString     *title;
/** 当前播放的视频URL */
@property(nonatomic,strong)   NSURL        *currentVideoUrl;
/** 视频封面本地图片 */
@property (nonatomic, strong) UIImage      *placeholderImage;

/**
 * 视频封面网络图片url
 * 如果和本地图片同时设置，则忽略本地图片，显示网络图片
 */
@property (nonatomic, copy  ) NSString     *placeholderImageURLString;

/** 播放器View的父视图（必须指定父视图）*/
@property (nonatomic, weak  ) UIView       *fatherView;

@property (nonatomic,strong ) NSArray      *urlArrays;

@end
