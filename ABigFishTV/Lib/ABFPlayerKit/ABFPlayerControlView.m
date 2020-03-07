//
//  ABFPlayerControlView.m
//  ABigFishPlayer
//
//  Created by 陈立宇 on 2018/3/24.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "ABFPlayerControlView.h"
#import "MMMaterialDesignSpinner/MMMaterialDesignSpinner.h"
#import <UIImageView+WebCache.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

static const CGFloat ABFPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat ABFPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface ABFPlayerControlView()<ABFPlayerControlViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)  UIImageView *topImageView;
@property(nonatomic,strong)  UIImageView *botImageView;
@property(nonatomic,strong)  UIImageView *placeholderImageView;

/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;

@property (nonatomic, strong) UIButton                *backBtn;

@property (nonatomic, strong) ABFPlayerModel          *playerModel;

/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton                *lockBtn;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton                *closeBtn;
/** 快进快退View*/
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress*/
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间*/
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView*/
@property (nonatomic, strong) UIImageView             *fastImageView;
/** 系统菊花 */
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *failBtn;

@property (nonatomic, strong) UIButton                *menuBtn;

@property (nonatomic, strong) UIView                  *menuView;

@property (nonatomic,strong)  NSMutableArray          *menusLab;

@property (nonatomic,assign)  NSInteger               menuIndex;
/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 小屏播放 */
@property (nonatomic, assign, getter=isShrink ) BOOL  shrink;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 是否全屏播放 */
@property (nonatomic, assign,getter=isFullScreen)BOOL fullScreen;

@end

@implementation ABFPlayerControlView

-(instancetype)init{
    self = [super init];
    if(self){
        _menusLab = [NSMutableArray new];
        _menuIndex = 0;
        [self addSubview:self.placeholderImageView];
        [self addSubview:self.topImageView];
        [self addSubview:self.botImageView];
        
        [self.botImageView addSubview:self.startBtn];
        [self.topImageView addSubview:self.backBtn];
        [self.topImageView addSubview:self.titleLabel];
        
        
        [self.botImageView addSubview:self.currentTimeLabel];
        [self.botImageView addSubview:self.progressView];
        [self.botImageView addSubview:self.videoSlider];
        [self.botImageView addSubview:self.totalTimeLabel];
        [self.botImageView addSubview:self.fullScreenBtn];
    
        [self addSubview:self.lockBtn];
        [self addSubview:self.closeBtn];
        
        [self addSubview:self.fastView];
        [self.fastView addSubview:self.fastImageView];
        [self.fastView addSubview:self.fastTimeLabel];
        [self.fastView addSubview:self.fastProgressView];
        
        [self addSubview:self.activity];
        [self addSubview:self.repeatBtn];
        [self addSubview:self.failBtn];
        
        [self.topImageView addSubview:self.menuBtn];
        [self addSubview:self.menuView];
        
        [self makeSubViewsConstraints];
        
        [self abf_playerResetControlView];
        
        [self install];
    }
    return self;
}


- (void)makeSubViewsConstraints {
    [self layoutIfNeeded];
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.botImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.top.equalTo(self.topImageView.mas_top).offset(3);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(5);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.right.equalTo(self.topImageView.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.botImageView.mas_leading).offset(5);
        make.bottom.equalTo(self.botImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing).offset(-3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.botImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
    
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(32);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(7);
        make.top.equalTo(self.mas_top).offset(-7);
        make.width.height.mas_equalTo(20);
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
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.trailing.equalTo(self.topImageView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(self);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
}


- (void)install{
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(onDeviceOrientationChange)
        name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    if (ABFPlayerShared.isLockScreen) { return; }
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    
    if (ABFPlayerOrientationIsLandscape) {
        [self setOrientationLandscapeConstraint];
    } else {
        [self setOrientationPortraitConstraint];
    }
    [self layoutIfNeeded];
}

- (void)setOrientationLandscapeConstraint {
    //if (self.isCellVideo) {
        //self.shrink             = NO;
    //}
    self.fullScreen             = YES;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    [self.backBtn setImage:[UIImage imageNamed:@"ABFPlayer_back_full"] forState:UIControlStateNormal];
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_top).offset(23);
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.width.height.mas_equalTo(40);
    }];
}
/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    self.fullScreen             = NO;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_top).offset(3);
        make.leading.equalTo(self.topImageView.mas_leading).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    //if (self.isCellVideo) {
        //[self.backBtn setImage:ZFPlayerImage(@"ZFPlayer_close") forState:UIControlStateNormal];
    //}
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    [self abf_playerCancelAutoFadeOutControlView];
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    if (!self.isShrink) { [self abf_playerShowControlView]; }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // [self abf_playerCancelAutoFadeOutControlView];
    [self autoFadeOutControlView];
    if (!self.isShrink && !self.isPlayEnd) {
        // 只要屏幕旋转就显示控制层
        // [self abf_playerShowControlView];
    }
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
}

