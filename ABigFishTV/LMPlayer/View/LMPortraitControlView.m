//
//  LMPortraitControlView.m
//  拉面视频Demo
//
//  Created by 李小南 on 16/9/1.
//  Copyright © 2016年 lamiantv. All rights reserved.
//  

#import "LMPortraitControlView.h"
#import <Masonry.h>
#import "UIColor+Hex.h"

@interface LMPortraitControlView ()
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;
/** 分享按钮 */
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *cutBtn;
/** 底部工具栏 */
@property (nonatomic, strong) UIView *bottomToolView;
/** 播放或暂停按钮 */
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/** 播放的当前时间label */
@property (nonatomic, strong) UILabel *currentTimeLabel;
/** 滑杆 */
@property (nonatomic, strong) UISlider *videoSlider;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
/** 视频总时间 */
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton *fullScreenBtn;



@property (nonatomic, assign) double durationTime;
@end

@implementation LMPortraitControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.backBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.progressView];
        [self.bottomToolView addSubview:self.videoSlider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.fullScreenBtn];
        [self addSubview:self.cutBtn];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cutBtn addTarget:self action:@selector(cutBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
    [self.videoSlider addGestureRecognizer:sliderTap];
    
    // slider开始滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchBeganAction:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.videoSlider addTarget:self action:@selector(progressSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchEndedAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
}

#pragma mark - action

- (void)backBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(portraitBackButtonClick)]) {
        [self.delegate portraitBackButtonClick];
    }
}

- (void)shareBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(portraitShareButtonClick)]) {
        [self.delegate portraitShareButtonClick];
    }
}

- (void)cutBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(portraitCutButtonClick)]) {
        [self.delegate portraitCutButtonClick];
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(portraitPlayPauseButtonClick:)]){
        [self.delegate portraitPlayPauseButtonClick:sender.selected];
    }
}

- (void)progressSliderTouchBeganAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(portraitProgressSliderBeginDrag)]) {
        [self.delegate portraitProgressSliderBeginDrag];
    }
}

- (void)progressSliderValueChangedAction:(UISlider *)sender {
    // 拖拽过程中修改playTime
    [self syncplayTime:(sender.value * self.durationTime)];
}

- (void)progressSliderTouchEndedAction:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(portraitProgressSliderEndDrag:)]) {
        [self.delegate portraitProgressSliderEndDrag:sender.value];
    }
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(portraitFullScreenButtonClick)]) {
        [self.delegate portraitFullScreenButtonClick];
    }
}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UISlider class]] && [self.delegate respondsToSelector:@selector(portraitProgressSliderTapAction:)]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        
        [self.delegate portraitProgressSliderTapAction:tapValue];
    }
}

#pragma mark - 添加子控件约束
- (void)makeSubViewsConstraints {
    
    CGFloat margin = 9; // label左右的间距
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(52);
        make.height.offset(42);
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.mas_left).offset(5);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(24);
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.backBtn.mas_right).offset(5);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(52);
        make.height.offset(42);
        make.top.equalTo(self.mas_top).offset(2);
        make.trailing.equalTo(self.mas_trailing).offset(-5);
    }];
    
    [self.cutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(52);
        make.height.offset(42);
        make.top.equalTo(self.mas_top).offset(2);
        make.trailing.equalTo(self.mas_trailing).offset(-55);
    }];
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(39);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomToolView.mas_leading).offset(10);
        make.centerY.equalTo(self.bottomToolView);
        make.width.height.mas_equalTo(28);
    }];
    
    //
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.playOrPauseBtn.mas_trailing).offset(4);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
        make.width.mas_equalTo(48);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(28);
        make.trailing.equalTo(self.bottomToolView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(-4);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
        make.width.mas_equalTo(48);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(margin);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-margin);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(margin);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-margin);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
    
}

#pragma mark - Public method
/** 重置ControlView */
- (void)playerResetControlView {
    self.videoSlider.value           = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected = YES;
    
    self.shareBtn.alpha = 1;
    self.backBtn.alpha = 1;
    self.bottomToolView.alpha = 1;
}

- (void)playEndHideView:(BOOL)playeEnd {
    self.shareBtn.alpha = playeEnd;
    self.backBtn.alpha = playeEnd;
    self.bottomToolView.alpha = 0;
}

- (void)syncplayPauseButton:(BOOL)isPlay {
    if (isPlay) {
        self.playOrPauseBtn.selected = YES;
    } else {
        self.playOrPauseBtn.selected = NO;
    }
}

- (void)syncbufferProgress:(double)progress {
    self.progressView.progress = progress;
}

- (void)syncplayProgress:(double)progress {
    self.videoSlider.value = progress;
}

- (void)syncplayTime:(NSInteger)time {
    
    if (time < 0) {
        return;
    }
    NSString *progressTimeString = [self convertTimeSecond:time];
    self.currentTimeLabel.text = progressTimeString;
}

- (void)syncDurationTime:(NSInteger)time {
    
    if (time < 0) {
        return;
    }
    
    self.durationTime = time;
    NSString *durationTimeString = [self convertTimeSecond:time];
    self.totalTimeLabel.text = durationTimeString;
}

#pragma mark - Other
// !!!: 将秒数时间转换成mm:ss
- (NSString *)convertTimeSecond:(NSInteger)second {
    
    NSInteger durMin = second / 60; // 秒
    NSInteger durSec = second % 60; // 分钟
    NSString *timeString = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    
    return timeString;
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

- (UIButton *)cutBtn {
    
    if (!_cutBtn) {
        _cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cutBtn setImage:[UIImage imageNamed:@"icon_cut"] forState:UIControlStateNormal];
    }
    return _cutBtn;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        _bottomToolView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"btn_播放"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"btn_暂停"] forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UISlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider = [[UISlider alloc] init];
        _videoSlider.maximumValue = 1;
        _videoSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"#e6420d"];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"椭圆-1"] forState:UIControlStateNormal];
    }
    return _videoSlider;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"efefef"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"a5a5a5"];
    }
    return _progressView;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.font = [UIFont systemFontOfSize:14.0f];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = @"111";
    }
    return _titleLab;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"btn_全屏"] forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}


@end
