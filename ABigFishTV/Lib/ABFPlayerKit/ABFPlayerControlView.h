//
//  ABFPlayerControlView.h
//  ABigFishPlayer
//
//  Created by 陈立宇 on 2018/3/24.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABFPlayerKit.h"
#import "ASValueTrackingSlider.h"

@interface ABFPlayerControlView : UIView

@property(nonatomic,weak  )  id<ABFPlayerControlViewDelegate> delegate;

- (void)abf_playerModel:(ABFPlayerModel *)playerModel;

- (void)abf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value;
/**
 * 显示top、bottom、lockBtn
 */
- (void)abf_playerShowControlView;
/**
 * 隐藏top、bottom、lockBtn*/
- (void)abf_playerHideControlView;
/**
 * 重置ControlView
 */
- (void)abf_playerResetControlView;
/**
 * 取消自动隐藏控制层view
 */
- (void)abf_playerCancelAutoFadeOutControlView;
/**
 * 锁定屏幕方向按钮状态
 */
- (void)abf_playerLockBtnState:(BOOL)state;
/**
 * 播放按钮状态 (播放、暂停状态)
 */
- (void)abf_playerPlayBtnState:(BOOL)state;
/**
 * 设置预览图
 
 * @param draggedTime 拖拽的时长
 * @param image       预览图
 */
- (void)abf_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image;

/**
 * 拖拽快进 快退
 
 * @param draggedTime 拖拽的时长
 * @param totalTime   视频总时长
 * @param forawrd     是否是快进
 * @param preview     是否有预览图
 */
- (void)abf_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview;

/**
 * 滑动调整进度结束结束
 */
- (void)abf_playerDraggedEnd;

- (void)abf_playerActivity:(BOOL)animated;

/**
 * 播放完了
 */
- (void)abf_playerPlayEnd;
/**
 * 视频加载失败
 */
- (void)abf_playerItemStatusFailed:(NSError *)error;

- (void)abf_playerStatusFailed:(BOOL) flag;

- (void)abf_playerMenuSetting:(BOOL)flag index:(NSInteger)index;

- (void)abf_playerMenuSelect:(NSInteger)index;

- (void)abf_playerPlaying;
@end
