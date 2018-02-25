//
//  LMLoadingView.m
//  拉面视频Demo
//
//  Created by 李小南 on 2016/10/12.
//  Copyright © 2016年 lamiantv. All rights reserved.
//

#import "LMLoadingView.h"
#import "MMMaterialDesignSpinner.h"

#import <Masonry.h>

@interface LMLoadingView ()
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;
/** 分享按钮 */
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
@end

@implementation LMLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.activity];
        
        [self makeSubViewsConstraints];
        
        self.backgroundColor = [UIColor blackColor];
        
        // 拦截手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection)];
        [self addGestureRecognizer:panRecognizer];
        
        [self.activity startAnimating];
        [self makeSubViewsAction];
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action
- (void)tapAction {}
- (void)doubleTapAction {}
- (void)panDirection {}
- (void)backBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(loadingViewBackButtonClick)]) {
        [self.delegate loadingViewBackButtonClick];
    }
}

- (void)shareBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(loadingViewShareButtonClick)]) {
        [self.delegate loadingViewShareButtonClick];
    }
}

#pragma mark - 添加子控件约束
- (void)makeSubViewsConstraints {
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(52);
        make.height.offset(42);
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.mas_left).offset(5);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(52);
        make.height.offset(42);
        make.top.equalTo(self.mas_top).offset(2);
        make.trailing.equalTo(self.mas_trailing).offset(-5);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(45);
    }];
}


#pragma mark - getter
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"btn_播放页_返回"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"btn_播放页_分享"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

- (MMMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}
@end
