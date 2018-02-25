//
//  LMBrightnessView.h
//  拉面视频Demo
//
//  Created by 李小南 on 16/9/1.
//  Copyright © 2016年 lamiantv. All rights reserved.
//  亮度改变时显示的View

#import <UIKit/UIKit.h>
// 把单例方法定义为宏，使用起来更方便
#define LMBrightnessViewShared [LMBrightnessView sharedBrightnessView]
@interface LMBrightnessView : UIView
+ (instancetype)sharedBrightnessView;


/*--------------------单例记录播放器状态--------------------*/
/** 调用单例记录播放状态是否锁定屏幕方向*/
@property (nonatomic, assign) BOOL isLockScreen;
/** 是否开始过播放 */
@property (nonatomic, assign) BOOL isStartPlay;
@end
