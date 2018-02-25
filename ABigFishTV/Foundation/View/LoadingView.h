//
//  LoadingView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/28.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property(nonatomic,weak) UILabel *titleLabel;

@property(nonatomic,assign) UIEdgeInsets edgeInset;


+(void)showLoadingView:(UIView*) view;

+(void)showLoadingView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset;

-(void)showView:(UIView *)view;

//-(void)hide;

@end
