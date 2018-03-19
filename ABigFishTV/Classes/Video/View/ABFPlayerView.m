//
//  ABFPlayerView.m
//  ijkplayerDemo
//
//  Created by 陈立宇 on 17/12/12.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "ABFPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UIView+CustomControlView.h"
//#import "ZFPlayer.h"

//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};
@interface ABFPlayerView()<UIGestureRecognizerDelegate,UIAlertViewDelegate>


/** playerLayer */
@property (atomic, retain) id <IJKMediaPlayback>     player;
//@property (nonatomic, strong) AVPlayerLayer          *playerLayer;
@property (nonatomic, strong) id                     timeObserve;
/** 滑杆 */
@property (nonatomic, strong) UISlider               *volumeViewSlider;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat                sumTime;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection           panDirection;
/** 播发器的几种状态 */
@property (nonatomic, assign) ABFPlayerState          state;
/** 是否为全屏 */
@property (nonatomic, assign) BOOL                   isFullScreen;
/** 是否锁定屏幕方向 */
@property (nonatomic, assign) BOOL                   isLocked;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL                   isVolume;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                   isPauseByUser;
/** 是否播放本地文件 */
@property (nonatomic, assign) BOOL                   isLocalVideo;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat                sliderLastValue;
/** 是否再次设置URL播放视频 */
@property (nonatomic, assign) BOOL                   repeatToPlay;
/** 播放完了*/
@property (nonatomic, assign) BOOL                   playDidEnd;
/** 进入后台*/
@property (nonatomic, assign) BOOL                   didEnterBackground;
/** 是否自动播放 */
@property (nonatomic, assign) BOOL                   isAutoPlay;
/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
/** 视频URL的数组 */
@property (nonatomic, strong) NSArray                *videoURLArray;
/** slider预览图 */
@property (nonatomic, strong) UIImage                *thumbImg;
/** 亮度view */
@property (nonatomic, strong) ZFBrightnessView       *brightnessView;

#pragma mark - UITableViewCell PlayerView

/** palyer加到tableView */
@property (nonatomic, strong) UITableView            *tableView;
/** player所在cell的indexPath */
@property (nonatomic, strong) NSIndexPath            *indexPath;
/** ViewController中页面是否消失 */
@property (nonatomic, assign) BOOL                   viewDisappear;
/** 是否在cell上播放video */
@property (nonatomic, assign) BOOL                   isCellVideo;
/** 是否缩小视频在底部 */
@property (nonatomic, assign) BOOL                   isBottomVideo;
/** 是否切换分辨率*/
@property (nonatomic, assign) BOOL                   isChangeResolution;
/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL                   isDragged;

@property (nonatomic, assign) BOOL                   isMenuView;

@property (nonatomic, assign) BOOL                   isTypeView;

@property (nonatomic, strong) UIView                 *controlView;
@property (nonatomic, strong) ZFPlayerModel          *playerModel;
@property (nonatomic, assign) NSInteger              seekTime;
@property (nonatomic, strong) NSURL                  *videoURL;
@property (nonatomic, strong) NSDictionary           *resolutionDic;

@property (nonatomic,strong)  NSMutableArray         *urlsLab;
@property (nonatomic,assign)  NSInteger              urlIndex;

@property (nonatomic,strong)  NSMutableArray         *typesLab;
@property (nonatomic,assign)  NSInteger              typeIndex;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ABFPlayerView

/**
 *  代码初始化调用此方法
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeThePlayer];
        _urlsLab = [NSMutableArray new];
        _urlIndex = 0;
        _typeIndex = 0;
        _typesLab = [NSMutableArray new];
    }
    return self;
}

/**
 *  storyboard、xib加载playerView会调用此方法
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeThePlayer];
}
/**
 *  初始化player
 */
- (void)initializeThePlayer {
    self.cellPlayerOnCenter = YES;;
}

- (void)dealloc {
    //self.playerItem = nil;
    
    [self.player shutdown];
    self.tableView  = nil;
    [[self.player view] removeFromSuperview];
    
    ZFPlayerShared.isLockScreen = NO;
    [self.controlView zf_playerCancelAutoFadeOutControlView];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    // 移除time观察者
    //if (self.timeObserve) {
        //[self.player removeTimeObserver:self.timeObserve];
        //.timeObserve = nil;
    //}
    [self removeMovieNotificationObservers];
    self.player = nil;
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  在当前页面，设置新的Player的URL调用此方法
 */
- (void)resetToPlayNewURL {
    self.repeatToPlay = YES;
    [self resetPlayer];
}

#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStatusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [self installMovieNotificationObservers];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    [self.player view].frame = self.bounds;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
}

+ (instancetype)sharedPlayerView {
    static ABFPlayerView *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[ABFPlayerView alloc] init];
    });
    return playerView;
}

- (void)playerControlView:(UIView *)controlView playerModel:(ZFPlayerModel *)playerModel {
    if (!controlView) {
        // 指定默认控制层
        ZFPlayerControlView *defaultControlView = [[ZFPlayerControlView alloc] init];
        self.controlView = defaultControlView;
    } else {
        self.controlView = controlView;
    }
    self.playerModel = playerModel;
    
    [self.controlView zf_playBottomProgress:YES];
    
    NSInteger count = [self.playerModel.urlArrays count];
    NSLog(@"url.count=%ld",count);
    [self menuViewAddlab];
    [self typeViewAddlab];
}

