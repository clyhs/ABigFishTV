//
//  ABFPlayerKit.h
//  ABigFishPlayer
//
//  Created by 陈立宇 on 2018/3/24.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#ifndef ABFPlayerKit_h
#define ABFPlayerKit_h

// 屏幕的宽
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

#define ABFPlayerShared                      [ABFBrightnessView sharedBrightnessView]

// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define ABFPlayerOrientationIsLandscape      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#define ABFPlayerOrientationIsPortrait       UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)
#define COMMON_COLOR RGBA(23, 158, 246,1)

#import <Masonry/Masonry.h>
#import "ABFPlayerModel.h"
#import "ABFPlayerControlViewDelegate.h"
#import "ABFBrightnessView.h"
#import "UIViewController+ABFPlayerRotation.h"
#import "UIAlertController+ABFPlayerRotation.h"
#import "UITabBarController+ABFPlayerRotation.h"
#import "UINavigationController+ABFPlayerRotation.h"


#endif /* ABFPlayerKit_h */
