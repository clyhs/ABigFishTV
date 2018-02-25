//
//  LMPortraitControlView.h
//  拉面视频Demo
//
//  Created by 李小南 on 16/9/1.
//  Copyright © 2016年 lamiantv. All rights reserved.
//  竖屏下的控制view

#import <UIKit/UIKit.h>

@protocol LMPortraitControlViewDelegate <NSObject>

/** 返回按钮被点击 */
- (void)portraitBackButtonClick;
/** 分享按钮被点击 */
- (void)portraitShareButtonClick;

- (void)portraitCutButtonClick;
/** 播放暂停按钮被点击, 是否选中，选中时当前为播发，按钮为暂停的 */
- (void)portraitPlayPauseButtonClick:(BOOL)isSelected;
/** 进度条开始拖动 */
- (void)portraitProgressSliderBeginDrag;
/** 进度结束拖动，并返回最后的值 */
- (void)portraitProgressSliderEndDrag:(CGFloat)value;
/** 全屏按钮被点击 */
- (void)portraitFullScreenButtonClick;
/** 进度条tap点击 */
- (void)portraitProgressSliderTapAction:(CGFloat)value;
@end

@interface LMPortraitControlView : UIView
@property (nonatomic, weak) id<LMPortraitControlViewDelegate> delegate;

@property (nonatomic, strong) UILabel  *titleLab;
/** 重置ControlView */
- (void)playerResetControlView;
- (void)playEndHideView:(BOOL)playeEnd;


// ------------------------------

/** 更新播放/暂停按钮显示 */
- (void)syncplayPauseButton:(BOOL)isPlay;

/** 更新缓冲进度 */
- (void)syncbufferProgress:(double)progress;

/** 更新播放进度 */
- (void)syncplayProgress:(double)progress;

/** 更新当前播放时间 */
- (void)syncplayTime:(NSInteger)time;

/** 更新视频时长 */
- (void)syncDurationTime:(NSInteger)time;
@end
