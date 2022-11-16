//
//  ABFVideoPlayerViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/10.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFVideoPlayerViewController.h"
#import <PPNetworkHelper.h>
#import <AVFoundation/AVFoundation.h>
#import "TitleLineLabel.h"
#import "ABFPListViewController.h"
#import "AppDelegate.h"
#import "ABFCommentView.h"
#import "ABFCommentTFView.h"
#import "ABFCommentInfo.h"
#import "ABFCommentViewCell.h"
#import "ABFResultInfo.h"
#import "ABFChatHeaderSectionView.h"
#import "MBProgressHUD.h"
#import "BRPlaceholderTextView.h"
#import "ABFResultInfo.h"
#import "ABFPlayerView.h"
#import "ABFPlayerModel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ABFVideoPlayerViewController ()<ABFCommentDelegate,ABFCommentTFDelegate,ABFCommentViewCellDelegate,UITableViewDelegate,UITableViewDataSource,ABFPlayerDelegate,UITextViewDelegate>

/** 状态栏的背景 */
@property (nonatomic, strong) UIView *topView;
//@property (nonatomic, strong) LMVideoPlayer *player;
@property (nonatomic, strong) UIView *playerFatherView;
//@property (nonatomic, strong) LMPlayerModel *playerModel;

@property(nonatomic,strong) NSMutableArray *dataArrays;
@property(nonatomic,assign) NSInteger      commentType;
@property(nonatomic,strong) ABFCommentInfo *currentModel;
@property(nonatomic,assign) NSInteger      replyIndex;

@property(nonatomic,weak)   ABFCommentView *commentToolView;
@property(nonatomic,weak)   UIView *commentTFView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) BRPlaceholderTextView *inputTextField;
@property (nonatomic, strong) UILabel *textNumberLabel;

/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 离开页面时候是否开始过播放 */
@property (nonatomic, assign) BOOL isStartPlay;

@property (nonatomic, strong) UIView   *botView;

@property (nonatomic,strong)  ABFPlayerView    *player;
@property (nonatomic,strong)  ABFPlayerModel   *playerModel;

@property (nonatomic, assign) BOOL isGood;

@property (nonatomic,strong ) UIButton *goodBtn;
@property(nonatomic,strong) UIView *mainView;

@end

@implementation ABFVideoPlayerViewController

- (void)dealloc {
    NSLog(@"---------------dealloc------------------");
    //self.player destroyVideo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.isStartPlay = NO;
    self.goodBtn.selected = NO;
    [AppDelegate APP].allowRotation = true;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.playerFatherView];
    [self setBotViewUI];

    [self makePlayViewConstraints];
    [self addTableView];
    [self addCommentView];
    
    [self.player autoPlayTheVideo];
    /*
    LMPlayerModel *model = [[LMPlayerModel alloc] init];
    model.videoURL = [NSURL URLWithString:_playUrl];
    model.title = _tvTitle;
    
    LMVideoPlayer *player = [LMVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
    self.player = player;*/
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackAction)];
    [self.view addGestureRecognizer:tapgest];
    [self loaddata];
    [self getGoodLog];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    // pop回来时候是否自动播放
    /*
    if (self.player && self.isPlaying) {
        self.isPlaying = NO;
        [self.player playVideo];
    }*/
    //LMBrightnessViewShared.isStartPlay = self.isStartPlay;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = nil;
    if (@available(iOS 13.0, *)) {
        UIView *_localStatusBar = [[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager performSelector:@selector(createLocalStatusBar)];
        statusBar = [_localStatusBar performSelector:@selector(statusBar)];
    } else {
        // Fallback on earlier versions
        statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _tableView.frame =  self.botView.bounds;
}

- (void)setuiMainView{
    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor whiteColor];
    UIView *statusBar = nil;
    if (@available(iOS 13.0, *)) {
        UIView *_localStatusBar = [[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager performSelector:@selector(createLocalStatusBar)];
        statusBar = [_localStatusBar performSelector:@selector(statusBar)];
    } else {
        // Fallback on earlier versions
        statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    _mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height-statusBar.frame.size.height);
    [self.view addSubview:_mainView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    // push出下一级页面时候暂停
    /*
    if (self.player && !self.player.isPauseByUser) {
        self.isPlaying = YES;
        [self.player pauseVideo];
    }
    
    LMBrightnessViewShared.isStartPlay = NO;*/
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor blackColor];
    }
    return _topView;
}

