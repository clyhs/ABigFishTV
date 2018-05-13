//
//  ABFPlayerViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/2.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFPlayerViewController.h"
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
#import "MBProgressHUD.h"
#import "ABFTelevisionInfo.h"
#import "ABFPlayerView.h"
#import "ABFPlayerModel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "BRPlaceholderTextView.h"

@interface ABFPlayerViewController ()<UIScrollViewDelegate,ABFCommentDelegate,ABFCommentTFDelegate,ABFPListViewDelegate,ABFPlayerDelegate,UITextViewDelegate>

/** 状态栏的背景 */
@property (nonatomic, strong)   UIView         *topView;
@property (nonatomic, strong)   UIView         *botView;

@property(weak,nonatomic)       UIView         *titleView;
@property(weak,nonatomic)       UIScrollView   *titleTabScrollView;
@property(weak,nonatomic)       UIScrollView   *detailScrollView;
@property(weak,nonatomic)       ABFPListViewController *plistViewController;
@property(nonatomic,strong)     NSArray        *titleArrays;

@property(nonatomic,assign)     NSInteger      commentType;
@property(nonatomic,strong)     ABFCommentInfo *currentModel;
@property(nonatomic,assign)     NSInteger      replyIndex;
@property(nonatomic,weak)       UIView         *commentToolView;
@property(nonatomic,weak)       UIView         *commentTFView;
@property(nonatomic,strong)     UIView         *bgView;
@property(nonatomic,strong)    BRPlaceholderTextView *inputTextField;
@property (nonatomic,strong)    UILabel        *textNumberLabel;

@property (nonatomic, strong)   UIView         *playerFatherView;
@property (nonatomic,strong)  ABFPlayerView    *player;
@property (nonatomic,strong)  ABFPlayerModel   *playerModel;

@property (nonatomic, assign) BOOL             isGood;
@property (nonatomic,strong ) UIButton         *goodBtn;


@end

@implementation ABFPlayerViewController

- (NSArray *)titleArrays{
    if (_titleArrays == nil) {
        _titleArrays = @[@{@"title":@"评论",@"typeId":@"11",@"imageName":@"icon_tvcomment"},
                         @{@"title":@"节目",@"typeId":@"12",@"imageName":@"icon_tvprogram"}];
    }
    return _titleArrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.isGood = false;
    self.goodBtn.selected = NO;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.playerFatherView];
    [self setBotViewUI];
    [self makePlayViewConstraints];
    
    [self updatehit];
    [self historyAdd];
    [self getGoodLog];
    [self addChildViewController];
    self.plistViewController = self.childViewControllers[0];
    [self initTitleTabScrollView];
    [self setFirstTitleTab];
    [self initDetailScrollView];
    [self addCommentView];
    
    [self.player autoPlayTheVideo];
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackAction)];
    [self.view addGestureRecognizer:tapgest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:COMMON_COLOR];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [AppDelegate APP].allowRotation = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



#pragma mark - 添加子控件的约束
- (void)makePlayViewConstraints {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if (IS_IPHONE_4) {
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(statusBar.frame.size.height);
            make.leading.trailing.mas_equalTo(0);
            // 这里宽高比16：9,可自定义宽高比
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(2.0f/3.0f);
        }];
    } else {
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(statusBar.frame.size.height);
            make.leading.trailing.mas_equalTo(0);
            // 这里宽高比16：9,可自定义宽高比
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
        }];
    }
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(statusBar.frame.size.height);
    }];
    
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kScreenWidth*9/16+statusBar.frame.size.height);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        
    }];
    
    
}

#pragma mark - getter
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

- (void)getGoodLog{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:UserGetGoodUrl];
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",self.uid]];
    if([AppDelegate APP].user){
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",[AppDelegate APP].user.id]];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%d",11]];
        [PPNetworkHelper GET:fullUrl parameters:nil success:^(id responseObject) {
            NSLog(@"success");
            
            ABFResultInfo *info = [ABFResultInfo mj_objectWithKeyValues:responseObject];
            NSLog(@"desc=%@",info.desc);
            if([info.desc isEqualToString:@"1"]){
                self.isGood = YES;
                self.goodBtn.selected = self.isGood;
            }
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
        }];
    }
}


- (void)updatehit{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVUpdatehitUrl];
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",self.uid]];
    [PPNetworkHelper GET:fullUrl parameters:nil success:^(id responseObject) {
        NSLog(@"success");
    } failure:^( NSError *error) {
        NSLog(@"error%@",error);
    }];
    
}

