//
//  LMPlayerControlView.m
//  lamiantv
//
//  Created by 李小南 on 2016/12/2.
//  Copyright © 2016年 AiPai. All rights reserved.
//

#import "LMPlayerControlView.h"
#import "MMMaterialDesignSpinner.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "LMPlayerStatusModel.h"

static const CGFloat LMPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat LMPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface LMPlayerControlView ()

@property (nonatomic, strong) UILabel  *titleLab;
/** 加载loading */
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
/** 快进快退View */
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress */
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间 */
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView */
@property (nonatomic, strong) UIImageView             *fastImageView;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *failBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** 观看记录View */
@property (nonatomic, strong) UIView                  *watchrRecordView;
/** 关闭观看记录按钮 */
@property (nonatomic, strong) UIButton                *closeWatchrRecordBtn;
/** 上次观看至00:00 */
@property (nonatomic, strong) UILabel                 *watchrRecordLabel;
/** 跳转播放 */
@property (nonatomic, strong) UIButton                *jumpPlayBtn;

/** 是否显示了控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 播放器的参数模型 */
@property (nonatomic, strong) LMPlayerStatusModel *playerStatusModel;
@end

@implementation LMPlayerControlView

+ (instancetype)playerControlViewWithStatusModel:(LMPlayerStatusModel *)playerStatusModel {
    LMPlayerControlView *instance = [[self alloc] init];
    instance.playerStatusModel = playerStatusModel;
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // 添加所有子控件
        [self addAllSubViews];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        self.landScapeControlView.hidden = YES;
        
        // 初始化时重置controlView
        [self playerResetControlView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
}

/**
 *  添加所有子控件
 */
- (void)addAllSubViews {
    [self addSubview:self.portraitControlView];
    [self addSubview:self.landScapeControlView];
    [self addSubview:self.activity];
    [self addSubview:self.repeatBtn];
    [self addSubview:self.failBtn];
    
    [self addSubview:self.fastView];
    [self.fastView addSubview:self.fastImageView];
    [self.fastView addSubview:self.fastTimeLabel];
    [self.fastView addSubview:self.fastProgressView];
    
    [self addSubview:self.watchrRecordView];
    [self.watchrRecordView addSubview:self.closeWatchrRecordBtn];
    [self.watchrRecordView addSubview:self.watchrRecordLabel];
    [self.watchrRecordView addSubview:self.jumpPlayBtn];
}

// 设置子控件的响应事件
- (void)makeSubViewsAction {
    [self.failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeWatchrRecordBtn addTarget:self action:@selector(closeWatchrRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.jumpPlayBtn addTarget:self action:@selector(jumpPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action

/** 播放失败按钮的点击 */
- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(failButtonClick)]) {
        [self.delegate failButtonClick];
    }
}

/** 重播按钮的点击 */
- (void)repeatBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(repeatButtonClick)]) {
        [self.delegate repeatButtonClick];
    }
}

/** 关闭播放记录按钮事件 */
- (void)closeWatchrRecordBtnClick:(UIButton *)sender {
    [self hideWatchrRecordView];
}

/** 跳转播放按钮事件 */
- (void)jumpPlayBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(jumpPlayButtonClick:)]) {
        [self.delegate jumpPlayButtonClick:self.viewTime];
    }
    [self hideWatchrRecordView];
}


#pragma mark - Private Method

/**
 *  显示控制层
 */
- (void)showControlView {
    if (self.playerStatusModel.isFullScreen) {
        // 横屏
        self.landScapeControlView.hidden = NO;
        self.portraitControlView.hidden = YES;
    } else {
        // 竖屏
        self.portraitControlView.hidden = NO;
        self.landScapeControlView.hidden = YES;
    }

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

/**
 *  隐藏控制层
 */
- (void)hideControlView {
    self.landScapeControlView.hidden = YES;
    self.portraitControlView.hidden = YES;
    if (self.playerStatusModel.isFullScreen && !self.playeEnd) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}

/**
 *  自动隐藏控制层
 */
- (void)autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControl) object:nil];
    [self performSelector:@selector(hideControl) withObject:nil afterDelay:LMPlayerAnimationTimeInterval];
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)playerCancelAutoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControl) object:nil];
}