#pragma mark - Private Method

- (void)showControlView {
    if (self.lockBtn.isSelected) {
        self.topImageView.alpha    = 0;
        self.botImageView.alpha = 0;
    } else {
        self.topImageView.alpha    = 1;
        self.botImageView.alpha = 1;
    }
    self.backgroundColor           = RGBA(0, 0, 0, 0.3);
    self.lockBtn.alpha             = 1;
    self.shrink                    = NO;
    self.menuView.alpha = 0;
    //self.bottomProgressView.alpha  = 0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)hideControlView {
    self.backgroundColor          = RGBA(0, 0, 0, 0);
    self.topImageView.alpha       = self.playeEnd;
    self.botImageView.alpha    = 0;
    self.lockBtn.alpha            = 0;
    /*
    if(self.bottomProgressHidden){
        self.bottomProgressView.alpha = 0;
    }else{
        self.bottomProgressView.alpha = 1;
    }*/
    
    
    //self.menuView.alpha = 0;
    //self.typeView.alpha = 0;
    // 隐藏resolutionView
    //self.resolutionBtn.selected = YES;
    //[self resolutionBtnClick:self.resolutionBtn];
    if (self.isFullScreen && !self.playeEnd) { [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade]; }
}

/**
 *  显示控制层
 */
- (void)abf_playerShowControlView {
    if (self.isShowing) {
        [self abf_playerHideControlView];
        return;
    }
    [self abf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ABFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];
    }];
}

/**
 *  隐藏控制层
 */
- (void)abf_playerHideControlView {
    if (!self.isShowing) { return; }
    [self abf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ABFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    }completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)abf_playerCancelAutoFadeOutControlView {
    self.showing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (void)autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(abf_playerHideControlView) object:nil];
    [self performSelector:@selector(abf_playerHideControlView) withObject:nil afterDelay:ABFPlayerAnimationTimeInterval];
}

/** 重置ControlView */
- (void)abf_playerResetControlView {
    [self.activity stopAnimating];
    self.videoSlider.value           = 0;
    self.startBtn.selected           = YES;
    //self.bottomProgressView.progress = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.fastView.hidden             = YES;
    self.repeatBtn.hidden            = YES;
    //self.playeBtn.hidden             = YES;
    //self.resolutionView.hidden       = YES;
    self.failBtn.hidden              = YES;
    self.backgroundColor             = [UIColor clearColor];
    //self.downLoadBtn.enabled         = YES;
    self.shrink                      = NO;
    self.closeBtn.hidden             = YES;
    self.showing                     = NO;
    self.playeEnd                    = NO;
    self.lockBtn.hidden              = !self.isFullScreen;
    self.menuView.alpha = 0;
    //self.failBtn.hidden              = YES;
    self.placeholderImageView.alpha  = 1;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image                  =[UIImage imageNamed:@"ABFPlayer_top_shadow"];
    }
    return _topImageView;
}

- (UIImageView *)botImageView {
    if (!_botImageView) {
        _botImageView                        = [[UIImageView alloc] init];
        _botImageView.userInteractionEnabled = YES;
        _botImageView.image                  =[UIImage imageNamed:@"ABFPlayer_bottom_shadow"];
    }
    return _botImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"ABFPlayer_back_full"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage imageNamed:@"ABFPlayer_play"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"ABFPlayer_pause"] forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (ASValueTrackingSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
        _videoSlider.popUpViewArrowLength = 8;
        
        [_videoSlider setThumbImage:[UIImage imageNamed:@"ABFPlayer_slider"] forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"ABFPlayer_fullscreen"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"ABFPlayer_shrinkscreen"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:[UIImage imageNamed:@"ABFPlayer_unlock-nor"] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage imageNamed:@"ABFPlayer_lock-nor"] forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lockBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"ABFPlayer_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = RGBA(0, 0, 0, 0.8);
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

- (MMMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
    
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:[UIImage imageNamed:@"ABFPlayer_repeat_video"] forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatBtn;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failBtn;
}


- (UIButton *)menuBtn {
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setImage:[UIImage imageNamed:@"ABFPlayer_channel"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}

-(UIView *)menuView{
    if(!_menuView){
        _menuView = [[UIView alloc] init];
        _menuView.backgroundColor = RGBA(0, 0, 0, 7);
    }
    return _menuView;
}

- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.userInteractionEnabled = YES;
        [_placeholderImageView setImage:[UIImage imageNamed:@"ABFPlayer_loading_bgView"]];
    }
    return _placeholderImageView;
}