-(void)menuViewAddlab{
    UIView *menuVew =[(ZFPlayerControlView *)self.controlView zf_menuView];
    NSInteger count = [self.playerModel.urlArrays count];
    for(int i=0;i<count;i++){
        UILabel *menuLab = [[UILabel alloc] init];
        menuLab.frame = CGRectMake(10, (i*40)+10, 60, 40);
        //menuLab.backgroundColor = COMMON_COLOR;
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
        [menuVew addSubview:menuLab];
        
        [_urlsLab addObject:menuLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouchMenu:)];
        menuLab.tag = i;
        menuLab.userInteractionEnabled = YES;
        [menuLab addGestureRecognizer:tap];
    }
}

-(void)typeViewAddlab{
    UIView *menuVew =[(ZFPlayerControlView *)self.controlView zf_typeView];
    
    for(int i=0;i<3;i++){
        UILabel *menuLab = [[UILabel alloc] init];
        menuLab.frame = CGRectMake(10, (i*40)+10, 60, 40);
        NSString *url = @"分辩率";
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%d",(i+1)]];
        menuLab.text = url;
        if(i == 0){
            menuLab.textColor = COMMON_COLOR;
        }else{
            menuLab.textColor = [UIColor whiteColor];
        }
        
        menuLab.textAlignment = NSTextAlignmentLeft;
        menuLab.font = [UIFont systemFontOfSize:14];
        [menuVew addSubview:menuLab];
        
        [_typesLab addObject:menuLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouchType:)];
        menuLab.tag = i;
        menuLab.userInteractionEnabled = YES;
        [menuLab addGestureRecognizer:tap];
    }
}

-(void)OnTouchType:(id)sender{
    //[_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *view = (UIView *)tap.view;
    _typeIndex = (NSInteger)view.tag;
    
    NSInteger count = [_typesLab count];
    for(int i=0;i<count;i++){
        if(i == _typeIndex){
            UILabel *lab = (UILabel *)_typesLab[i];
            lab.textColor = COMMON_COLOR;
        }else{
            UILabel *lab = (UILabel *)_typesLab[i];
            lab.textColor = [UIColor whiteColor];
        }
    }
    if(_typeIndex == 0){
        [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    }else if(_typeIndex == 1){
        [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    }else if(_typeIndex == 2){
        [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    }else{
        [_player setScalingMode:IJKMPMovieScalingModeNone];
    }
    
    if(!self.isTypeView){
        [self.controlView zf_playMenuView:YES];
    }
}

-(void)OnTouchMenu:(id)sender{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *view = (UIView *)tap.view;
    _urlIndex = (NSInteger)view.tag;
    NSLog(@"tag=%ld",view.tag);
    NSString *url = self.playerModel.urlArrays[view.tag];
    self.playerModel.videoURL = [NSURL URLWithString:url];
    self.videoURL = [NSURL URLWithString:url];
    NSInteger count = [_urlsLab count];
    for(int i=0;i<count;i++){
        if(i == _urlIndex){
            UILabel *lab = (UILabel *)_urlsLab[i];
            lab.textColor = COMMON_COLOR;
        }else{
            UILabel *lab = (UILabel *)_urlsLab[i];
            lab.textColor = [UIColor whiteColor];
        }
    }
    
    if(!self.isMenuView){
        //[self.controlView zf_playMenuView:YES];
        [self.controlView zf_playTypeView:YES];
    }
    
    
    NSLog(@"autoplay...");
    [self.player shutdown];
    [[self.player view] removeFromSuperview];
    [self.controlView zf_playerCancelAutoFadeOutControlView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self removeMovieNotificationObservers];
    [self.timer invalidate];
    self.timer = nil;
    [self.controlView zf_playerStatusFailed:YES];
    
    if (self.isChangeResolution) { // 切换分辨率
        [self.controlView zf_playerResetControlViewForResolution];
        self.isChangeResolution = NO;
    }else { // 重置控制层View
        [self.controlView zf_playerResetControlView];
    }
    self.player = nil;
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.playerModel.videoURL withOptions:nil];
    
    
    UIView *playerView = [self.player view];
    self.backgroundColor = [UIColor blackColor];
    playerView.frame = self.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:playerView atIndex:0];
    //self = playerView;
    //[self installMovieNotificationObservers];
    [self addNotifications];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:panRecognizer];
    self.state = ABPlayerStateReadyToPlay;
    [self.player prepareToPlay];
    
    
    // 自动播放
    self.isAutoPlay = YES;
    
    // 添加播放进度计时器
    [self createTimer];
    
    // 获取系统音量
    [self configureVolume];
    
    // 本地文件不设置ZFPlayerStateBuffering状态
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = ABFPlayerStatePlaying;
        self.isLocalVideo = YES;
        [self.controlView zf_playerDownloadBtnState:NO];
    } else {
        self.state = ABFPlayerStateBuffering;
        self.isLocalVideo = NO;
        [self.controlView zf_playerDownloadBtnState:YES];
    }
    // 开始播放
    [self play];
    self.isPauseByUser = NO;
}

/**
 * 使用自带的控制层时候可使用此API
 */
- (void)playerModel:(ZFPlayerModel *)playerModel {
    // 指定默认控制层
    ZFPlayerControlView *defaultControlView = [[ZFPlayerControlView alloc] init];
    self.controlView = defaultControlView;
    self.playerModel = playerModel;
}


