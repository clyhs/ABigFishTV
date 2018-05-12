//
//  UMErrorCatch.h
//  UMBreakpad
//
//  Created by 张军华 on 2017/6/22.
//  Copyright © 2017年 张军华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMErrorCatch : NSObject

//初始化native层的崩溃监控
//@note 在调试模式下，initErrorCatch函数不起作用
+(void) initErrorCatch;

//停止native层监控
+(void)stopErrorCatch;

@end
