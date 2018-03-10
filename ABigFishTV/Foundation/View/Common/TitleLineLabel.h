//
//  TitleLineLabel.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/27.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleLineLabel : UILabel

@property(nonatomic,assign) CGFloat scale;

@property(nonatomic,weak) UIImageView *iconView;

@property(nonatomic,weak)   UIView  *bottomLine;

@property(nonatomic) UIEdgeInsets insets;

-(void)setIconViewImage:(NSString *)imageName;

@end
