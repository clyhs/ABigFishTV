//
//  ABFChatToolBar.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/26.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFChatToolBar.h"

@implementation ABFChatToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 添加所有子控件
        [self setUpAllChildView];
        
    }
    return self;
}

#pragma mark - 添加所有子控件
- (void)setUpAllChildView
{
    // 相册
    [self setUpButtonWithImage:[UIImage imageNamed:@"compose_toolbar_picture"] highImage:[UIImage imageNamed:@"compose_toolbar_picture"] target:self action:@selector(btnClick:)];
    // 提及
    [self setUpButtonWithImage:[UIImage imageNamed:@"compose_camerabutton_background"] highImage:[UIImage imageNamed:@"compose_camerabutton_background"] target:self action:@selector(btnClick:)];
    // 话题
    [self setUpButtonWithImage:[UIImage imageNamed:@"compose_mentionbutton_background"] highImage:[UIImage imageNamed:@"compose_mentionbutton_background"] target:self action:@selector(btnClick:)];
    // 表情
    [self setUpButtonWithImage:[UIImage imageNamed:@"compose_trendbutton_background"] highImage:[UIImage imageNamed:@"compose_trendbutton_background"] target:self action:@selector(btnClick:)];
    // 键盘]
    [self setUpButtonWithImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] highImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] target:self action:@selector(btnClick:)];
    
    
}

- (void)setUpButtonWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    // btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    
    btn.selected = NO;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.tag = self.subviews.count;
    
    [self addSubview:btn];
}

- (void)btnClick:(UIButton *)button
{
    
    // 点击工具条的时候
    if(button.tag == 4){
        [button setImage:[UIImage imageNamed:@"btn_keyboard"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateSelected];
        button.selected = !button.selected;
        
    }
    if ([_delegate respondsToSelector:@selector(chatToolBar:didClickBtn:)]) {
        [_delegate chatToolBar:self didClickBtn:button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    CGFloat w = self.width / count;
    CGFloat h = self.height;
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0 ; i < count; i++) {
        UIButton *btn = self.subviews[i];
        x = i * w;
        btn.frame = CGRectMake(x, y, w, h);
    }
    
}


@end