/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo {
    // 设置Player相关参数
    NSLog(@"autoplay...");
    [self configZFPlayer];
}

-(void)destory{
    NSLog(@"autoplay...");
    [self.player shutdown];
    self.tableView  = nil;
    [[self.player view] removeFromSuperview];
    
    ZFPlayerShared.isLockScreen = NO;
    [self.controlView zf_playerCancelAutoFadeOutControlView];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    // 移除time观察者
    //if (self.timeObserve) {
    //[self.player removeTimeObserver:self.timeObserve];
    //.timeObserve = nil;
    //}
    [self removeMovieNotificationObservers];
    self.player = nil;
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    [self removeFromSuperview];
    [view addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
}

/**
 *  重置player
 */
- (void)resetPlayer {
    // 改为为播放完
    self.playDidEnd         = NO;
    //self.playerItem         = nil;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    self.isAutoPlay         = NO;
    //if (self.timeObserve) {
        //[self.player removeTimeObserver:self.timeObserve];
        //self.timeObserve = nil;
    //}
    [self removeMovieNotificationObservers];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    // 移除原来的layer
    //[[self.player view] removeFromSuperlayer];
    [[self.player view] removeFromSuperview];
    // 替换PlayerItem为nil
    //[self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    //self.imageGenerator = nil;
    self.player         = nil;
    if (self.isChangeResolution) { // 切换分辨率
        [self.controlView zf_playerResetControlViewForResolution];
        self.isChangeResolution = NO;
    }else { // 重置控制层View
        [self.controlView zf_playerResetControlView];
    }
    self.controlView   = nil;
    // 非重播时，移除当前playerView
    if (!self.repeatToPlay) { [self removeFromSuperview]; }
    // 底部播放video改为NO
    self.isBottomVideo = NO;
    // cell上播放视频 && 不是重播时
    if (self.isCellVideo && !self.repeatToPlay) {
        // vicontroller中页面消失
        self.viewDisappear = YES;
        self.isCellVideo   = NO;
        self.tableView     = nil;
        self.indexPath     = nil;
    }
}

- (void)resetToPlayNewVideo:(ZFPlayerModel *)playerModel {
    
    [self destory];
    self.repeatToPlay = YES;
    [self resetPlayer];
    self.playerModel = playerModel;
    [self configZFPlayer];
}

/**
 *  播放
 */
- (void)play {
    NSLog(@"playing");
    [self.controlView zf_playerPlayBtnState:YES];
    /*
    if (self.state == ABFPlayerStatePause) { self.state = ABFPlayerStatePlaying; }
    self.isPauseByUser = NO;
    if (![self.player isPlaying]) {
        [self.player play];
    }*/
    
    NSLog(@"state=%ld",self.state);
    if(self.state == ABFPlayerStatePause){
        self.state = ABPlayerStateReadyToPlay;
        [self.controlView zf_playerActivity:YES];
    }
    
    if (self.state == ABPlayerStateReadyToPlay || self.state == ABFPlayerStatePause || self.state == ABFPlayerStateBuffering) {
        //[self.controlView zf_playerActivity:YES];
        [self.player play];
        self.isPauseByUser = NO;
        if (self.player.playbackRate > 0) {
            //[self.controlView zf_playerActivity:NO];
            self.state = ABFPlayerStatePlaying;
        }
    }
    
    //[_player play];
    if (!self.isBottomVideo) {
        // 显示控制层
        [self.controlView zf_playerCancelAutoFadeOutControlView];
        
        if(self.isTypeView || self.isMenuView){
        }else{
            [self.controlView zf_playerShowControlView];
        }
    }
}

/**
 * 暂停
 */
- (void)pause {
    [self.controlView zf_playerActivity:NO];
    [self.controlView zf_playerPlayBtnState:NO];
    if (self.state == ABFPlayerStatePlaying) { self.state = ABFPlayerStatePause;}
    self.isPauseByUser = YES;
    [_player pause];
}

/**
 *  用于cell上播放player
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 */
- (void)cellVideoWithTableView:(UITableView *)tableView
                   AtIndexPath:(NSIndexPath *)indexPath {
    // 如果页面没有消失，并且playerItem有值，需要重置player(其实就是点击播放其他视频时候)
    //if (!self.viewDisappear && self.playerItem) { [self resetPlayer]; }
    // 在cell上播放视频
    self.isCellVideo      = YES;
    // viewDisappear改为NO
    self.viewDisappear    = NO;
    // 设置tableview
    self.tableView        = tableView;
    // 设置indexPath
    self.indexPath        = indexPath;
    // 在cell播放
    [self.controlView zf_playerCellPlay];
}

/**
 *  设置Player相关参数
 */
- (void)configZFPlayer {
    //self.urlAsset = [AVURLAsset assetWithURL:self.videoURL];
    // 初始化playerItem
    //self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    //self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    // 初始化playerLayer
    //self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //NSURL *url =[NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"];
    NSLog(@"url=%@",self.playerModel.videoURL);
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.playerModel.videoURL withOptions:nil];
    
    self.backgroundColor = [UIColor blackColor];
    // 此处为默认视频填充模式
    //self.player.videoGravity = ABFPlayerLayerGravityResizeAspect;
    UIView *playerView = [self.player view];
    self.backgroundColor = [UIColor blackColor];
    playerView.frame = self.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:playerView atIndex:0];
    
    //self = playerView;
    [self installMovieNotificationObservers];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:panRecognizer];
    self.state = ABPlayerStateReadyToPlay;
    [self.player prepareToPlay];
    
    
    // 自动播放
    self.isAutoPlay = YES;
    
    // 添加播放进度计时器
    [self createTimer];
    
    // 获取系统音量
    [self configureVolume];
    
    // 本地文件不设置ZFPlayerStateBuffering状态
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = ABFPlayerStatePlaying;
        self.isLocalVideo = YES;
        [self.controlView zf_playerDownloadBtnState:NO];
    } else {
        self.state = ABFPlayerStateBuffering;
        self.isLocalVideo = NO;
        [self.controlView zf_playerDownloadBtnState:YES];
    }
    // 开始播放
    [self play];
    self.isPauseByUser = NO;
}

