//
//  ABFChatViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/24.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFChatViewController.h"
#import "ABFChatHeaderView.h"
#import "AppDelegate.h"
#import "ABFChatInfo.h"
#import "ABFPhotoViewController.h"
#import "ABFChatHeaderSectionView.h"
#import "ABFCommentViewCell.h"
#import "ABFCommentInfo.h"
#import <PPNetworkHelper.h>
#import "ABFCommentView.h"
#import "ABFCommentTFView.h"
#import "MWPhotoBrowser.h"
#import "ABFInfo.h"
#import "MBProgressHUD.h"
#import "ABFResultInfo.h"
#import "BRPlaceholderTextView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@interface ABFChatViewController ()<UITableViewDelegate,UITableViewDataSource,ABFChatHeaderImageDelegate,ABFCommentDelegate,ABFCommentTFDelegate,ABFCommentViewCellDelegate,MWPhotoBrowserDelegate,UITextViewDelegate>

@property(nonatomic,strong) NSMutableArray *dataArrays;
@property(nonatomic,assign) NSInteger      commentType;
@property(nonatomic,strong) ABFCommentInfo *currentModel;
@property(nonatomic,assign) NSInteger      replyIndex;

@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,weak)   ABFCommentView *commentToolView;
@property(nonatomic,weak)   UIView *commentTFView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,weak)   BRPlaceholderTextView *inputTextField;
@property (nonatomic, strong) UILabel *textNumberLabel;
@property(nonatomic,strong) UIView *mainView;
    
@property (nonatomic,retain) NSMutableArray *photosArray;

@property (nonatomic, assign) BOOL isGood;

@property (nonatomic,strong ) UIButton *goodBtn;


@end

@implementation ABFChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _photosArray = [NSMutableArray new];
    // Do any additional setup after loading the view.
    NSArray *images = [ABFInfo mj_keyValuesArrayWithObjectArray:self.model.images];
    for(ABFInfo *m in images){
        [_photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:m.url]]];
    }
    self.goodBtn.selected = NO;
    [self setuiMainView];
    [self addTableView];
    [self addTableheaderView];
    [self addCommentView];
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackAction)];
    [self.mainView addGestureRecognizer:tapgest];
    
    [self loaddata];
    [self getGoodLog];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegate APP].allowRotation = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self addNavigationBarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //self.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height );
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    _tableView.frame =  CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height-self.commentToolView.frame.size.height-statusBar.frame.size.height);
}

- (void)setuiMainView{
    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor whiteColor];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    _mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height-statusBar.frame.size.height);
    [self.view addSubview:_mainView];
}

- (void)addNavigationBarView{
    self.title = @"微话题";
    self.navigationController.navigationBar.barTintColor = RGB_255(250, 250, 250);
    //self.navigationController.navigationBar.alpha = 0.8;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(backClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0,20,20);
    [leftBtn setImage:[UIImage imageNamed:@"icon_grayback"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"btn_lightshare"] forState:UIControlStateSelected];
    [shareBtn addTarget:self action:@selector(shareClick:)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
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
    [self.mainView addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    
    [_tableView registerClass:[ABFCommentViewCell class] forCellReuseIdentifier:@"commentcell"];
    
}

-(void) addTableheaderView{
    //_headerView = [[UIView alloc] init];
    ABFChatHeaderView *headerView = [[ABFChatHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0,kScreenWidth , 50+self.model.contextHeight+self.model.imagesHeight+20);
    headerView.delegate = self;
    [headerView setModel:self.model];
    _tableView.tableHeaderView = headerView;
    _headerView = headerView;
}

-(void)addCommentView{
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    ABFCommentView *commentToolView = [[ABFCommentView alloc] initWithFrame:CGRectMake(0, kScreenHeight-self.navigationController.navigationBar.frame.size.height-statusBar.frame.size.height-45, kScreenWidth, 45)];
    commentToolView.delegate = self;
    _commentToolView = commentToolView;
    //_commentToolView.hidden = YES;
    self.goodBtn = commentToolView.dingBtn;
    [self.mainView addSubview:commentToolView];
    
    
    _bgView = [[UIView alloc] init];
    _bgView.frame = self.mainView.bounds;
    //3. 背景颜色可以用多种方法看需要咯
    _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.mainView addSubview:_bgView];
    _bgView.hidden = YES;
    
    ABFCommentTFView *commentView = [[ABFCommentTFView alloc] initWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth, 100)];
    commentView.delegate = self;
    _commentTFView = commentView;
    _inputTextField = commentView.inputTextField;
    _inputTextField.delegate = self;
    _textNumberLabel = commentView.textNumberLabel;
    [_bgView addSubview:commentView];
}

-(void)loaddata{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentUrl];
    
    //if([self.typeId isEqualToString:@"11"]){
        
        fullUrl = [fullUrl stringByAppendingFormat:@"12/%ld",self.model.id];
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
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
        }];
        
        //[self.tableView reloadData];
        
    //}else{
        //NSLog(@"...");
    //}
    
    
}