-(void)historyAdd{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCollectUrl];
    if([AppDelegate APP].user){
        
        fullUrl = [fullUrl stringByAppendingString:@"15"];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",[AppDelegate APP].user.id]];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",self.uid]];
        NSLog(@"history url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:nil success:^(id responseObject) {
            NSLog(@"success");
            ABFResultInfo *result = [ABFResultInfo mj_objectWithKeyValues:responseObject];
            if(result.code == 10000){
                [AppDelegate APP].user.history = [AppDelegate APP].user.history+1;
            }
            
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
        }];
    }
}

-(void)abf_playerCutImage{
    [self playerCutButtonClick];
}

- (void)playerCutButtonClick{
    /*
    NSString *fullUrl = [BaseUrl stringByAppendingString:@"/api/tv/uploadbg"];
    
    NSNumber *uid = [NSNumber numberWithInteger:_uid];
    NSDictionary *params = @{@"id":uid};
    //NSURL *url = [NSURL URLWithString:_playUrl];
    UIImage *image = self.playerView.image;
    [[ABFHttpManager manager]POST:fullUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //NSURL *url = [NSURL URLWithString:_playUrl];
        NSData *imageData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imageData name:@"bg" fileName:@"headIcon.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];*/
}



-(void)playerCollectButtonClick{
    NSLog(@"collect");
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCollectUrl];
    if([AppDelegate APP].user){
        [AppDelegate APP].user.likenum = [AppDelegate APP].user.likenum+1;
        fullUrl = [fullUrl stringByAppendingString:@"14"];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",[AppDelegate APP].user.id]];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",self.uid]];
        NSLog(@"collect url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:nil responseCache:^(id responseCache) {
            //加载缓存数据
        } success:^(id responseObject) {
            NSLog(@"success");
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
        }];
    }
}