/**
 *  创建手势
 */
- (void)createGesture {
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    
    [self addGestureRecognizer:self.doubleTap];
    
    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isAutoPlay) {
        UITouch *touch = [touches anyObject];
        if(touch.tapCount == 1) {
            [self performSelector:@selector(singleTapAction:) withObject:@(NO) ];
        } else if (touch.tapCount == 2) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction:) object:nil];
            [self doubleTapAction:touch.gestureRecognizers.lastObject];
        }
    }
}

- (void)createTimer {
    //__weak typeof(self) weakSelf = self;
    /*
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf.controlView zf_playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
        }
    }];*/
}

/**
 *  获取系统音量
 */
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

/**
 *  耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [self play];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
}

#pragma mark - tableViewContentOffset

/**
 *  缩小到底部，显示小视频
 */
- (void)updatePlayerViewToBottom {
    if (self.isBottomVideo) { return; }
    self.isBottomVideo = YES;
    if (self.playDidEnd) { // 如果播放完了，滑动到小屏bottom位置时，直接resetPlayer
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
        return;
    }
    [self layoutIfNeeded];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = ScreenWidth*0.5-20;
        CGFloat height = (self.bounds.size.height / self.bounds.size.width);
        make.width.mas_equalTo(width);
        make.height.equalTo(self.mas_width).multipliedBy(height);
        make.trailing.mas_equalTo(-10);
        make.bottom.mas_equalTo(-self.tableView.contentInset.bottom-10);
    }];
    // 小屏播放
    [self.controlView zf_playerBottomShrinkPlay];
}


/**
 *  回到cell显示
 */
- (void)updatePlayerViewToCell {
    if (!self.isBottomVideo) { return; }
    self.isBottomVideo = NO;
    [self setOrientationPortraitConstraint];
    [self.controlView zf_playerCellPlay];
}

/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    [self toOrientation:orientation];
    self.isFullScreen = YES;
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    if (self.isCellVideo) {
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        NSArray *visableCells = self.tableView.visibleCells;
        self.isBottomVideo = NO;
        if (![visableCells containsObject:cell]) {
            [self updatePlayerViewToBottom];
        } else {
            [self addPlayerToFatherView:self.playerModel.fatherView];
        }
    } else {
        [self addPlayerToFatherView:self.playerModel.fatherView];
    }
    
    [self toOrientation:UIInterfaceOrientationPortrait];
    self.isFullScreen = NO;
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self removeFromSuperview];
            ZFBrightnessView *brightnessView = [ZFBrightnessView sharedBrightnessView];
            [[UIApplication sharedApplication].keyWindow insertSubview:self belowSubview:brightnessView];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenHeight));
                make.height.equalTo(@(ScreenWidth));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }
    }
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];
    // 开始旋转
    [UIView commitAnimations];
    [self.controlView layoutIfNeeded];
    [self.controlView setNeedsLayout];
}

/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark 屏幕转屏相关

/**
 *  屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
    }
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    if (!self.player) { return; }
    if (ZFPlayerShared.isLockScreen) { return; }
    if (self.didEnterBackground) { return; };
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            if (self.isFullScreen) {
                [self toOrientation:UIInterfaceOrientationPortrait];
                
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                self.isFullScreen = YES;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
                self.isFullScreen = YES;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            }
        }
            break;
        default:
            break;
    }
}


// 状态条变化通知（在前台播放才去处理）
- (void)onStatusBarOrientationChange {
    if (!self.didEnterBackground) {
        // 获取到当前状态条的方向
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self setOrientationPortraitConstraint];
            if (self.cellPlayerOnCenter) {
                [self.tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            [self.brightnessView removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(155);
                make.leading.mas_equalTo((ScreenWidth-155)/2);
                make.top.mas_equalTo((ScreenHeight-155)/2);
            }];
        } else {
            if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            } else if (currentOrientation == UIDeviceOrientationLandscapeLeft){
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            [self.brightnessView removeFromSuperview];
            [self addSubview:self.brightnessView];
            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.width.height.mas_equalTo(155);
            }];
            
        }
    }
}


/**
 *  锁定屏幕方向按钮
 *
 *  @param sender UIButton
 */
- (void)lockScreenAction:(UIButton *)sender {
    sender.selected             = !sender.selected;
    self.isLocked               = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏，在TabBarController设置哪些页面支持旋转
    ZFPlayerShared.isLockScreen = sender.selected;
}

