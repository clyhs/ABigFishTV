//
//  LMVideoPlayer.m
//  IJK播放器Demo
//
//  Created by 李小南 on 2017/3/28.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import "LMVideoPlayer.h"
#import "LMPlayerManager.h"
#import "LMVideoPlayerView.h"
#import "LMPlayerStatusModel.h"
#import "LMBrightnessView.h"

@interface LMVideoPlayer ()<LMPlayerManagerDelegate, LMPlayerControlViewDelagate, LMPortraitControlViewDelegate, LMLandScapeControlViewDelegate, LMVideoPlayerViewDelagate, LMLoadingViewDelegate, LMCoverControlViewDelegate>

// AVPlayer 管理
@property (nonatomic, strong) LMPlayerManager *playerMgr;

// 代理
@property (nonatomic, weak) id<LMVideoPlayerDelegate> delegate;


// 播放数据模型
@property (nonatomic, strong) LMPlayerModel *playerModel;
/** 播放器的参数模型 */
@property (nonatomic, strong) LMPlayerStatusModel *playerStatusModel;


// 最底层的父视图
@property (nonatomic, strong) LMVideoPlayerView *videoPlayerView;
/** 用来保存pan手势快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL isPauseByUser;

@end

@implementation LMVideoPlayer
#pragma mark - getter

//- (UIView *)portraitControlView {
//    return self.videoPlayerView.portraitControlView;
//}
//
//- (UIView *)landScapeControlView {
//    return self.videoPlayerView.landScapeControlView;
//}

#pragma mark - public method

+ (instancetype)videoPlayerWithView:(UIView *)view delegate:(id<LMVideoPlayerDelegate>)delegate playerModel:(LMPlayerModel *)playerModel {
    
    if (view == nil) {
        return nil;
    }
    
    LMVideoPlayer *instance = [[LMVideoPlayer alloc] init];
    instance.delegate = delegate;
    
    // 创建状态模型
    instance.playerStatusModel = [[LMPlayerStatusModel alloc] init];
    [instance.playerStatusModel playerResetStatusModel];
    
    // !!!: 最底层视图创建
    instance.videoPlayerView = [LMVideoPlayerView videoPlayerViewWithSuperView:view delegate:instance playerStatusModel:instance.playerStatusModel];
    instance.videoPlayerView.playerControlView.delegate = instance;
    instance.videoPlayerView.playerControlView.portraitControlView.delegate
    = instance;
    instance.videoPlayerView.playerControlView.landScapeControlView.delegate
    = instance;
    instance.videoPlayerView.coverControlView.delegate
    = instance;
    instance.videoPlayerView.loadingView.delegate
    = instance;
    
    
    // !!!: 创建AVPlayer管理
    instance.playerMgr = [LMPlayerManager playerManagerWithDelegate:instance playerStatusModel:instance.playerStatusModel];
    instance.isPauseByUser = YES;
    
    // 设置基本模型 (最后设置)
    instance.playerModel = playerModel;
    
    return instance;
}

// !!!: 销毁视频
- (void)destroyVideo {
    [self.playerMgr stop];
    [self.videoPlayerView removeFromSuperview];
    
    self.playerMgr = nil;
    self.videoPlayerView = nil;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)setPlayerModel:(LMPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    // 同步一些属性
    [self.videoPlayerView.coverControlView syncCoverImageViewWithURLString:playerModel.placeholderImageURLString placeholderImage:playerModel.placeholderImage];
    self.playerMgr.seekTime = self.playerModel.seekTime;
    self.videoPlayerView.playerControlView.viewTime = self.playerModel.viewTime;
    [self.videoPlayerView.playerControlView.landScapeControlView syncTitle:self.playerModel.title];
    NSLog(@"url=%@",self.playerModel.videoURL);
    //self.videoPlayerView.playerControlView.tit
    self.videoPlayerView.playerControlView.portraitControlView.titleLab.text = playerModel.title;
}

/** 自动播放，默认不自动播放 */
- (void)autoPlayTheVideo {
    [self configLMPlayer];
    [self.videoPlayerView.coverControlView removeFromSuperview];
    self.videoPlayerView.loadingView.hidden = NO;
}

