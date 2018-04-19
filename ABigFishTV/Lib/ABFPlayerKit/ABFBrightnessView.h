//
//  ABFBrightnessView.h
//  ABigFishPlayer
//
//  Created by 陈立宇 on 2018/3/24.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFBrightnessView : UIView

/** 调用单例记录播放状态是否锁定屏幕方向*/
@property (nonatomic, assign) BOOL     isLockScreen;
/** 是否允许横屏,来控制只有竖屏的状态*/
@property (nonatomic, assign) BOOL     isAllowLandscape;

+ (instancetype)sharedBrightnessView;

@end