/**
 *  解锁屏幕方向锁定
 */
- (void)unLockTheScreen {
    // 调用AppDelegate单例记录播放状态是否锁屏
    ZFPlayerShared.isLockScreen = NO;
    [self.controlView zf_playerLockBtnState:NO];
    self.isLocked = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    self.state = ABFPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        //if (!self.playerItem.isPlaybackLikelyToKeepUp) { [self bufferingSomeSecond]; }
        
    });
}

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
/*
- (NSTimeInterval)availableDuration {
 
    NSArray *loadedTimeRanges = [[_player c] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return nil;
}*/

/**
 *  播放完了
 *
 *  @param notification 通知
 */
- (void)moviePlayDidEnd:(NSNotification *)notification {
    self.state = ABFPlayerStateStopped;
    if (self.isBottomVideo && !self.isFullScreen) { // 播放完了，如果是在小屏模式 && 在bottom位置，直接关闭播放器
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
    } else {
        if (!self.isDragged) { // 如果不是拖拽中，直接结束播放
            self.playDidEnd = YES;
            [self.controlView zf_playerPlayEnd];
        }
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    self.didEnterBackground     = YES;
    // 退到后台锁定屏幕方向
    ZFPlayerShared.isLockScreen = YES;
    [_player pause];
    self.state                  = ABFPlayerStatePause;
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    self.didEnterBackground     = NO;
    // 根据是否锁定屏幕方向 来恢复单例里锁定屏幕的方向
    ZFPlayerShared.isLockScreen = self.isLocked;
    if (!self.isPauseByUser) {
        self.state         = ABFPlayerStatePlaying;
        self.isPauseByUser = NO;
        [self play];
    }
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)())completionHandler {
    
    if (self.state == ABPlayerStateReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        [self.controlView zf_playerActivity:YES];
        [self.player pause];
        //CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1); //kCMTimeZero
       // __weak typeof(self) weakSelf = self;
        
        // 只要快进, 那么就不是被用户暂停
        self.isPauseByUser = NO;
        self.player.currentPlaybackTime = dragedSeconds;
        // 视频跳转回调
        if (completionHandler) { completionHandler(); }
        __weak typeof(self) weakSelf = self;
        //NSInteger dragedSeconds = floorf(self.player.duration * value);
        [self.controlView zf_playerPlayBtnState:YES];
        [self seekToTime:dragedSeconds completionHandler:^(){
            //self.playerStatusModel.dragged = NO;
            //[wself.playerMgr play];
            // 延迟隐藏控制层
            //[self.videoPlayerView.playerControlView autoFadeOutControlView];
            NSLog(@"seektime水平移动");
            [weakSelf.controlView zf_playerActivity:NO];
            // 视频跳转回调
            weakSelf.player.currentPlaybackTime = dragedSeconds;
            //if (completionHandler) { completionHandler(); }
            [weakSelf.player play];
            weakSelf.seekTime = 0;
            weakSelf.isDragged = NO;
            
            // 结束滑动
            [weakSelf.controlView zf_playerDraggedEnd];
            if (self.state == ABPlayerStateReadyToPlay || self.state == ABFPlayerStatePause || self.state == ABFPlayerStateBuffering) {
                if (self.player.playbackRate > 0) {
                    self.state = ABFPlayerStatePlaying;
                }
            }
        }];
        
        //[self.player play];
        
        
    }
    
    
    
    if(dragedSeconds > 0){
        [self.player pause];
        // 只要快进, 那么就不是被用户暂停
        //self.playerStatusModel.pauseByUser = NO;
        self.player.currentPlaybackTime = dragedSeconds;
        // 视频跳转回调
        [self.controlView zf_playerActivity:NO];
        //if (completionHandler) { completionHandler(); }
        [self.player play];
        self.seekTime = 0;
        self.isDragged = NO;
        [self.controlView zf_playerDraggedEnd];
        if (self.state == ABPlayerStateReadyToPlay || self.state == ABFPlayerStatePause || self.state == ABFPlayerStateBuffering) {
            if (self.player.playbackRate > 0) {
                self.state = ABFPlayerStatePlaying;
            }
        }
    }
    
    
}

/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值
                //CMTime time       = CMTimeMakeWithSeconds([_player currentPlaybackTime],1) ;
                self.sumTime      = [_player currentPlaybackTime];
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    self.isPauseByUser = NO;
                    [self seekToTime:self.sumTime completionHandler:nil];
                    // 把sumTime滞空，不然会越加越多
                    [self.player play];
                    self.sumTime = 0;
                    self.seekTime = 0;
                    [self.controlView zf_playerDraggedEnd];
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value {
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    //CMTime totalTime           = CMTimeMakeWithSeconds([self.player duration],1000000);
    //CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    CGFloat totalMovieDuration = self.player.duration;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    self.isDragged = YES;
    [self.controlView zf_playerDraggedTime:self.sumTime totalTime:totalMovieDuration isForward:style hasPreview:NO];
}

/**
 *  根据时长求出字符串
 *
 *  @param time 时长
 *
 *  @return 时长字符串
 */