-(void)menuLabelClick:(id)sender{
    NSLog(@"menu select");
    if ([self.delegate respondsToSelector:@selector(abf_controlView:menulabAction:)]) {
        [self.delegate abf_controlView:self menulabAction:sender];
    }
}

- (void)menuBtnClick:(UIButton *)sender {
    /*
    if(sender.selected){
        self.menuView.alpha = 1;
    }*/
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(abf_controlView:menuAction:)]) {
        [self.delegate abf_controlView:self menuAction:sender];
    }
}



- (void)repeatBtnClick:(UIButton *)sender {
    // 重置控制层View
    [self abf_playerResetControlView];
    [self abf_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(abf_controlView:repeatPlayAction:)]) {
        [self.delegate abf_controlView:self repeatPlayAction:sender];
    }
}

- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(abf_controlView:failAction:)]) {
        [self.delegate abf_controlView:self failAction:sender];
    }
}

-(void)backBtnClick:(UIButton *)sender{
    // 状态条的方向旋转的方向,来判断当前屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 在cell上并且是竖屏时候响应关闭事件
    if (orientation == UIInterfaceOrientationPortrait && self.isShrink) {
        if ([self.delegate respondsToSelector:@selector(abf_controlView:closeAction:)]) {
            [self.delegate abf_controlView:self closeAction:sender];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(abf_controlView:backAction:)]) {
            [self.delegate abf_controlView:self backAction:sender];
        }
    }
}

-(void)playBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(abf_controlView:playAction:)]) {
        [self.delegate abf_controlView:self playAction:sender];
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(abf_controlView:fullScreenAction:)]) {
        [self.delegate abf_controlView:self fullScreenAction:sender];
    }
}

- (void)closeBtnClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(abf_controlView:closeAction:)]) {
        [self.delegate abf_controlView:self closeAction:sender];
    }
}

- (void)lockScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self abf_playerShowControlView];
    self.showing = NO;
    if ([self.delegate respondsToSelector:@selector(abf_controlView:lockScreenAction:)]) {
        [self.delegate abf_controlView:self lockScreenAction:sender];
    }
}

/**
 slider滑块的bounds
 */
- (CGRect)thumbRect {
    return [self.videoSlider thumbRectForBounds:self.videoSlider.bounds
                                      trackRect:[self.videoSlider trackRectForBounds:self.videoSlider.bounds]
                                          value:self.videoSlider.value];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGRect rect = [self thumbRect];
    CGPoint point = [touch locationInView:self.videoSlider];
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) { return NO; }
    }
    return YES;
}

- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
    
    if ([self.delegate respondsToSelector:@selector(abf_controlView:progressSliderTouchBegan:)]) {
        [self.delegate abf_controlView:self progressSliderTouchBegan:sender];
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
    if ([self.delegate respondsToSelector:@selector(abf_controlView:progressSliderValueChanged:)]) {
        [self.delegate abf_controlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(abf_controlView:progressSliderTouchEnded:)]) {
        [self.delegate abf_controlView:self progressSliderTouchEnded:sender];
    }
}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(abf_controlView:progressSliderTap:)]) {
            [self.delegate abf_controlView:self progressSliderTap:tapValue];
        }
    }
}
// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {
    
}