// 设置Player相关参数
- (void)configLMPlayer {
    
    // 销毁之前的视频
    if(self.playerMgr) {
        [self.playerMgr stop];
    }
    
    [self.videoPlayerView.playerControlView loading];
    [self.playerMgr initPlayerWithUrl:self.playerModel.videoURL];
    [self.videoPlayerView setPlayerLayerView:self.playerMgr.playerLayerView];
    
    self.isPauseByUser = NO;
}

/**
 *  重置player
 */
- (void)resetPlayer
{
    // 改为为播放完
    self.playerStatusModel.playDidEnd         = NO;
    self.playerStatusModel.didEnterBackground = NO;
    self.playerStatusModel.autoPlay           = NO;
    
    if (self.playerMgr) {
        [self.playerMgr stop];
    }
    
    [self.videoPlayerView playerResetVideoPlayerView];
}

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(LMPlayerModel *)playerModel {
    [self resetPlayer];
    self.playerModel = playerModel;
    [self configLMPlayer];
}

- (void)playVideo {
    // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
    if (self.playerMgr.state == LMPlayerStateStoped) {
        [self.playerMgr rePlay]; //
    } else {
        [self.playerMgr play];
    }
    NSLog(@"url=%@",self.playerModel.videoURL);
}

- (void)pauseVideo {
    [self.playerMgr pause];
}

- (void)stopVideo {
    [self.playerMgr stop];
}

#pragma mark - LMAVPlayerManagerDelegate

- (void)changePlayerState:(LMPlayerState)state {
    switch (state) {
        case LMPlayerStateReadyToPlay:{
            
            [self.videoPlayerView.playerControlView readyToPlay];
        }
            break;
        case LMPlayerStatePlaying: {
            [self.videoPlayerView.playerControlView.portraitControlView syncplayPauseButton:YES];
            [self.videoPlayerView.playerControlView.landScapeControlView syncplayPauseButton:YES];
            self.isPauseByUser = NO;
        }
            break;
        case LMPlayerStatePause: {
            [self.videoPlayerView.playerControlView.portraitControlView syncplayPauseButton:NO];
            [self.videoPlayerView.playerControlView.landScapeControlView syncplayPauseButton:NO];
            self.isPauseByUser = YES;
        }
            break;
        case LMPlayerStateStoped: {
            [self.videoPlayerView playDidEnd];
        }
            break;
        case LMPlayerStateBuffering: {
            [self.videoPlayerView.playerControlView loading];
        }
            break;
        case LMPlayerStateFailed: {
            [self.videoPlayerView loadFailed];
            self.videoPlayerView.loadingView.hidden = YES;
            
            LMBrightnessViewShared.isStartPlay = YES;
            [self.videoPlayerView.playerControlView loadFailed];
        }
            break;
        default:
            break;
    }
}

- (void)changeLoadProgress:(double)progress second:(CGFloat)second {
    [self.videoPlayerView.playerControlView.landScapeControlView syncbufferProgress:progress];
    [self.videoPlayerView.playerControlView.portraitControlView syncbufferProgress:progress];
    
    // 如果缓冲达到俩秒以上或者缓冲完成则播放，先检测当前视频状态是否为播放
    if (progress == 1.0f ||  second >= [self.playerMgr currentTime] + 2.5) { // 当前播放位置秒数 + 2.5 小于等于 缓冲到的位置秒数
        [self didBuffer:self.playerMgr];
    }
}

- (void)changePlayProgress:(double)progress second:(CGFloat)second {
    if (self.playerStatusModel.isDragged) { // 在拖拽进度条的时候不应去更新进度条的值
        return;
    }
    
    [self.videoPlayerView.playerControlView.portraitControlView syncplayProgress:progress];
    [self.videoPlayerView.playerControlView.landScapeControlView syncplayProgress:progress];
    [self.videoPlayerView.playerControlView.portraitControlView syncplayTime:second];
    [self.videoPlayerView.playerControlView.landScapeControlView syncplayTime:second];
    [self.videoPlayerView.playerControlView.portraitControlView syncDurationTime:self.playerMgr.duration];
    [self.videoPlayerView.playerControlView.landScapeControlView syncDurationTime:self.playerMgr.duration];
}

