//
//  ABFPlayerView.h
//  ABigFishPlayer
//
//  Created by 陈立宇 on 2018/3/24.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABFPlayerControlView.h"
#import "ABFPlayerModel.h"

@protocol ABFPlayerDelegate <NSObject>
@optional
/** 返回按钮事件 */
- (void)abf_playerBackAction;

@end

// playerLayer的填充模式（默认：等比例填充，直到一个维度到达区域边界）
typedef NS_ENUM(NSInteger, ABFPlayerLayerGravity) {
    ABFPlayerLayerGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
    ABFPlayerLayerGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
    ABFPlayerLayerGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};

// 播放器的几种状态
typedef NS_ENUM(NSInteger, ABFPlayerState) {
    ABFPlayerStateFailed,     // 播放失败
    ABFPlayerStateBuffering,  // 缓冲中
    ABFPlayerStateReadyToPlay, // 可以播放了
    ABFPlayerStatePlaying,    // 播放中
    ABFPlayerStateStopped,    // 停止播放
    ABFPlayerStatePause       // 暂停播放
};

@interface ABFPlayerView : UIView<ABFPlayerControlViewDelegate>

@property (nonatomic, weak) id<ABFPlayerDelegate>      delegate;

- (void)autoPlayTheVideo;

- (void)playerModel:(ABFPlayerModel *)playerModel;

- (void)playControlView:(UIView *)controlView playerModel:(ABFPlayerModel *) playerModel;

- (void)playOrPause;

- (void)play;

- (void)pause;

@end
