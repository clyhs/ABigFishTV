//
//  ABFPlayerView.m
//  ABigFishPlayer
//
//  Created by 陈立宇 on 2018/3/24.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "ABFPlayerView.h"
#import "ABFPlayerKit.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <AVFoundation/AVFoundation.h>


//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};


@interface ABFPlayerView()<UIGestureRecognizerDelegate>

@property (atomic,   retain)   id<IJKMediaPlayback>   player;
@property (nonatomic,strong)         ABFPlayerModel  *playerModel;
@property (nonatomic,strong)   ABFPlayerControlView  *controlView;
/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
/** 亮度view */
@property (nonatomic, strong) ABFBrightnessView      *brightnessView;
/** 滑杆 */
@property (nonatomic, strong) UISlider               *volumeViewSlider;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL                   isVolume;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection           panDirection;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat                sumTime;
/** 是否为全屏 */
@property (nonatomic, assign) BOOL                   isFullScreen;
/** 播放完了*/
@property (nonatomic, assign) BOOL                   playDidEnd;
/** 进入后台*/
@property (nonatomic, assign) BOOL                   didEnterBackground;
/** 是否锁定屏幕方向 */
@property (nonatomic, assign) BOOL                   isLocked;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                   isPauseByUser;
/** 是否自动播放 */
@property (nonatomic, assign) BOOL                   isAutoPlay;

@property (nonatomic, assign) NSInteger              seekTime;

@property (nonatomic, assign) NSInteger              menuSelectIndex;

/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL                   isDragged;

@property (nonatomic, assign) ABFPlayerState         state;
/** 是否再次设置URL播放视频 */
@property (nonatomic, assign) BOOL                   repeatToPlay;
/**是否显示源菜单**/
@property (nonatomic, assign) BOOL                   isShowMenu;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ABFPlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if(self){
        NSLog(@"ABFPlayerView init");
        self.menuSelectIndex = 0;
    }
    return self;
}


-(void)autoPlayTheVideo{
    NSLog(@"ABFPlayer auto play");
    [self configPlayer];
}

-(void)playOrPause{
    if(!self.player.isPlaying){
        [self.player play];
    }else{
        [self.player pause];
    }
}

-(void)play{
    NSLog(@"ABFPlayer play");
    if(!self.player.isPlaying){
        [self.controlView abf_playerPlayBtnState:YES];
        [self.player play];
        
    }
    [self.controlView abf_playerCancelAutoFadeOutControlView];
    [self.controlView abf_playerShowControlView];
    
}

-(void)pause{
    NSLog(@"ABFPlayer pause");
    [self.player pause];
    self.isPauseByUser = YES;
    [self.controlView abf_playerPlayBtnState:NO];
}

-(void)resetPlayer{
    // 改为为播放完
    self.playDidEnd         = NO;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    self.isAutoPlay         = NO;
    //[self removeMovieNotificationObservers];
    // 移除通知
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //移除原来的layer
    //[[self.player view] removeFromSuperview];
    //self.player         = nil;
    // 重置控制层View
    //[self.controlView abf_playerResetControlView];
    
    //self.controlView   = nil;
    // 非重播时，移除当前playerView
    //if (!self.repeatToPlay) { [self removeFromSuperview]; }
    
}

-(void)resetMenuForPlayer{
    // 改为为播放完
    
    [self.player shutdown];
    self.playDidEnd         = NO;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    self.isAutoPlay         = NO;
    [self removeMovieNotificationObservers];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    //移除原来的layer
    [[self.player view] removeFromSuperview];
    self.player         = nil;
    [self.timer invalidate];
    self.timer = nil;
    ABFPlayerShared.isLockScreen = NO;
    
    NSInteger count = [self.playerModel.urlArrays count];
    if(count > 0){
        for(int i=0;i<count;i++){
            if(i == self.menuSelectIndex){
                self.playerModel.currentVideoUrl =[NSURL URLWithString: self.playerModel.urlArrays[i]];
            }
        }
    }
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.playerModel.currentVideoUrl withOptions:nil];
    
    UIView *playerView = [self.player view];
    self.backgroundColor = [UIColor blackColor];
    playerView.frame = self.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:playerView atIndex:0];
    
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    [self.controlView abf_playerResetControlView];
    [self install];
    [self installMovieNotificationObservers];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:panRecognizer];
    
    self.isAutoPlay = YES;
    self.playDidEnd   = NO;
    self.isShowMenu = NO;
    [self createGesture];
    [self configureVolume];
    NSLog(@"init end ready to play");
    self.state = ABFPlayerStateReadyToPlay;
    [self.player prepareToPlay];
    [self play];
}

