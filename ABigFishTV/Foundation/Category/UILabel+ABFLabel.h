//
//  UILabel+ABFLabel.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/7.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ABFLabel)

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

//2.设置：字间距
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

//3.设置：行间距 与 字间距
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

+ (CGFloat)getChangeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

+ (CGFloat)getHeightByWidthForSpace:(CGFloat)width string:(NSString *)string font:(UIFont*)font withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


@end