- (void)didBuffer:(LMPlayerManager *)playerMgr { 
    if (self.playerMgr.state == LMPlayerStateBuffering || !self.playerStatusModel.isPauseByUser) {
        [self.playerMgr play];
//        [self.videoPlayerView.playerControlView readyToPlay];
    }
}

/** 播放器准备开始播放时 */
- (void)playerReadyToPlay {
    [self.videoPlayerView startReadyToPlay];
    self.videoPlayerView.loadingView.hidden = YES;
    
    LMBrightnessViewShared.isStartPlay = YES;
}

#pragma mark - LMPlayerControlViewDelagate
/** 加载失败按钮被点击 */
- (void)failButtonClick {
    [self configLMPlayer];
}

/** 重播按钮被点击 */
- (void)repeatButtonClick {
    [self.playerMgr rePlay];
    
    [self.videoPlayerView repeatPlay];
    
    // 没有播放完
    self.playerStatusModel.playDidEnd = NO;
    
//    if ([self.videoURL.scheme isEqualToString:@"file"]) {
//        self.state = LMPlayerStatePlaying;
//    } else {
//        self.state = LMPlayerStateBuffering;
//    }
}

/** 跳转播放按钮被点击 */
- (void)jumpPlayButtonClick:(NSInteger)viewTime {
    if (!viewTime) {
        return;
    }
    [self.playerMgr seekToTime:viewTime completionHandler:nil];
}

#pragma mark - LMPortraitControlViewDelegate
/** 返回按钮被点击 */
- (void)portraitBackButtonClick {
    if ([self.delegate respondsToSelector:@selector(playerBackButtonClick)]) {
        [self.delegate playerBackButtonClick];
    }
}

/** 分享按钮被点击 */
- (void)portraitShareButtonClick {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    if ([self.delegate respondsToSelector:@selector(playerShareButtonClick)]) {
        [self.delegate playerShareButtonClick];
    }
}

-(void)portraitCutButtonClick{
    
    if ([self.delegate respondsToSelector:@selector(playerCutButtonClick)]) {
        [self.delegate playerCutButtonClick];
    }

}



/** 播放暂停按钮被点击, 是否选中，选中时当前为播发，按钮为暂停的 */
- (void)portraitPlayPauseButtonClick:(BOOL)isSelected {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    if (isSelected) {
        [self.playerMgr pause];
    } else {
        // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
        if (self.playerMgr.state == LMPlayerStateStoped) {
            [self.playerMgr rePlay]; //
        } else {
            [self.playerMgr play];
        }
    }
}

/** 进度条开始拖动 */
- (void)portraitProgressSliderBeginDrag {
    self.playerStatusModel.dragged = YES;
    [self.videoPlayerView.playerControlView playerCancelAutoFadeOutControlView];
}

/** 进度结束拖动，并返回最后的值 */
- (void)portraitProgressSliderEndDrag:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

/** 全屏按钮被点击 */
- (void)portraitFullScreenButtonClick {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    [self.videoPlayerView shrinkOrFullScreen:YES];
}

/** 进度条tap点击 */
- (void)portraitProgressSliderTapAction:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

#pragma mark - LMLandScapeControlViewDelegate
/** 返回按钮被点击 */
- (void)landScapeBackButtonClick {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    [self.videoPlayerView shrinkOrFullScreen:NO];
}

/** 播放暂停按钮被点击 */
- (void)landScapePlayPauseButtonClick:(BOOL)isSelected {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    if (isSelected) {
        [self.playerMgr pause];
    } else {
        // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
        if (self.playerMgr.state == LMPlayerStateStoped) {
            [self.playerMgr rePlay]; //
        } else {
            [self.playerMgr play];
        }
    }
}

-(void)landScapeLockClick:(BOOL)isSelected{
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    if ([self.delegate respondsToSelector:@selector(playerLockButtonClick)]) {
        [self.delegate playerLockButtonClick];
    }

}

-(void)landScapeCollectClick:(BOOL)isSelected{

    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    if ([self.delegate respondsToSelector:@selector(playerCollectButtonClick)]) {
        [self.delegate playerCollectButtonClick];
    }
}

/** 发送弹幕按钮被点击 */
- (void)landScapeSendBarrageButtonClick {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
}

/** 打开关闭弹幕按钮被点击 */
- (void)landScapeOpenOrCloseBarrageButtonClick:(BOOL)isSelected {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
}