- (void)destory{
    [self.player shutdown];
    self.playDidEnd         = NO;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    self.isAutoPlay         = NO;
    [self removeMovieNotificationObservers];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    //移除原来的layer
    [[self.player view] removeFromSuperview];
    self.player         = nil;
    [self.timer invalidate];
    self.timer = nil;
    ABFPlayerShared.isLockScreen = NO;
}


- (void)dealloc {
    // 移除通知
    [self removeMovieNotificationObservers];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
}

-(void)configPlayer{
    //
    //http://webapi.abigfish.org/static/upload/video/2017-12-09/20171209102745.mp4
    NSURL *url =[NSURL URLWithString:@"http://183.252.176.13/ott.js.chinamobile.com/PLTV/88888888/224/3221225923/index.m3u8"];
    NSInteger count = [self.playerModel.urlArrays count];
    if(count > 0){
        for(int i=0;i<count;i++){
            if(i == self.menuSelectIndex){
                self.playerModel.currentVideoUrl =[NSURL URLWithString: self.playerModel.urlArrays[i]];
            }
        }
    }
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.playerModel.currentVideoUrl withOptions:nil];
    
    [self addPlayerToFatherView:self.playerModel.fatherView];
    
    self.backgroundColor = [UIColor blackColor];
    UIView *playerView = [self.player view];
    playerView.frame = self.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:playerView atIndex:0];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    [self install];
    [self installMovieNotificationObservers];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:panRecognizer];
    
    self.isAutoPlay = YES;
    self.playDidEnd   = NO;
    self.isShowMenu = NO;
    [self createGesture];
    [self configureVolume];
    NSLog(@"init end ready to play");
    self.state = ABFPlayerStateReadyToPlay;
    [self.player prepareToPlay];
    [self play];
}

/**
 *
 */
-(void)playControlView:(ABFPlayerControlView *)controlView playerModel:(ABFPlayerModel *)playerModel{
    _playerModel = playerModel;
    if (!controlView) {
        // 指定默认控制层
        ABFPlayerControlView *defaultControlView = [[ABFPlayerControlView alloc] init];
        self.controlView = defaultControlView;
        
    } else {
        self.controlView = controlView;
    }
    [self.controlView abf_playerModel:playerModel];
}

-(void)playerModel:(ABFPlayerModel *)playerModel{
    ABFPlayerControlView *defaultControlView = [[ABFPlayerControlView alloc] init];
    self.controlView = defaultControlView;
    self.playerModel = playerModel;
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



- (void)setControlView:(ABFPlayerControlView *)controlView{
    if (_controlView) { return; }
    _controlView = controlView;
    controlView.delegate = self;
    [self layoutIfNeeded];
    [self addSubview:controlView];
    //[self insertSubview:controlView atIndex:2];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setPlayerModel:(ABFPlayerModel *)playerModel{
    _playerModel = playerModel;
    [self.controlView abf_playerModel:playerModel];
    [self addPlayerToFatherView:playerModel.fatherView];
}

- (void)setState:(ABFPlayerState)state{
    _state = state;
    NSLog(@"player state");
    if(state ==  ABFPlayerStateBuffering || state == ABFPlayerStateReadyToPlay){
        [self.controlView abf_playerStatusFailed:YES];
        [self.controlView abf_playerActivity:YES];
    
    }else if( state == ABFPlayerStatePause
             || state == ABFPlayerStatePlaying){
        [self.controlView abf_playerStatusFailed:YES];
        [self.controlView abf_playerActivity:NO];
        [self.controlView abf_playerPlaying];
    }
    
    
    if (state == ABFPlayerStatePlaying || state == ABFPlayerStateBuffering) {
        // 隐藏占位图
        //[self.controlView abf_playerItemPlaying];
    } else if (state == ABFPlayerStateFailed) {
        //NSError *error =[self.player ]
        [self.controlView abf_playerActivity:NO];
        [self.controlView abf_playerItemStatusFailed:nil];
    }
}

- (void)install{
    
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监听耳机插入和拔掉通知
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];*/
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(onDeviceOrientationChange)
        name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(onStatusBarOrientationChange)
        name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}

