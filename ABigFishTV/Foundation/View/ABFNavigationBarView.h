//
//  ABFNavigationBarView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/10.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFNavigationBarView : UIView

//@property(nonatomic,strong)  UIColor *backgroundColor;

@property (weak, nonatomic) UIButton *backBtn;

@property(nonatomic,assign)  CGFloat backgroundAlpha;

@property(nonatomic,strong)  NSString *title;

@property(nonatomic,strong)  NSString *leftBtnImageName;

@property(nonatomic,copy)    void (^navBackHandle)(void);


@end