/** 进度条开始拖动 */
- (void)landScapeProgressSliderBeginDrag {
    self.playerStatusModel.dragged = YES;
    
    [self.videoPlayerView.playerControlView playerCancelAutoFadeOutControlView];
}

/** 进度结束拖动，并返回最后的值 */
- (void)landScapeProgressSliderEndDrag:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

/** 退出全屏按钮被点击 */
- (void)landScapeExitFullScreenButtonClick {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    [self.videoPlayerView shrinkOrFullScreen:NO];
}

/** 进度条tap点击 */
- (void)landScapeProgressSliderTapAction:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

#pragma mark - LMVideoPlayerViewDelagate
/** 双击事件 */
- (void)doubleTapAction {
    if (self.playerStatusModel.isPauseByUser) {
        [self.playerMgr play];
    } else {
        [self.playerMgr pause];
    }
    if (!self.playerStatusModel.isAutoPlay) {
        self.playerStatusModel.autoPlay = YES;
        [self configLMPlayer];
    }
}

/** pan开始水平移动 */
- (void)panHorizontalBeginMoved {
    // 给sumTime初值
    self.sumTime = self.playerMgr.currentTime;
}

/** pan水平移动ing */
- (void)panHorizontalMoving:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    CGFloat totalMovieDuration = self.playerMgr.duration;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    self.playerStatusModel.dragged = YES;
    
    // 改变currentLabel值
    CGFloat draggedValue = (CGFloat)self.sumTime/(CGFloat)totalMovieDuration;
    
    [self.videoPlayerView.playerControlView.portraitControlView syncplayProgress:draggedValue];
    [self.videoPlayerView.playerControlView.landScapeControlView syncplayProgress:draggedValue];
    [self.videoPlayerView.playerControlView.portraitControlView syncplayTime:self.sumTime];
    [self.videoPlayerView.playerControlView.landScapeControlView syncplayTime:self.sumTime];
    
    // 展示快进/快退view
    [self.videoPlayerView.playerControlView showFastView:self.sumTime totalTime:totalMovieDuration isForward:style];
    
}

/** pan结束水平移动 */
- (void)panHorizontalEndMoved {
    // 隐藏快进/快退view
    [self.videoPlayerView.playerControlView hideFastView];
    
    // seekTime
    self.playerStatusModel.pauseByUser = NO;
    [self.playerMgr seekToTime:self.sumTime completionHandler:nil];
    self.sumTime = 0;
    self.playerStatusModel.dragged = NO;
}

/** 音量改变 */
- (void)volumeValueChange:(CGFloat)value {
    [self.playerMgr changeVolume:value];
}

#pragma mark - LMLoadingViewDelegate
/** 返回按钮被点击 */
- (void)loadingViewBackButtonClick {
    if ([self.delegate respondsToSelector:@selector(playerBackButtonClick)]) {
        [self.delegate playerBackButtonClick];
    }
}

/** 分享按钮被点击 */
- (void)loadingViewShareButtonClick {
    if ([self.delegate respondsToSelector:@selector(playerShareButtonClick)]) {
        [self.delegate playerShareButtonClick];
    }
}

#pragma mark - LMCoverControlViewDelegate
/** 返回按钮被点击 */
- (void)coverControlViewBackButtonClick {
    if ([self.delegate respondsToSelector:@selector(playerBackButtonClick)]) {
        [self.delegate playerBackButtonClick];
    }
}

/** 分享按钮被点击 */
- (void)coverControlViewShareButtonClick {
    if ([self.delegate respondsToSelector:@selector(playerShareButtonClick)]) {
        [self.delegate playerShareButtonClick];
    }
}

/*
- (void)cutImageButtonClick{

    if ([self.delegate respondsToSelector:@selector(playerCutButtonClick)]) {
        [self.delegate playerCutButtonClick];
    }
}*/

/** 封面图片Tap事件 */
- (void)coverControlViewBackgroundImageViewTapAction {
    if ([self.delegate respondsToSelector:@selector(controlViewTapAction)]) {
        [self.delegate controlViewTapAction];
    }
}

#pragma mark - 对象释放

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self destroyVideo];
}

-(UIImage *)getImage{


    return _playerMgr.image;
}

@end