- (void)fullScreenAction {
    if (ABFPlayerShared.isLockScreen) {
        [self unLockTheScreen];
        return;
    }
    NSLog(@"fullscreenaction start");
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

#pragma mark 屏幕转屏相关

/**
 *  屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    NSLog(@"interfaceOrientation start");
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
    if (ABFPlayerShared.isLockScreen) { return; }
    if (self.didEnterBackground) { return; };
    //if (self.playerPushedOrPresented) { return; }
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

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    NSLog(@"toOrientation start");
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self removeFromSuperview];
            
            ABFBrightnessView *brightnessView = [ABFBrightnessView sharedBrightnessView];
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


/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    NSLog(@"setOrientationLandscapeConstraint start");
    [self toOrientation:orientation];
    self.isFullScreen = YES;
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    /*
    if (self.isCellVideo) {
        if ([self.scrollView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self.scrollView;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.indexPath];
            self.isBottomVideo = NO;
            if (![tableView.visibleCells containsObject:cell]) {
                [self updatePlayerViewToBottom];
            } else {
                UIView *fatherView = [cell.contentView viewWithTag:self.playerModel.fatherViewTag];
                [self addPlayerToFatherView:fatherView];
            }
        } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)self.scrollView;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.indexPath];
            self.isBottomVideo = NO;
            if (![collectionView.visibleCells containsObject:cell]) {
                [self updatePlayerViewToBottom];
            } else {
                UIView *fatherView = [cell viewWithTag:self.playerModel.fatherViewTag];
                [self addPlayerToFatherView:fatherView];
            }
        }
    }*/// else {
    [self addPlayerToFatherView:self.playerModel.fatherView];
    //}
    
    [self toOrientation:UIInterfaceOrientationPortrait];
    self.isFullScreen = NO;
}


