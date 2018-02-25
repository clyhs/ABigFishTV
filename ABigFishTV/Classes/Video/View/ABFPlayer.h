//
//  ABFPlayer.h
//  ijkplayerDemo
//
//  Created by 陈立宇 on 17/12/13.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#ifndef ABFPlayer_h
#define ABFPlayer_h



#endif /* ABFPlayer_h */

#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 监听TableView的contentOffset
#define kZFPlayerViewContentOffset          @"contentOffset"
// player的单例
#define ZFPlayerShared                      [ZFBrightnessView sharedBrightnessView]
// 屏幕的宽
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 图片路径
#define ZFPlayerSrcName(file)               [@"ZFPlayer.bundle" stringByAppendingPathComponent:file]

#define ZFPlayerFrameworkSrcName(file)      [@"Frameworks/ZFPlayer.framework/ZFPlayer.bundle" stringByAppendingPathComponent:file]

#define ZFPlayerImage(file)                 [UIImage imageNamed:ZFPlayerSrcName(file)] ? :[UIImage imageNamed:ZFPlayerFrameworkSrcName(file)]

#define ZFPlayerOrientationIsLandscape      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#define ZFPlayerOrientationIsPortrait       UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)

#import "ABFPlayerView.h"
#import "ZFPlayerModel.h"
#import "ZFPlayerControlView.h"
#import "ZFBrightnessView.h"
#import "UITabBarController+ZFPlayerRotation.h"
#import "UIViewController+ZFPlayerRotation.h"
#import "UINavigationController+ZFPlayerRotation.h"
#import "UIImageView+ZFCache.h"
#import "ZFPlayerControlViewDelegate.h"
#import <Masonry/Masonry.h>