- (UIView *)playerFatherView {
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc] init];
    }
    return _playerFatherView;
}

-(void)setBotViewUI{
    UIView *botView = [[UIView alloc] init];
    botView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:botView];
    _botView = botView;
}



-(void)addCommentView{
    
    
    ABFCommentView *commentToolView = [[ABFCommentView alloc] initWithFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
    commentToolView.delegate = self;
    _commentToolView = commentToolView;
    //commentToolView.commentNumLab.text =[NSString stringWithFormat:@"%ld",self.model.commentNum] ;
    //_commentToolView.hidden = YES;
    self.goodBtn = commentToolView.dingBtn;
    [self.view addSubview:commentToolView];
    
    
    _bgView = [[UIView alloc] init];
    _bgView.frame = self.view.bounds;
    //3. 背景颜色可以用多种方法看需要咯
    _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.view addSubview:_bgView];
    _bgView.hidden = YES;
    
    ABFCommentTFView *commentView = [[ABFCommentTFView alloc] initWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth, 100)];
    commentView.delegate = self;
    _commentTFView = commentView;
    _inputTextField = commentView.inputTextField;
    _inputTextField.delegate = self;
    _textNumberLabel = commentView.textNumberLabel;
    [_bgView addSubview:commentView];
}

//#pragma mark - 添加子控件的约束
- (void)makePlayViewConstraints {
    UIView *statusBar = nil;
    if (@available(iOS 13.0, *)) {
        UIView *_localStatusBar = [[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager performSelector:@selector(createLocalStatusBar)];
        statusBar = [_localStatusBar performSelector:@selector(statusBar)];
    } else {
        // Fallback on earlier versions
        statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    if (IS_IPHONE_4) {
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(statusBar.frame.size.height);
            make.leading.trailing.mas_equalTo(0);
            // 这里宽高比16：9,可自定义宽高比
            make.height.mas_equalTo(self.view.mas_width).multipliedBy(2.0f/3.0f);
        }];
    } else {
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(statusBar.frame.size.height);
            make.leading.trailing.mas_equalTo(0);
            // 这里宽高比16：9,可自定义宽高比
            make.height.mas_equalTo(self.view.mas_width).multipliedBy(9.0f/16.0f);
        }];
    }
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(statusBar.frame.size.height);
    }];
    
    [self.botView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kScreenWidth*9/16+statusBar.frame.size.height);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
        
    }];
    
    
}


#pragma mark - getter


//- (LMPlayerModel *)playerModel {
//    if (!_playerModel) {
//        _playerModel = [[LMPlayerModel alloc] init];
//    }
//    return _playerModel;
//}

- (void)tapBackAction {
    _bgView.hidden = YES;
    [self.view endEditing:YES];
    
}

- (void) addTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = LINE_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    //tableView.bounces = NO;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.botView addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    
    [_tableView registerClass:[ABFCommentViewCell class] forCellReuseIdentifier:@"commentcell"];
    
}