#pragma mark - Public method
/** 初始化时重置controlView */
- (void)playerResetControlView {
    [self.portraitControlView playerResetControlView];
    [self.landScapeControlView playerResetControlView];
    
    self.fastView.hidden = YES;
    self.repeatBtn.hidden = YES;
    self.failBtn.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    self.showing = NO;
    self.playeEnd = NO;
//    self.dragged = NO;
    
    self.watchrRecordView.hidden = YES;
    self.viewTime = 0;
}

/** 切换分辨率时 - 重置控制层 */
- (void)playerResetControlViewForResolution {
    self.fastView.hidden        = YES;
    self.backgroundColor        = [UIColor clearColor];
    self.showing                = NO;
    self.failBtn.hidden         = YES;
    self.repeatBtn.hidden       = YES;
    
    self.watchrRecordView.hidden = YES;
    self.viewTime = 0;
}

/**
 *  开始准备播放
 */
- (void)startReadyToPlay {
    if (self.viewTime) {
        [self showWatchrRecordView:self.viewTime];
    }
    
    //#warning 可以考虑, 在这里才加载部分UI
    
    // 显示controlView
    [self showControl];
}

/** 显示状态栏 */
- (void)showStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
}

/** 显示控制层 */
- (void)showControl {
    if (self.isShowing) {
        [self hideControl];
        return;
    }
    [self playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:LMPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];
    }];
}

/** 隐藏控制层 */
- (void)hideControl {
    if (!self.isShowing) { return; }
    [self playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:LMPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    }completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

/** 强行设置是否显示了控制层 */
- (void)setIsShowing:(BOOL)showing {
    self.showing = showing;
}

/** 显示观看记录层 */
- (void)showWatchrRecordView:(NSInteger)viewTime {
    NSInteger proMin = viewTime / 60; // 秒
    NSInteger proSec = viewTime % 60; // 分钟
    self.watchrRecordLabel.text = [NSString stringWithFormat:@"上次观看至 %02zd:%02zd", proMin, proSec];
    self.watchrRecordView.hidden = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWatchrRecordView) object:nil];
    [self performSelector:@selector(hideWatchrRecordView) withObject:nil afterDelay:5.0];
}

/** 隐藏观看记录层 */
- (void)hideWatchrRecordView {
    self.watchrRecordView.hidden = YES;
    self.viewTime = 0;
}

/** 显示快进视图 */
- (void)showFastView:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd {
    [self.activity stopAnimating];
    
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    if (forawrd) {
        self.fastImageView.image = [UIImage imageNamed:@"ZFPlayer_fast_forward"];
    } else {
        self.fastImageView.image = [UIImage imageNamed:@"ZFPlayer_fast_forward"];
    }
    self.fastView.hidden           = NO;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;
}

/** 隐藏快进视图 */
- (void)hideFastView {
    self.fastView.hidden = YES;
}


/** 准备开始播放, 隐藏loading */
- (void)readyToPlay {
    [self.activity stopAnimating];
    self.failBtn.hidden = YES;
}

/** 加载失败, 显示加载失败按钮 */
- (void)loadFailed {
    [self.activity stopAnimating];
    self.failBtn.hidden = NO;
}

/** 开始loading */
- (void)loading {
    [self.activity startAnimating];
    self.failBtn.hidden = YES;
    self.fastView.hidden = YES;
    
//#warning 有问题, 可能重播播放的是本地文件, 就不会loading(待优化)
    self.playeEnd = NO;
}

