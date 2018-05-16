//
//  NSString+ABF.h
//  ABigFishTV
//
//  Created by 陈立宇 on 2018/5/16.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ABF)

+ (NSString *)sendOnjectReturnEMJString:(NSString *)obj;

+ (NSString*)replaceEmoji:(NSString *)str;

+ (NSString *)sendEMJStringReturnstring:(NSString *)obj;

+ (NSString *)chage:(NSString *)obj;

+ (BOOL)stringContainsEmoji:(NSString *)string;
@end