-(void)loaddata{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentUrl];
    
    //if([self.typeId isEqualToString:@"11"]){
    
    fullUrl = [fullUrl stringByAppendingFormat:@"22/%ld",self.model.id];
    NSLog(@"url=%@",fullUrl);
    [PPNetworkHelper GET:fullUrl parameters:nil responseCache:^(id responseCache) {
        //加载缓存数据
    } success:^(id responseObject) {
        NSArray *temArray=[responseObject objectForKey:@"data"];
        NSLog(@"success%ld",[temArray count]);
        NSArray *arrayM = [ABFCommentInfo mj_objectArrayWithKeyValuesArray:temArray];
        //self.dataArrays = nil;
        self.dataArrays = [arrayM mutableCopy];
        for (ABFCommentInfo *info in arrayM) {
            NSLog(@"context=%@",info.context);
            //[self.dataArrays addObject:info];
        }
        ABFResultInfo *result = [ABFResultInfo mj_objectWithKeyValues:responseObject];
        self.commentToolView.commentNumLab.text = result.desc;
        
        
        [self.tableView reloadData];
        //[self.tableView beginUpdates];
        //[self.tableView endUpdates];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
    //[self.tableView reloadData];
    
    //}else{
    //NSLog(@"...");
    //}
    
    
}

- (void)getGoodLog{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:UserGetGoodUrl];
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",self.uid]];
    if([AppDelegate APP].user){
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",[AppDelegate APP].user.id]];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%d",22]];
        [PPNetworkHelper GET:fullUrl parameters:nil responseCache:^(id responseCache) {
            //加载缓存数据
        } success:^(id responseObject) {
            NSLog(@"success");
            
            ABFResultInfo *info = [ABFResultInfo mj_objectWithKeyValues:responseObject];
            NSLog(@"desc=%@",info.desc);
            if([info.desc isEqualToString:@"1"]){
                self.isGood = YES;
                self.goodBtn.selected = self.isGood;
            }
            
            
        } failure:^(NSError *error) {
            NSLog(@"error%@",error);
        }];
    }
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArrays count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ABFChatHeaderSectionView *view = [[ABFChatHeaderSectionView alloc] init];
    view.titleLab.text = @"评论";
    if(self.model.goodNum){
        view.goodLab.text = [NSString stringWithFormat:@"点赞 %@",self.model.goodNum] ;
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //ABFCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentcell"];
    
    ABFCommentInfo *model = self.dataArrays[indexPath.row];
    
    ABFCommentViewCell *cell = [[ABFCommentViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    //cell.model = self.data[indexPath.row];
    cell.delegate = self;
    [cell setModel:model];
    //NSLog(@"abfcommentinfo context=%@",model.context);
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABFCommentInfo *model = self.dataArrays[indexPath.row];
    return 50+model.contextHeight+model.replyHeight+25+30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}




- (void)keyBoardWillShow:(NSNotification *) note {
    NSLog(@"keyboard");
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    void (^animation)(void) = ^void(void) {
        //_bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.commentTFView.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
    };
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
}

- (void)keyBoardWillHide:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.commentTFView.transform = CGAffineTransformIdentity;
    };
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}


-(void)commentClick:(id)sender{
    if([AppDelegate APP].user){
        self.commentType = 1;
        _bgView.hidden = NO;
        [_inputTextField becomeFirstResponder]  ;
    }
}