-(void)setBotViewUI{
    UIView *botView = [[UIView alloc] init];
    botView.backgroundColor = LINE_BG;
    [self.view addSubview:botView];
    _botView = botView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//添加子控制器
- (void)addChildViewController{
    //懒加载时，不能用_titleArray.count
    for (int i=0 ; i<self.titleArrays.count ;i++){
        ABFPListViewController *vc = [[ABFPListViewController alloc] init];
        vc.delegate = self;
        vc.title = self.titleArrays[i][@"title"];
        NSNumber *typeId =self.titleArrays[i][@"typeId"] ;
        vc.typeId = [NSString stringWithFormat:@"%@",typeId];
        NSLog(@"typeId=%@",typeId);
        vc.uid = self.uid;
        //vc.height = self.botView.frame.size.height;
        [self addChildViewController:vc];
    }
    
}



- (void)initTitleTabScrollView{
    
    UIScrollView *titleTabScrollView = [[UIScrollView alloc] init];
    titleTabScrollView.backgroundColor =RGB_255(250, 250, 250);
    CGFloat width = SCREEN_WIDTH;
    titleTabScrollView.contentSize = CGSizeMake(width, 0);
    titleTabScrollView.frame = CGRectMake(0, 0, width,45);
    _titleTabScrollView = titleTabScrollView;
    //不显示垂直滚动条
    _titleTabScrollView.showsHorizontalScrollIndicator = NO;
    //不显示水平滚动条
    _titleTabScrollView.showsVerticalScrollIndicator = NO;
    //关闭点击导航栏滚到顶部
    _titleTabScrollView.scrollsToTop = NO;
    
    for (int i = 0; i < self.titleArrays.count; i++) {
        CGFloat lblW = SCREEN_WIDTH / 5;
        CGFloat lblH = 45;
        CGFloat lblY = 0;
        CGFloat lblX = (i * lblW)*2 + SCREEN_WIDTH/5;
        TitleLineLabel *tll = [[TitleLineLabel alloc] init];
        UIViewController *vc = self.childViewControllers[i];
        //tll.text =_titleArrays[i][@"name"];
        tll.text = vc.title;
        tll.textColor = COMMON_COLOR;
        tll.textAlignment = NSTextAlignmentRight;
        
        [tll setInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [tll setIconViewImage:_titleArrays[i][@"imageName"]];
        
        //tll.bottomLine.hidden = NO;
        tll.frame = CGRectMake(lblX, lblY, lblW, lblH);
        [self.titleTabScrollView addSubview:tll];
        tll.tag = i;
        //设置视图是否可以接收到用户的事件和消息
        tll.userInteractionEnabled = YES;
    }
    [self.botView addSubview:_titleTabScrollView];
}

- (void)setFirstTitleTab{
    TitleLineLabel *tll = [self.titleTabScrollView.subviews firstObject];
    tll.bottomLine.hidden = NO;
    tll.scale = 1.0;
}

- (void)initDetailScrollView{
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    UIScrollView *detailScrollView = [[UIScrollView alloc] init];
    detailScrollView.frame = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT-45 - kScreenWidth * 9/16 -45 );
    detailScrollView.backgroundColor =[UIColor whiteColor];
    detailScrollView.contentSize = CGSizeMake(contentX, 0);
    detailScrollView.pagingEnabled = YES;
    detailScrollView.showsHorizontalScrollIndicator = NO;
    //detailScrollView.scrollenabled = YES;
    self.detailScrollView = detailScrollView;
    self.detailScrollView.delegate = self;
    [self.botView addSubview:detailScrollView];
    // 添加默认控制器
    ABFPListViewController *vc = [self.childViewControllers firstObject];
    //vc.view.frame = self.detailScrollView.bounds;
    vc.view.frame = CGRectMake(self.detailScrollView.contentOffset.x, 0, kScreenWidth, self.detailScrollView.frame.size.height-20);
    [self.detailScrollView addSubview:vc.view];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    //TitleLineLabel *labelLeft = self.titleTabScrollView.subviews[leftIndex];
    //labelLeft.backgroundColor = [UIColor yellowColor];
    //labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    //if (rightIndex < self.titleTabScrollView.subviews.count) {
        //TitleLineLabel *labelRight = self.titleTabScrollView.subviews[rightIndex];
        //labelRight.scale = scaleRight;
    //}
}

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.titleTabScrollView.frame.size.width;
    TitleLineLabel *titleLabel = (TitleLineLabel *)self.titleTabScrollView.subviews[index];
    CGFloat offsetx = titleLabel.center.x - self.titleTabScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.titleTabScrollView.contentSize.width - self.titleTabScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetx, self.titleTabScrollView.contentOffset.y);
    [self.titleTabScrollView setContentOffset:offset animated:YES];
    
    ABFPListViewController *vc = self.childViewControllers[index];
    vc.index = index;
    [self.titleTabScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            TitleLineLabel *temlabel = self.titleTabScrollView.subviews[idx];
            //temlabel.scale = 0.0;
            temlabel.bottomLine.hidden = YES;
        }else{
            TitleLineLabel *temlabel = self.titleTabScrollView.subviews[idx];
            temlabel.bottomLine.hidden = NO;
        }
    }];
    [self setScrollToTopWithTableViewIndex:index];
    
    if (vc.view.superview) return;
    vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, kScreenWidth, scrollView.height-20);
    [self.detailScrollView addSubview:vc.view];
}

#pragma mark - ScrollToTop

