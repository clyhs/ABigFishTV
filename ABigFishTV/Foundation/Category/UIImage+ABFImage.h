//
//  UIImage+ABFImage.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/12.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ABFImage)

- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height;

/**
 *  用color生成image
 *
 *  @param color 颜色
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/**
 *  改变image透明度
 *
 *  @param alpha 透明度
 */
- (UIImage *)imageWithAlpha:(CGFloat)alpha;


@end
