//
//  ABFPlayerView.h
//  ijkplayerDemo
//
//  Created by 陈立宇 on 17/12/12.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZFPlayer.h"
#import "ZFPlayerControlView.h"
#import "ZFPlayerModel.h"
#import "ZFPlayerControlViewDelegate.h"

@protocol ABFPlayerDelegate <NSObject>
@optional
/** 返回按钮事件 */
- (void)abf_playerBackAction;
/** 下载视频 */
- (void)abf_playerDownload:(NSString *)url;

- (void)abf_playerCutImage;

//- (void)abf_playerBottomProgress:(BOOL)hidden;


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
    ABPlayerStateReadyToPlay, // 可以播放了
    ABFPlayerStatePlaying,    // 播放中
    ABFPlayerStateStopped,    // 停止播放
    ABFPlayerStatePause       // 暂停播放
};

@interface ABFPlayerView : UIView<ZFPlayerControlViewDelagate>

/** 视频model */
/** 设置playerLayer的填充模式 */
@property (nonatomic, assign) ABFPlayerLayerGravity   playerLayerGravity;
/** 是否有下载功能(默认是关闭) */
@property (nonatomic, assign) BOOL                    hasDownload;
/** 是否开启预览图 */
@property (nonatomic, assign) BOOL                    hasPreviewView;
/** 设置代理 */
@property (nonatomic, weak) id<ABFPlayerDelegate>      delegate;
/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL          isPauseByUser;
/** 播发器的几种状态 */
@property (nonatomic, assign, readonly) ABFPlayerState state;
/** 静音（默认为NO）*/
@property (nonatomic, assign) BOOL                    mute;
/** 当cell划出屏幕的时候停止播放（默认为NO） */
@property (nonatomic, assign) BOOL                    stopPlayWhileCellNotVisable;
/** 当cell播放视频由全屏变为小屏时候，是否回到中间位置(默认YES) */
@property (nonatomic, assign) BOOL                    cellPlayerOnCenter;

@property (nonatomic, strong) UIImage *image;


/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZFPlayer
 */
+ (instancetype)sharedPlayerView;

/**
 * 指定播放的控制层和模型
 * 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
 */
- (void)playerControlView:(UIView *)controlView playerModel:(ZFPlayerModel *)playerModel;
/**
 * 使用自带的控制层时候可使用此API
 */
- (void)playerModel:(ZFPlayerModel *)playerModel;

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo;

/**
 *  重置player
 */
- (void)resetPlayer;

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(ZFPlayerModel *)playerModel;

/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

- (void)destory;


@end