- (void)setScrollToTopWithTableViewIndex:(NSInteger)index
{
    //self.newsViewController.tableView.scrollsToTop = NO;
    self.plistViewController = self.childViewControllers[index];
    //self.newsViewController.tableView.scrollsToTop = YES;
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


-(void)addCommentView{
    
    ABFCommentView *commentToolView = [[ABFCommentView alloc] initWithFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 45)];
    commentToolView.delegate = self;
    _commentToolView = commentToolView;
    commentToolView.commentNumLab.text =[NSString stringWithFormat:@"%ld",self.model.commentNum] ;
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

-(void)commentClick:(id)sender{
    if([AppDelegate APP].user){
        self.commentType = 1;
        _bgView.hidden = NO;
        [_inputTextField becomeFirstResponder];
    }
}


-(void)pushlistForButton:(ABFCommentInfo *)model index:(NSInteger)tag{
    NSLog(@"tag=%ld",tag);
    if(tag == 101){
        NSLog(@"comment reply");
        if([AppDelegate APP].user){
            self.commentType = 2;
            self.currentModel = model;
            _bgView.hidden = NO;
            [_inputTextField becomeFirstResponder];;
            _inputTextField.placeholder = model.username;
        }
    }else if(tag == 102){
        NSLog(@"ding reply");
    }
}

-(void)pushlistForReplyButton:(ABFCommentInfo *)model index:(NSInteger)tag{
    NSLog(@"tag=%ld",tag);
    NSArray *replys = [ABFCommentInfo mj_objectArrayWithKeyValuesArray:model.childs];
    ABFCommentInfo *reply = replys[tag];
    if([AppDelegate APP].user){
        if([AppDelegate APP].user.id == reply.reply_id){
            
        }else{
            self.commentType = 3;
            self.currentModel = model;
            _bgView.hidden = NO;
            [_inputTextField becomeFirstResponder];;
            _inputTextField.placeholder = reply.replayname;
            self.replyIndex = tag;
        }
    }
}


- (void)tapBackAction {
    _bgView.hidden = YES;
    [self.view endEditing:YES];
    
}

-(void)submitClick:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(self.commentType == 1){
        [self submitAction];
    }else if(self.commentType == 2){
        [self submitReplyAction:self.currentModel];
    }else if(self.commentType == 3){
        [self submitReplyForUserAction:self.currentModel];
    }
    
}
-(void)submitAction{
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentAddUrl];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([AppDelegate APP].user){
        [params setObject:[NSString stringWithFormat:@"%ld",self.uid] forKey:@"uid"];
        //[params setValue:ids forKey:@"ids"];
        [params setObject:[NSString stringWithFormat:@"11"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"user_id"];
        NSString *context = [self.inputTextField.text stringByReplacingEmojiUnicodeWithCheatCodes];
        [params setObject:context forKey:@"context"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            
            ABFPListViewController *vc = self.plistViewController;
            [vc loadDataFirst];
            
            _bgView.hidden = YES;
            [self.view endEditing:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"success");
        } failure:^(NSError *error) {
            NSLog(@"error%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
}

-(void)submitReplyAction:(ABFCommentInfo *) replyInfo{
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentAddUrl];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([AppDelegate APP].user){
        [params setObject:[NSString stringWithFormat:@"%ld",self.uid] forKey:@"uid"];
        [params setObject:[NSString stringWithFormat:@"%ld",replyInfo.id] forKey:@"pid"];
        //[params setValue:ids forKey:@"ids"];
        [params setObject:[NSString stringWithFormat:@"11"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"reply_id"];
        NSString *context = [self.inputTextField.text stringByReplacingEmojiUnicodeWithCheatCodes];
        [params setObject:context forKey:@"context"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            
            //NSObject *obj = [responseObject objectForKey:@"data"];
            //[self loaddata];
            ABFPListViewController *vc = self.plistViewController;
            [vc loadDataFirst];
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

-(void)submitReplyForUserAction:(ABFCommentInfo *) replyInfo{
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentAddUrl];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([AppDelegate APP].user){
        [params setObject:[NSString stringWithFormat:@"%ld",self.uid] forKey:@"uid"];
        [params setObject:[NSString stringWithFormat:@"%ld",replyInfo.id] forKey:@"pid"];
        //[params setValue:ids forKey:@"ids"];
        [params setObject:[NSString stringWithFormat:@"11"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"reply_id"];
        
        NSArray *replys = [ABFCommentInfo mj_objectArrayWithKeyValuesArray:replyInfo.childs];
        ABFCommentInfo *reply = replys[self.replyIndex];
        
        [params setObject:[NSString stringWithFormat:@"%ld",reply.reply_id] forKey:@"user_id"];
        NSString *context = [self.inputTextField.text stringByReplacingEmojiUnicodeWithCheatCodes];
        [params setObject:context forKey:@"context"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            ABFPListViewController *vc = self.plistViewController;
            [vc loadDataFirst];
            _bgView.hidden = YES;
            [self.view endEditing:YES];
            self.currentModel = nil;
            NSLog(@"success");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        [params setObject:[NSString stringWithFormat:@"%ld",self.uid] forKey:@"uid"];
        [params setObject:[NSString stringWithFormat:@"11"] forKey:@"type_id"];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"userId"];
        NSLog(@"url=%@",fullUrl);
        [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            NSLog(@"success");
        } failure:^( NSError *error) {
            NSLog(@"error%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

-(void)jibaoClick:(id)sender{
    NSLog(@"jibao");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (void)abf_playerBackAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
        if(![self.model.url_1 isEqualToString:@"#"]){
            [urlArrays addObject:self.model.url_1];
        }
        if(![self.model.url_2 isEqualToString:@"#"]){
            [urlArrays addObject:self.model.url_2];
        }
        if(![self.model.url_3 isEqualToString:@"#"]){
            [urlArrays addObject:self.model.url_3];
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



@end