- (NSString *)durationStringWithTime:(int)time {
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if ((self.isCellVideo && !self.isFullScreen) || self.playDidEnd || self.isLocked){
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.isBottomVideo && !self.isFullScreen) {
            return NO;
        }
    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Setter

/**
 *  videoURL的setter方法
 *
 *  @param videoURL videoURL
 */
- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    
    // 每次加载视频URL都设置重播为NO
    self.repeatToPlay = NO;
    self.playDidEnd   = NO;
    
    // 添加通知
    [self addNotifications];
    
    self.isPauseByUser = YES;
    
    // 添加手势
    [self createGesture];
    
}

/**
 *  设置播放的状态
 *
 *  @param state ZFPlayerState
 */
- (void)setState:(ABFPlayerState)state {
    _state = state;
    // 控制菊花显示、隐藏
    //[self.controlView zf_playerActivity:state == ABFPlayerStateBuffering];
    //[self.controlView zf_playerActivity:state == ABPlayerStateReadyToPlay];
    
    if(state ==  ABFPlayerStateBuffering ){
        [self.controlView zf_playerActivity:YES];
    }else if( state == ABFPlayerStatePause || state == ABPlayerStateReadyToPlay){
        [self.controlView zf_playerActivity:NO];
    }
    
    
    if (state == ABFPlayerStatePlaying || state == ABFPlayerStateBuffering) {
        // 隐藏占位图
        [self.controlView zf_playerItemPlaying];
    } else if (state == ABFPlayerStateFailed) {
        //NSError *error =[self.player ]
        [self.controlView zf_playerActivity:NO];
        [self.controlView zf_playerItemStatusFailed:nil];
    }
    /*
    switch (state) {
        case ABPlayerStateReadyToPlay:{
            
            [self.controlView zf_playerActivity:NO];
        }
            break;
        case ABFPlayerStatePlaying: {
            [self.controlView zf_playerItemPlaying];
            self.isPauseByUser = NO;
        }
            break;
        case ABFPlayerStatePause: {
            
            self.isPauseByUser = YES;
        }
            break;
        case ABFPlayerStateStopped: {
            [self.controlView zf_playerPlayEnd];
        }
            break;
        case ABFPlayerStateBuffering: {
            [self.controlView zf_playerItemPlaying];
            [self.controlView zf_playerActivity:NO];
        }
            break;
        case ABFPlayerStateFailed: {
            [self.controlView zf_playerItemStatusFailed:nil];
        }
            break;
        default:
            break;
    }*/
    
}

/**
 *  根据tableview的值来添加、移除观察者
 *
 *  @param tableView tableView
 */
- (void)setTableView:(UITableView *)tableView {
    if (_tableView == tableView) { return; }
    if (_tableView) {
        [_tableView removeObserver:self forKeyPath:kZFPlayerViewContentOffset];
    }
    _tableView = tableView;
    if (tableView) { [tableView addObserver:self forKeyPath:kZFPlayerViewContentOffset options:NSKeyValueObservingOptionNew context:nil]; }
}

/**
 *  设置playerLayer的填充模式
 *
 *  @param playerLayerGravity playerLayerGravity
 */
