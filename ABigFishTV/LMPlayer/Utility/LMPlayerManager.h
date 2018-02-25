//
//  LMPlayerManager.h
//  IJK播放器Demo
//
//  Created by 李小南 on 2017/3/27.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMPlayerManager;
@class LMPlayerStatusModel;

// 播放器的几种状态
typedef NS_ENUM(NSInteger, LMPlayerState) {
    LMPlayerStateUnknow,          // 未初始化的
    LMPlayerStateFailed,          // 播放失败（无网络，视频地址错误）
    LMPlayerStateReadyToPlay,     // 可以播放了
    LMPlayerStateBuffering,       // 缓冲中
    LMPlayerStatePlaying,         // 播放中
    LMPlayerStatePause,           // 暂停播放
    LMPlayerStateStoped           // 播放已停止（需要重新初始化）
};

@protocol LMPlayerManagerDelegate <NSObject>

@required
/** 视频状态改变时 */
- (void)changePlayerState:(LMPlayerState)state;
/** 播放进度改变时 @progress:范围：0 ~ 1 @second: 原秒数 */
- (void)changePlayProgress:(double)progress second:(CGFloat)second;
/** 缓冲进度改变时 @progress范围：0 ~ 1 @second: 原秒数 */
- (void)changeLoadProgress:(double)progress  second:(CGFloat)second ;
/** 当缓冲到可以再次播放时 */
- (void)didBuffer:(LMPlayerManager *)playerMgr;
/** 播放器准备开始播放时 */
- (void)playerReadyToPlay;

@end

@interface LMPlayerManager : NSObject



/** playerLayerView */
@property (nonatomic, strong, readonly) UIView *playerLayerView;
+ (instancetype)playerManagerWithDelegate:(id<LMPlayerManagerDelegate>)delegate playerStatusModel:(LMPlayerStatusModel *)playerStatusModel;
- (void)initPlayerWithUrl:(NSURL *)url;

/** 获取视频时长，单位：秒 */
@property (nonatomic, assign, readonly) double duration;
/** 获取当前播放时间，单位：秒 */
@property (nonatomic, assign, readonly) double currentTime;
/** 获取当前状态 */
@property (nonatomic, assign, readonly) LMPlayerState state;
/** 从xx秒开始播放视频 */
@property (nonatomic, assign) NSInteger seekTime;

@property (nonatomic, strong) UIImage *image;


/**
 *  播放
 */
- (void)play;

/**
 *  重新播放
 */
- (void)rePlay;

/**
 *  暂停
 */
- (void)pause;

/**
 *  停止
 */
- (void)stop;

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)())completionHandler;

/**
 *  改变音量
 */
- (void)changeVolume:(CGFloat)value;



@end