-(void)abf_playerModel:(ABFPlayerModel *)playerModel{
    _playerModel = playerModel;
    
    if (playerModel.title) {
        NSLog(@"title = %@",playerModel.title);
        self.titleLabel.text = playerModel.title;
    }
    
    if (playerModel.placeholderImageURLString) {
        NSURL *pu = [NSURL URLWithString:playerModel.placeholderImageURLString];
        [self.placeholderImageView sd_setImageWithURL:pu placeholderImage:[UIImage imageNamed:@"ABFPlayer_loading_bgView"]];
    } else {
        self.placeholderImageView.image = [UIImage imageNamed:@"ABFPlayer_loading_bgView"];
    }
    
    NSInteger count = [self.playerModel.urlArrays count];
    for(int i=0;i<count;i++){
        UILabel *menuLab = [[UILabel alloc] init];
        menuLab.frame = CGRectMake(10, (i*40)+10, 60, 40);
        NSString *url = @"直播源";
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%d",(i+1)]];
        menuLab.text = url;
        
        if(i == 0){
            menuLab.textColor = COMMON_COLOR;
        }else{
            menuLab.textColor = [UIColor whiteColor];
        }
        menuLab.textAlignment = NSTextAlignmentCenter;
        menuLab.font = [UIFont systemFontOfSize:14];
        [_menuView addSubview:menuLab];
        [self.menusLab addObject:menuLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuLabelClick:)];
        menuLab.tag = i;
        menuLab.userInteractionEnabled = YES;
        [menuLab addGestureRecognizer:tap];
    }
}

- (void)abf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        //self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

- (void)abf_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview {
    // 快进快退时候停止菊花
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
    
    // 显示、隐藏预览窗
    //self.videoSlider.popUpView.hidden = !preview;
    // 更新slider的值
    self.videoSlider.value            = draggedValue;
    // 更新bottomProgressView的值
    //self.bottomProgressView.progress  = draggedValue;
    // 更新当前时间
    self.currentTimeLabel.text        = currentTimeStr;
    // 正在拖动控制播放进度
    self.dragged = YES;
    
    if (forawrd) {
        self.fastImageView.image = [UIImage imageNamed:@"ABFPlayer_fast_forward"];
    } else {
        self.fastImageView.image = [UIImage imageNamed:@"ABFPlayer_fast_backward"];
    }
    self.fastView.hidden           = preview;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;
    
}

- (void)abf_playerDraggedEnd {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.startBtn.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutControlView];
}

- (void)abf_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image; {
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    //[self.videoSlider setImage:image];
    //[self.videoSlider setText:currentTimeStr];
    self.fastView.hidden = YES;
    [self.videoSlider setMinimumValueImage:image];
    //[self.videoSlider sett]
    //[self.videoSlider set]
}

/** 锁定屏幕方向按钮状态 */
- (void)abf_playerLockBtnState:(BOOL)state {
    self.lockBtn.selected = state;
}
/** 播放按钮状态 */
- (void)abf_playerPlayBtnState:(BOOL)state {
    self.startBtn.selected = state;
}

/** 加载的菊花 */
- (void)abf_playerActivity:(BOOL)animated {
    if (animated) {
        [self.activity startAnimating];
        self.fastView.hidden = YES;
    } else {
        [self.activity stopAnimating];
    }
}

/** 播放完了 */
- (void)abf_playerPlayEnd {
    self.repeatBtn.hidden = NO;
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self hideControlView];
    self.backgroundColor  = RGBA(0, 0, 0, .3);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

/** 视频加载失败 */
- (void)abf_playerItemStatusFailed:(NSError *)error {
    self.failBtn.hidden = NO;
}
- (void)abf_playerStatusFailed:(BOOL) flag{
    self.failBtn.hidden = flag;
}

- (void)abf_playerMenuSetting:(BOOL)flag index:(NSInteger)index{
    if(flag){
        [self hideControlView];
        [UIView animateWithDuration:0.5 animations:^{
            self.menuView.alpha = 0.8;
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.menuView.alpha = 0;
        }];
    }
}

- (void)abf_playerMenuSelect:(NSInteger)index{
    self.menuIndex = index;
    NSInteger count = [_menusLab count];
    for(int i=0;i<count;i++){
        if(i == index){
            UILabel *lab = (UILabel *)_menusLab[i];
            lab.textColor = COMMON_COLOR;
        }else{
            UILabel *lab = (UILabel *)_menusLab[i];
            lab.textColor = [UIColor whiteColor];
        }
    }
}

- (void)abf_playerPlaying{
    [UIView animateWithDuration:1.0 animations:^{
        self.placeholderImageView.alpha = 0;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