- (void)setPlayerLayerGravity:(ABFPlayerLayerGravity)playerLayerGravity {
    _playerLayerGravity = playerLayerGravity;
    switch (playerLayerGravity) {
        case ABFPlayerLayerGravityResize:
            //是拉伸视频内容达到边框占满，但不按原比例拉伸
            //self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            [_player setScalingMode:IJKMPMovieScalingModeFill];
            break;
        case ABFPlayerLayerGravityResizeAspect:
            //是按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑；
            //self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
            break;
        case ABFPlayerLayerGravityResizeAspectFill:
            //直到两边屏幕都占满，但视频内容有部分就被切割了
            [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
            //self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            break;
    }
}

/**
 *  是否有下载功能
 */
- (void)setHasDownload:(BOOL)hasDownload {
    _hasDownload = hasDownload;
    [self.controlView zf_playerHasDownloadFunction:hasDownload];
}

- (void)setResolutionDic:(NSDictionary *)resolutionDic {
    _resolutionDic = resolutionDic;
    [self.controlView zf_playerResolutionArray:[resolutionDic allKeys]];
    self.videoURLArray = [resolutionDic allValues];
}

- (void)setControlView:(UIView *)controlView {
    if (_controlView) { return; }
    _controlView = controlView;
    controlView.delegate = self;
    [self layoutIfNeeded];
    [self addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setPlayerModel:(ZFPlayerModel *)playerModel {
    _playerModel = playerModel;
    NSCAssert(playerModel.fatherView, @"请指定playerView的faterView");
    
    if (playerModel.seekTime) { self.seekTime = playerModel.seekTime; }
    [self.controlView zf_playerModel:playerModel];
    
    if (playerModel.tableView && playerModel.indexPath && playerModel.videoURL) {
        [self cellVideoWithTableView:playerModel.tableView AtIndexPath:playerModel.indexPath];
        if (playerModel.resolutionDic) { self.resolutionDic = playerModel.resolutionDic; }
    }
    [self addPlayerToFatherView:playerModel.fatherView];
    self.videoURL = playerModel.videoURL;
}

#pragma mark - Getter



- (ZFBrightnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [ZFBrightnessView sharedBrightnessView];
    }
    return _brightnessView;
}

#pragma mark - ZFPlayerControlViewDelegate

- (void)zf_controlView:(UIView *)controlView playAction:(UIButton *)sender {
    self.isPauseByUser = !self.isPauseByUser;
    if (self.isPauseByUser) {
        [self pause];
        
        if (self.state == ABFPlayerStatePlaying) { self.state = ABFPlayerStatePause;}
    } else {
        [self play];
        if (self.state == ABFPlayerStatePause) { self.state = ABFPlayerStatePlaying; }
    }
    
    if (!self.isAutoPlay) {
        self.isAutoPlay = YES;
        [self configZFPlayer];
    }
}

- (void)zf_controlView:(UIView *)controlView backAction:(UIButton *)sender {
    if (ZFPlayerShared.isLockScreen) {
        [self unLockTheScreen];
    } else {
        if (!self.isFullScreen) {
            // player加到控制器上，只有一个player时候
            [self pause];
            if ([self.delegate respondsToSelector:@selector(abf_playerBackAction)]) { [self.delegate abf_playerBackAction]; }
        } else {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
    }
}

- (void)zf_controlView:(UIView *)controlView closeAction:(UIButton *)sender {
    [self resetPlayer];
    [self removeFromSuperview];
}

- (void)zf_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender {
    [self _fullScreenAction];
}

- (void)zf_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender {
    self.isLocked               = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏
    ZFPlayerShared.isLockScreen = sender.selected;
}

- (void)zf_controlView:(UIView *)controlView cneterPlayAction:(UIButton *)sender {
    [self configZFPlayer];
}

- (void)zf_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender {
    // 没有播放完
    self.playDidEnd   = NO;
    // 重播改为NO
    self.repeatToPlay = NO;
    [self seekToTime:0 completionHandler:nil];
    
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = ABFPlayerStatePlaying;
    } else {
        self.state = ABFPlayerStateBuffering;
    }
}

/** 加载失败按钮事件 */
- (void)zf_controlView:(UIView *)controlView failAction:(UIButton *)sender {
    [self configZFPlayer];
}

- (void)zf_controlView:(UIView *)controlView cutAction:(UIButton *)sender {
    //[self configZFPlayer];
    if ([self.delegate respondsToSelector:@selector(abf_playerCutImage)]) {
        [self.delegate abf_playerCutImage];
    }
}



- (UIImage *)image{
    _image = _player.thumbnailImageAtCurrentTime;
    return _image;
}

- (void)zf_controlView:(UIView *)controlView resolutionAction:(UIButton *)sender {
    // 记录切换分辨率的时刻
    NSInteger currentTime = (NSInteger)([self.player currentPlaybackTime]);
    NSString *videoStr = self.videoURLArray[sender.tag - 200];
    NSURL *videoURL = [NSURL URLWithString:videoStr];
    if ([videoURL isEqual:self.videoURL]) { return; }
    self.isChangeResolution = YES;
    // reset player
    [self resetToPlayNewURL];
    self.videoURL = videoURL;
    // 从xx秒播放
    self.seekTime = currentTime;
    // 切换完分辨率自动播放
    [self autoPlayTheVideo];
}

- (void)zf_controlView:(UIView *)controlView downloadVideoAction:(UIButton *)sender {
    //NSString *urlStr = self.videoURL.absoluteString;
    //if ([self.delegate respondsToSelector:@selector(zf_playerDownload:)]) {
        //[self.delegate abf_playerDownload:urlStr];
    //}
}

- (void)zf_controlView:(UIView *)controlView menuAction:(UIButton *)sender{
    NSLog(@"...menu");
    self.isMenuView = YES;
    [self.controlView zf_playerHideControlView];
    [self.controlView zf_playMenuView:NO];
    [self.controlView zf_playTypeView:YES];
    self.isTypeView = NO;
    
    
}

- (void)zf_controlView:(UIView *)controlView typeAction:(UIButton *)sender{
    NSLog(@"...type");
    self.isTypeView = YES;
    [self.controlView zf_playerHideControlView];
    [self.controlView zf_playTypeView:NO];
    [self.controlView zf_playMenuView:YES];
    self.isMenuView = NO;
}

- (void)zf_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value {
    // 视频总时间长度
    /*
    CGFloat total = (CGFloat)[self.player duration]/ [self.player t;
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(total * value);
    
    [self.controlView zf_playerPlayBtnState:YES];
    [self seekToTime:dragedSeconds completionHandler:^(BOOL finished) {}];*/
    
}

- (void)zf_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider {
    // 拖动改变视频播放进度
    /*
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = YES;
        BOOL style = false;
        CGFloat value   = slider.value - self.sliderLastValue;
        if (value > 0) { style = YES; }
        if (value < 0) { style = NO; }
        if (value == 0) { return; }
        
        self.sliderLastValue  = slider.value;
        
        CGFloat totalTime     = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //计算出拖动的当前秒数
        CGFloat dragedSeconds = floorf(totalTime * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime   = CMTimeMake(dragedSeconds, 1);
        
        [controlView zf_playerDraggedTime:dragedSeconds totalTime:totalTime isForward:style hasPreview:self.isFullScreen ? self.hasPreviewView : NO];
        
        if (totalTime > 0) { // 当总时长 > 0时候才能拖动slider
            if (self.isFullScreen && self.hasPreviewView) {
                
                [self.imageGenerator cancelAllCGImageGeneration];
                self.imageGenerator.appliesPreferredTrackTransform = YES;
                self.imageGenerator.maximumSize = CGSizeMake(100, 56);
                AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                    NSLog(@"%zd",result);
                    if (result != AVAssetImageGeneratorSucceeded) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [controlView zf_playerDraggedTime:dragedSeconds sliderImage:self.thumbImg ? : ZFPlayerImage(@"ZFPlayer_loading_bgView")];
                        });
                    } else {
                        self.thumbImg = [UIImage imageWithCGImage:im];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [controlView zf_playerDraggedTime:dragedSeconds sliderImage:self.thumbImg ? : ZFPlayerImage(@"ZFPlayer_loading_bgView")];
                        });
                    }
                };
                [self.imageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:dragedCMTime]] completionHandler:handler];
            }
        } else {
            // 此时设置slider值为0
            slider.value = 0;
        }
        
    }else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }*/
    
}

- (void)zf_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider {
    
    if ([self.player loadState] == AVPlayerItemStatusReadyToPlay) {
        self.isPauseByUser = NO;
        self.isDragged = NO;
        // 视频总时间长度
        CGFloat total           = [self.player duration];
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        [self seekToTime:dragedSeconds completionHandler:nil];
    }
}


/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[NSNumber class]] && ![(id)gesture boolValue]) {
        [self _fullScreenAction];
        return;
    }
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBottomVideo && !self.isFullScreen) { [self _fullScreenAction]; }
        else {
            if (self.playDidEnd) { return; }
            else {
                if(self.isTypeView || self.isMenuView){
                    
                }else{
                    [self.controlView zf_playerShowControlView];
                }
                
            }
        }
        if(self.isMenuView){
            NSLog(@"menuView hidden");
            
            [self.controlView zf_playMenuView:YES];
            self.isMenuView = NO;
        }
        
        if(self.isTypeView){
            
            NSLog(@"menuView hidden");
            [self.controlView zf_playTypeView:YES];
            self.isTypeView = NO;
        }
        
        
        
    }
}