- (void)getGoodLog{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:UserGetGoodUrl];
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",self.model.id]];
    if([AppDelegate APP].user){
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",[AppDelegate APP].user.id]];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%d",12]];
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
        [params setObject:[NSString stringWithFormat:@"%ld",self.model.id] forKey:@"uid"];
        [params setObject:[NSString stringWithFormat:@"12"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"userId"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            //NSObject *obj = [responseObject objectForKey:@"data"];
            //[self loaddata];
            
            NSLog(@"success");
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
            [MBProgressHUD hideHUDForView:self.mainView animated:YES];
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
    return 50+model.contextHeight+model.replyHeight+25;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}
/*
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if(velocity.y>0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            _commentToolView.alpha = 0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _commentToolView.alpha = 1;
        }];
    }
    
}*/



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareClick:(id)sender{
    NSLog(@"share");
    //1、创建分享参数
    //NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    if (true) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

-(void)pushForImage:(ABFChatInfo *)model imageIndex:(NSInteger)index{
    NSLog(@"title=%@",model.context);
    NSLog(@"index=%ld",index);
    /*
    ABFPhotoViewController *vc = [[ABFPhotoViewController alloc] init];
    vc.model = model;
    vc.index = index;
    [self.navigationController pushViewController:vc animated:YES];*/
    
    
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    //browser.customImageSelectedIconName = @"ImageSelected.png";
    //browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index];
    
    // Present
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:browser];
    navC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navC animated:YES completion:nil];
    
    

    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photosArray.count;
}
    
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photosArray.count) {
        return [self.photosArray objectAtIndex:index];
    }
    return nil;
}
    
-(void)commentClick:(id)sender{
    if([AppDelegate APP].user){
        self.commentType = 1;
        _bgView.hidden = NO;
        [_inputTextField becomeFirstResponder ];
    }
}



-(void)submitClick:(id)sender{
    NSLog(@"submit");
    NSLog(@"content=%@",self.inputTextField.text);
    [MBProgressHUD showHUDAddedTo:self.mainView animated:YES];
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
            [_inputTextField becomeFirstResponder ];
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
            [_inputTextField becomeFirstResponder ];
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
        [params setObject:[NSString stringWithFormat:@"12"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"user_id"];
        
        NSString *context = [self.inputTextField.text stringByReplacingEmojiUnicodeWithCheatCodes];
        
        [params setObject:context forKey:@"context"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            
            //NSObject *obj = [responseObject objectForKey:@"data"];
            [self loaddata];
            
            _bgView.hidden = YES;
            [self.mainView endEditing:YES];
            [MBProgressHUD hideHUDForView:self.mainView animated:YES];
            NSLog(@"success");
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
            [MBProgressHUD hideHUDForView:self.mainView animated:YES];
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
        [params setObject:[NSString stringWithFormat:@"12"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"reply_id"];
        
        NSString *context = [self.inputTextField.text stringByReplacingEmojiUnicodeWithCheatCodes];
        
        [params setObject:context forKey:@"context"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            
            //NSObject *obj = [responseObject objectForKey:@"data"];
            [self loaddata];
            
            _bgView.hidden = YES;
            [self.mainView endEditing:YES];
            self.currentModel = nil;
            [MBProgressHUD hideHUDForView:self.mainView animated:YES];
            NSLog(@"success");
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
            [MBProgressHUD hideHUDForView:self.mainView animated:YES];
            
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
        [params setObject:[NSString stringWithFormat:@"12"] forKey:@"type_id"];
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
            [self.mainView endEditing:YES];
            self.currentModel = nil;
            [MBProgressHUD hideHUDForView:self.mainView animated:YES];
            NSLog(@"success");
        } failure:^(NSError *error) {
            NSLog(@"error%@",error);
            [MBProgressHUD hideHUDForView:self.mainView animated:YES];
            
        }];
    }
    
}

- (void)tapBackAction {
    _bgView.hidden = YES;
    [self.mainView endEditing:YES];
    
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

- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