/** 播放完了, 显示重播按钮 */
- (void)playDidEnd {
    [self.activity stopAnimating];
    self.failBtn.hidden = YES;
    self.repeatBtn.hidden = NO;
    
    self.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self playEndHideControlView];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

/**
 *  播放完成时隐藏控制层
 */
- (void)playEndHideControlView {
    if (self.playerStatusModel.isFullScreen) {
        // 横屏
        self.portraitControlView.hidden = YES;
        self.landScapeControlView.hidden = NO;
        
        [self.landScapeControlView playEndHideView:self.playeEnd];
    } else {
        // 竖屏
        self.landScapeControlView.hidden = YES;
        self.portraitControlView.hidden = NO;
        
        [self.portraitControlView playEndHideView:self.playeEnd];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - 添加子控件的约束
/**
 *  添加子控件的约束
 */
- (void)makeSubViewsConstraints {
    
    [self.portraitControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
    
    [self.landScapeControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(45);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(33);
    }];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];
    
    [self.watchrRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(260);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self.watchrRecordLabel.mas_right).offset(80);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-50);
    }];
    
    [self.closeWatchrRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(30);
        make.height.mas_offset(30);
        make.top.left.mas_equalTo(self.watchrRecordView);
    }];
    
    [self.watchrRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.closeWatchrRecordBtn.mas_right);
        make.top.height.mas_equalTo(self.watchrRecordView);
//        make.width.mas_equalTo(140); // ?
    }];
    
    [self.jumpPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.watchrRecordLabel.mas_trailing).offset(3);
        make.trailing.top.height.mas_equalTo(self.watchrRecordView);
    }];
}

#pragma mark - getter

- (LMPortraitControlView *)portraitControlView {
    if (!_portraitControlView) {
        _portraitControlView = [[LMPortraitControlView alloc] init];
    }
    return _portraitControlView;
}

- (LMLandScapeControlView *)landScapeControlView {
    if (!_landScapeControlView) {
        _landScapeControlView = [[LMLandScapeControlView alloc] init];
    }
    return _landScapeControlView;
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

- (UIView *)fastView {
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor whiteColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
//        _failBtn.backgroundColor = [UIColor redColor];
    }
    return _failBtn;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:[UIImage imageNamed:@"ZFPlayer_repeat_video"] forState:UIControlStateNormal];
    }
    return _repeatBtn;
}

- (UIView *)watchrRecordView {
    if (!_watchrRecordView) {
        _watchrRecordView                     = [[UIView alloc] init];
        _watchrRecordView.backgroundColor     = [UIColor colorWithHexString:@"000000" alpha:0.8];
        _watchrRecordView.layer.cornerRadius  = 2;
        _watchrRecordView.layer.masksToBounds = YES;
    }
    return _watchrRecordView;
}

- (UIButton *)closeWatchrRecordBtn {
    if (!_closeWatchrRecordBtn) {
        _closeWatchrRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeWatchrRecordBtn setImage:[UIImage imageNamed:@"btn_关闭"] forState:UIControlStateNormal];
    }
    return _closeWatchrRecordBtn;
}

- (UILabel *)watchrRecordLabel {
    if (!_watchrRecordLabel) {
        _watchrRecordLabel               = [[UILabel alloc] init];
        _watchrRecordLabel.text          = @"上次观看至88:00";
        _watchrRecordLabel.textColor     = [UIColor whiteColor];
        _watchrRecordLabel.textAlignment = NSTextAlignmentCenter;
        _watchrRecordLabel.font          = [UIFont systemFontOfSize:16.0];
    }
    return _watchrRecordLabel;
}

- (UIButton *)jumpPlayBtn {
    if (!_jumpPlayBtn) {
        _jumpPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpPlayBtn setTitle:@"跳转播放" forState:UIControlStateNormal];
        [_jumpPlayBtn setTitleColor:[UIColor colorWithHexString:@"#ed341c"] forState:UIControlStateNormal];
        _jumpPlayBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _jumpPlayBtn;
}


@end
