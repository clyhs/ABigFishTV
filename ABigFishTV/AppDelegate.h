//
//  AppDelegate.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABFUserInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*
 决定是不是可以允许转屏的参数
 */
@property(nonatomic,assign)BOOL allowRotation;
/*
 当前的网络状态
 */
@property(nonatomic,assign)int netWorkStatesCode;


@property (strong, nonatomic)  ABFUserInfo *user;

@property (strong, nonatomic)  NSString    *area;

@property (strong, nonatomic)  NSString    *postcode;

+(AppDelegate*)APP;

@end