// 状态条变化通知（在前台播放才去处理）
- (void)onStatusBarOrientationChange {
    if (!self.didEnterBackground) {
        // 获取到当前状态条的方向
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self setOrientationPortraitConstraint];
            /*
            if (self.cellPlayerOnCenter) {
                if ([self.scrollView isKindOfClass:[UITableView class]]) {
                    UITableView *tableView = (UITableView *)self.scrollView;
                    [tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    
                } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
                    UICollectionView *collectionView = (UICollectionView *)self.scrollView;
                    [collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                }
            }*/
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
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    self.didEnterBackground     = YES;
    // 退到后台锁定屏幕方向
    ABFPlayerShared.isLockScreen = YES;
    [_player pause];
    //self.state                  = ZFPlayerStatePause;
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    self.didEnterBackground     = NO;
    // 根据是否锁定屏幕方向 来恢复单例里锁定屏幕的方向
    ABFPlayerShared.isLockScreen = self.isLocked;
    /*
    if (!self.isPauseByUser) {
        self.state         = ZFPlayerStatePlaying;
        self.isPauseByUser = NO;
        [self play];
    }*/
    [self play];
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

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    /*
    if ([gesture isKindOfClass:[NSNumber class]] && ![(id)gesture boolValue]) {
        [self fullScreenAction];
        return;
    }
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (!self.isFullScreen) { [self fullScreenAction]; }
        else {
            if (self.playDidEnd) { return; }
            else {
                [self.controlView abf_playerShowControlView];
            }
        }
    }*/
    if(self.isShowMenu){
        [self.controlView abf_playerMenuSetting:NO index:0];
    }
    if (self.playDidEnd) { return; }
    else {
        [self.controlView abf_playerShowControlView];
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
    [self.controlView abf_playerCancelAutoFadeOutControlView];
    [self.controlView abf_playerShowControlView];
    if (self.isPauseByUser) {
        [self play];
        self.isPauseByUser = NO;
    }
    else {
        [self pause];
        self.isPauseByUser = YES;
    }
    if (!self.isAutoPlay) {
        self.isAutoPlay = YES;
        [self configPlayer];
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
                    [self.controlView abf_playerDraggedEnd];
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
    [self.controlView abf_playerDraggedTime:self.sumTime totalTime:totalMovieDuration isForward:style hasPreview:NO];
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

/**
 *  锁定屏幕方向按钮
 *
 *  @param sender UIButton
 */
- (void)lockScreenAction:(UIButton *)sender {
    sender.selected             = !sender.selected;
    self.isLocked               = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏，在TabBarController设置哪些页面支持旋转
    ABFPlayerShared.isLockScreen = sender.selected;
}

/**
 *  解锁屏幕方向锁定
 */
- (void)unLockTheScreen {
    // 调用AppDelegate单例记录播放状态是否锁屏
    ABFPlayerShared.isLockScreen = NO;
    [self.controlView abf_playerLockBtnState:NO];
    self.isLocked = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

-(ABFBrightnessView *)brightnessView{
    if(!_brightnessView){
        _brightnessView = [ABFBrightnessView sharedBrightnessView];
    }
    return _brightnessView;
}


- (void)abf_controlView:(UIView *)controlView playAction:(UIButton *)sender{
    NSLog(@"play or pause");
    [self playOrPause];
}

- (void)abf_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender {
    NSLog(@"abf_controlView fullscreenaction start");
    [self fullScreenAction];
}

- (void)abf_controlView:(UIView *)controlView closeAction:(UIButton *)sender {
    //[self resetPlayer];
    [self removeFromSuperview];
}
- (void)abf_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender {
    self.isLocked               = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏
    ABFPlayerShared.isLockScreen = sender.selected;
}
- (void)abf_controlView:(UIView *)controlView backAction:(UIButton *)sender {
    NSLog(@"back");
    if (ABFPlayerShared.isLockScreen) {
        [self unLockTheScreen];
    } else {
        if (!self.isFullScreen) {
            // player加到控制器上，只有一个player时候
            [self pause];
            [self destory];
            if ([self.delegate respondsToSelector:@selector(abf_playerBackAction)]) { [self.delegate abf_playerBackAction]; }
        } else {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
    }
}

- (void)abf_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender {
    // 没有播放完
    self.playDidEnd   = NO;
    // 重播改为NO
    self.repeatToPlay = NO;
    //[self seekToTime:0 completionHandler:nil];
    [self.player pause];
    self.isDragged = NO;
    self.player.currentPlaybackTime = 0;
    [self.player play];
    
    //self.state = ABFPlayerStateReadyToPlay;
}

/** 加载失败按钮事件 */
- (void)abf_controlView:(UIView *)controlView failAction:(UIButton *)sender {
    //[self configPlayer];
    [self.controlView abf_playerMenuSelect:self.menuSelectIndex];
    [self resetMenuForPlayer];
}

- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler {
    NSLog(@"seekToTime");
    
    if(dragedSeconds > 0){
        [self.player pause];
        self.isDragged = NO;
        self.player.currentPlaybackTime = dragedSeconds;
        
        [self.player play];
    }
    
}

- (void)abf_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value {
    // 视频总时间长度
    CGFloat total           = [self.player duration];
    NSLog(@"video total=%f",total);
    NSInteger dragedSeconds = floorf(total * value);
    NSLog(@"video drageSeconds=%ld",dragedSeconds);
    [self seekToTime:dragedSeconds completionHandler:^(BOOL finished) {}];
}

- (void)abf_controlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider{
    NSLog(@"progressSliderTouchBegan");
}

- (void)abf_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider{
    NSLog(@"progressSliderValueChanged");
    CGFloat total           = [self.player duration];
    NSLog(@"video total=%f",total);
    //NSInteger dragedSeconds = floorf(total * slider.value);
    if(total > 0){
        
    }else {
        // 此时设置slider值为0
        slider.value = 0;
    }
    
}

- (void)abf_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider{
    NSLog(@"progressSliderTouchEnded");
    CGFloat total           = [self.player duration];
    NSLog(@"video total=%f",total);
    NSInteger dragedSeconds = floorf(total * slider.value);
    [self seekToTime:dragedSeconds completionHandler:nil];
    
}

- (void)abf_controlView:(UIView *)controlView menuAction:(UIButton *)sender{
    self.isShowMenu = YES;
    [self.controlView abf_playerMenuSetting:YES index:0];
}

- (void)abf_controlView:(UIView *)controlView menulabAction:(id)sender{
    NSLog(@"hhh");
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *view = (UIView *)tap.view;
    NSLog(@"hhh index=%ld",view.tag);
    self.menuSelectIndex = view.tag;
    [self.controlView abf_playerMenuSelect:view.tag];
    [self resetMenuForPlayer];
    //[self configPlayer];
    
}


- (void)createTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)update {
    double playProgress = self.player.currentPlaybackTime / self.player.duration;
    [self.controlView abf_playerCurrentTime:self.player.currentPlaybackTime totalTime:self.player.duration sliderValue:playProgress];
}






- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        ////已经缓存完成，如果设置了自动播放，这时会自动播放
        NSLog(@"缓冲结束自动播放");
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
        self.state = ABFPlayerStateReadyToPlay;
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        ////数据缓存已经停止，播放将暂停
        NSLog(@"数据缓存已经停止，播放将暂停");
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        self.state = ABFPlayerStateBuffering;
    } else {
        // 未知状态
        NSLog(@"未知状态");
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
        self.state = ABFPlayerStateFailed;
    }
}

- (void)moviePlayDidEnd{
    if (!self.isDragged) {
        // 播放完了，如果是在小屏模式 && 在bottom位置，直接关闭播放器
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
        [self.controlView abf_playerPlayEnd];
    } else {
        // 如果不是拖拽中，直接结束播放
        self.playDidEnd = YES;
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            //直播结束
            NSLog(@"完成原因 直播结束");
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            [self moviePlayDidEnd];
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            //用户退出
            NSLog(@"完成原因 用户退出");
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            //直播错误
            NSLog(@"完成原因 直播错误");
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            self.state = ABFPlayerStateFailed;
            break;
            
        default:
            NSLog(@"完成原因 未知");
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            self.state = ABFPlayerStateFailed;
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    
    //    NSLog(@"%@",notification);
    //    IJKMPMoviePlaybackStateStopped,        停止
    //    IJKMPMoviePlaybackStatePlaying,        正在播放
    //    IJKMPMoviePlaybackStatePaused,         暂停
    //    IJKMPMoviePlaybackStateInterrupted,    打断
    //    IJKMPMoviePlaybackStateSeekingForward, 快进
    //    IJKMPMoviePlaybackStateSeekingBackward 快退
    
    if (self.player.playbackState == IJKMPMoviePlaybackStatePlaying) {
        //视频开始播放的时候开启计时器
        [self createTimer];
    }
    
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"停止");
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            self.state = ABFPlayerStateStopped;
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"正在播放");
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            self.state = ABFPlayerStatePlaying;
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"暂停");
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            self.state = ABFPlayerStatePause;
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"打断");
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            self.state = ABFPlayerStatePause;
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"快进");
            NSLog(@"快退");
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            self.state = ABFPlayerStateBuffering;
            break;
        }
            
        default: {
            NSLog(@"不知道类型");
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            self.state = ABFPlayerStateFailed;
            break;
        }
    }
}

#pragma Install Notifiacation

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
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