-(void)goodClick:(id)sender{
    NSLog(@"good");
    self.isGood = !self.isGood;
    NSString *fullUrl = [BaseUrl stringByAppendingString:UserGoodUrl];
    NSMutableDictionary *params = [NSMutableDictionary new];
    if(self.isGood){
        [params setObject:[NSString stringWithFormat:@"%d",1] forKey:@"type"];
    }else{
        [params setObject:[NSString stringWithFormat:@"%d",0] forKey:@"type"];
    }
    if([AppDelegate APP].user){
        [params setObject:[NSString stringWithFormat:@"%ld",self.uid] forKey:@"uid"];
        [params setObject:[NSString stringWithFormat:@"22"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"userId"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            //请求成功
            //NSObject *obj = [responseObject objectForKey:@"data"];
            //[self loaddata];
            
            NSLog(@"success");
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

-(void)submitClick:(id)sender{
    NSLog(@"submit");
    NSLog(@"content=%@",self.inputTextField.text);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(self.commentType == 1){
        [self submitAction];
    }else if(self.commentType == 2){
        [self submitReplyAction:self.currentModel];
    }else if(self.commentType == 3){
        [self submitReplyForUserAction:self.currentModel];
    }
    
}

-(void)pushForButton:(ABFCommentInfo *)model index:(NSInteger)tag{
    
    NSLog(@"tag=%ld",tag);
    if(tag == 101){
        NSLog(@"comment reply");
        if([AppDelegate APP].user){
            self.commentType = 2;
            self.currentModel = model;
            _bgView.hidden = NO;
            [_inputTextField becomeFirstResponder]  ;
            _inputTextField.placeholder = model.username;
        }
    }
}

-(void)pushForReplyButton:(ABFCommentInfo *)model index:(NSInteger)tag{
    NSLog(@"tag=%ld",tag);
    NSArray *replys = [ABFCommentInfo mj_objectArrayWithKeyValuesArray:model.childs];
    ABFCommentInfo *reply = replys[tag];
    if([AppDelegate APP].user){
        if([AppDelegate APP].user.id == reply.reply_id){
            
        }else{
            self.commentType = 3;
            self.currentModel = model;
            _bgView.hidden = NO;
            [_inputTextField becomeFirstResponder] ;
            _inputTextField.placeholder = reply.replayname;
            self.replyIndex = tag;
        }
    }
    
    
}

-(void)submitAction{
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentAddUrl];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([AppDelegate APP].user){
        [params setObject:[NSString stringWithFormat:@"%ld",self.model.id] forKey:@"uid"];
        //[params setValue:ids forKey:@"ids"];
        [params setObject:[NSString stringWithFormat:@"22"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"user_id"];
        
        NSString *context = [self.inputTextField.text stringByReplacingEmojiUnicodeWithCheatCodes];
        
        [params setObject:context forKey:@"context"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            
            //NSObject *obj = [responseObject objectForKey:@"data"];
            [self loaddata];
            
            _bgView.hidden = YES;
            [self.view endEditing:YES];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"success");
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
}

-(void)submitReplyAction:(ABFCommentInfo *) replyInfo{
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentAddUrl];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([AppDelegate APP].user){
        [params setObject:[NSString stringWithFormat:@"%ld",self.model.id] forKey:@"uid"];
        [params setObject:[NSString stringWithFormat:@"%ld",replyInfo.id] forKey:@"pid"];
        //[params setValue:ids forKey:@"ids"];
        [params setObject:[NSString stringWithFormat:@"22"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"reply_id"];
        
        NSString *context = [self.inputTextField.text stringByReplacingEmojiUnicodeWithCheatCodes];
        
        [params setObject:context forKey:@"context"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            
            //NSObject *obj = [responseObject objectForKey:@"data"];
            [self loaddata];
            
            _bgView.hidden = YES;
            [self.view endEditing:YES];
            self.currentModel = nil;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"success");
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
}

-(void)submitReplyForUserAction:(ABFCommentInfo *) replyInfo{
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentAddUrl];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([AppDelegate APP].user){
        [params setObject:[NSString stringWithFormat:@"%ld",self.model.id] forKey:@"uid"];
        [params setObject:[NSString stringWithFormat:@"%ld",replyInfo.id] forKey:@"pid"];
        //[params setValue:ids forKey:@"ids"];
        [params setObject:[NSString stringWithFormat:@"22"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"reply_id"];
        
        NSArray *replys = [ABFCommentInfo mj_objectArrayWithKeyValuesArray:replyInfo.childs];
        ABFCommentInfo *reply = replys[self.replyIndex];
        
        [params setObject:[NSString stringWithFormat:@"%ld",reply.reply_id] forKey:@"user_id"];
        NSString *context = [self.inputTextField.text stringByReplacingEmojiUnicodeWithCheatCodes];
        
        [params setObject:context forKey:@"context"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            
            //NSObject *obj = [responseObject objectForKey:@"data"];
            [self loaddata];
            
            _bgView.hidden = YES;
            [self.view endEditing:YES];
            self.currentModel = nil;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"success");
        } failure:^(NSError *error) {
            NSLog(@"error%@",error);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
    }
    
}


#pragma mark - ZFPlayerDelegate

- (void)abf_playerBackAction {
    //[self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//


#pragma mark - Getter



-(ABFPlayerView *)player{
    if(!_player){
        _player = [[ABFPlayerView alloc] init];
        _player.delegate = self;
        [_player playControlView:nil playerModel:self.playerModel];
    }
    return _player;
}

-(ABFPlayerModel *)playerModel{
    if(!_playerModel){
        _playerModel = [[ABFPlayerModel alloc] init];
        _playerModel.fatherView = self.playerFatherView;
        _playerModel.title = self.tvTitle;
        NSMutableArray *urlArrays = [NSMutableArray new];
        if(![self.playUrl isEqualToString:@"#"]){
            [urlArrays addObject:self.playUrl];
        }
        
        _playerModel.urlArrays = [urlArrays mutableCopy];
    }
    return _playerModel;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //当前输入字数
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_inputTextField.text.length,90];
    if (_inputTextField.text.length > 90) {
        _textNumberLabel.textColor = [UIColor redColor];
    }else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    //[self textChanged];
    return YES;
}

//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{
    //
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_inputTextField.text.length,90];
    if (_inputTextField.text.length > 90) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    //[self textChanged];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