/** 全屏 */
- (void)_fullScreenAction {
    if (ZFPlayerShared.isLockScreen) {
        [self unLockTheScreen];
        return;
    }
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.isFullScreen = NO;
        return;
    } else {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        self.isFullScreen = YES;
    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (self.playDidEnd) { return;  }
    // 显示控制层
    [self.controlView zf_playerCancelAutoFadeOutControlView];
    [self.controlView zf_playerShowControlView];
    if (self.isPauseByUser) { [self play]; }
    else { [self pause]; }
    if (!self.isAutoPlay) {
        self.isAutoPlay = YES;
        [self configZFPlayer];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma Selector func

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    //MPMovieLoadStateUnknown        = 0,     未知
    //MPMovieLoadStatePlayable       = 1 << 0,缓冲结束可以播放
    //MPMovieLoadStatePlaythroughOK  = 1 << 1,缓冲结束自动播放
    //MPMovieLoadStateStalled        = 1 << 2,Playback will be automatically paused in this state, if started
    
    
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
        self.state = ABPlayerStateReadyToPlay;
        [self.player play];
        /*
        if (self.seekTime) {
            self.player.currentPlaybackTime = self.seekTime;
            self.seekTime = 0; // 滞空, 防止下次播放出错
            [self.player play];
        }*/
        
        
        
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        
        self.state = ABFPlayerStateBuffering;
        // 当缓冲好的时候可能达到继续播放时
        //[self.player play];
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
            //直播结束
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            self.state = ABFPlayerStateStopped;
            
            
            break;
            //用户退出
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            //直播错误
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            self.state = ABFPlayerStateFailed;
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}
//用户操作
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    //    IJKMPMoviePlaybackStateStopped,        停止
    //    IJKMPMoviePlaybackStatePlaying,        正在播放
    //    IJKMPMoviePlaybackStatePaused,         暂停
    //    IJKMPMoviePlaybackStateInterrupted,    打断
    //    IJKMPMoviePlaybackStateSeekingForward, 快进
    //    IJKMPMoviePlaybackStateSeekingBackward 快退
    
    if (self.player.playbackState == IJKMPMoviePlaybackStatePlaying) {
        //视频开始播放的时候开启计时器
        //[self.controlView zf_playerActivity:NO];
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(update) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
    
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            _state = ABFPlayerStateStopped;
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            _state = ABFPlayerStatePlaying;
            [self.controlView zf_playerActivity:NO];
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            _state = ABFPlayerStatePause;
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            _state = ABPlayerStateReadyToPlay;
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark - 更新方法
- (void)update {
    double playProgress = self.player.currentPlaybackTime / self.player.duration;
    //[self.delegate changePlayProgress:playProgress second:self.player.currentPlaybackTime];
    
   // NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
    //CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
    //CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
    [self.controlView zf_playerCurrentTime:self.player.currentPlaybackTime totalTime:self.player.duration sliderValue:playProgress];
    
    
    
    double loadProgress = self.player.playableDuration / self.player.duration;
    
    
    
    // 计算缓冲进度
    //NSTimeInterval timeInterval = [self availableDuration];
    //CMTime duration             = self.playerItem.duration;
    //CGFloat totalDuration       = CMTimeGetSeconds(duration);
    [self.controlView zf_playerSetProgress:loadProgress ];
    
    //[self.delegate changeLoadProgress:loadProgress second:self.player.playableDuration];
}

- (void)installMovieNotificationObservers {
    //加载状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    //播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    //播放状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}

@end
