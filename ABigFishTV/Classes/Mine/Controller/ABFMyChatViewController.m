//
//  ABFMyChatViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/17.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFMyChatViewController.h"
#import "AppDelegate.h"
#import "ABFNavigationBarView.h"
#import "ABFChatInfo.h"
#import <PPNetworkHelper.h>
#import "ABFChatViewCell.h"
#import "JHUD.h"
#import "MBProgressHUD.h"
#import "ABFInfo.h"
#import "ABFMJRefreshGifHeader.h"
#import "ABFMJRefreshGifFooter.h"

@interface ABFMyChatViewController ()<UITableViewDelegate,UITableViewDataSource,ABFChatImageDelegate>

@property (nonatomic)       JHUD           *hudView;
@property(nonatomic,strong) NSMutableArray *dataArrays;
@property(nonatomic,assign) NSInteger      curIndexPage;

@property(nonatomic,strong) ABFNavigationBarView *naviView;

@property(nonatomic,strong) UIView         *mainView;

@end

@implementation ABFMyChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
   // self.edgesForExtendedLayout = UIRectEdgeBottom;//不用这个，不然会有导航栏向上缩
    _curIndexPage = 1;
    [self setuiMainView];
    [self addTableView];
    
    self.hudView = [[JHUD alloc]initWithFrame:self.mainView.bounds];
    [self addRefreshHeader];
    [self addRefreshFooter];
    
    [self loadDataFirst];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏
    [AppDelegate APP].allowRotation = false;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self addNavigationBarView];
   
    
}

- (void)setuiMainView{
    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:_mainView];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    //self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _tableView.frame =  CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
}

- (void)addRefreshHeader
{
    ABFMJRefreshGifHeader *header = [ABFMJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefresh)];
    self.tableView.mj_header = header;
    
}

- (void)addRefreshFooter{
    ABFMJRefreshGifFooter *footer = [ABFMJRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataMore)];
    
    self.tableView.mj_footer = footer;
}

- (void)addNavigationBarView{
    
    self.title = @"微话题";
    self.navigationController.navigationBar.barTintColor = COMMON_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    //self.navigationController.navigationBar.alpha = 0.8;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(backClick:)
      forControlEvents:UIControlEventTouchUpInside];
    //leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0,20,20);
    [leftBtn setImage:[UIImage imageNamed:@"btn_nback"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    /*
    ABFNavigationBarView *naviView = [[ABFNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    naviView.title = self.title;
    naviView.backgroundColor = COMMON_COLOR;
    [naviView setLeftBtnImageName:@"icon_lightback"];
    [self.view addSubview:naviView];
    _naviView = naviView;*/
    
    
}

- (void)addTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.backgroundColor = LINE_BG;
    tableView.editing = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.mainView addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    [_tableView registerClass:[ABFChatViewCell class] forCellReuseIdentifier:@"mycell"];
}

- (void) loadRefresh{
    _curIndexPage = 1;
    NSString *fullUrl = BaseUrl;
    fullUrl = [fullUrl stringByAppendingString:ChatUrl];
    
    
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%d",1]];
    if([AppDelegate APP].user){
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",[AppDelegate APP].user.id]];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
        NSLog(@"url=%@",fullUrl);
        //[self.tableView.mj_header beginRefreshing];
        [self loadData:fullUrl type:1];
    }
    
}

- (void) loadDataMore{
    _curIndexPage++;
    NSString *fullUrl = BaseUrl;
    fullUrl = [fullUrl stringByAppendingString:ChatUrl];
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%d",1]];
    if([AppDelegate APP].user){
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",[AppDelegate APP].user.id]];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
        NSLog(@"url=%@",fullUrl);
        //[self.tableView.mj_header beginRefreshing];
        [self loadData:fullUrl type:2];
    }
    //[self.tableView.mj_footer beginRefreshing];
}

-(void) loadDataFirst{
    if([AppDelegate APP].user){
        self.hudView.messageLabel.text = @"数据加载中...";
        [self.hudView showAtView:self.tableView hudType:JHUDLoadingTypeCircle];
        [self loadRefresh];
    }
    
}

- (void) loadData:(NSString *)url type:(NSInteger)type{
    
    NSLog(@"url=%@",url);
    [PPNetworkHelper GET:url parameters:nil responseCache:^(id responseCache) {
        //加载缓存数据
    } success:^(id responseObject) {
        
        NSArray *temArray=[responseObject objectForKey:@"data"];
        if(temArray.count>0){
            //_curIndexPage++;
        }
        //NSLog(@"success%ld",[temArray count]);
        NSArray *arrayM = nil;
        arrayM = [ABFChatInfo mj_objectArrayWithKeyValuesArray:temArray];
        if(type == 1){
            self.dataArrays = [arrayM mutableCopy];
            [self.tableView reloadData];
            
            [self.hudView hide];
            [self.tableView.mj_header endRefreshing];
        }
        if(type == 2){
            if(arrayM.count > 0){
                self.dataArrays = [[self.dataArrays arrayByAddingObjectsFromArray:arrayM] mutableCopy];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failure:^( NSError *error) {
        NSLog(@"error%@",error);
        if(type == 1){
            [self.tableView.mj_header endRefreshing];
            self.hudView.indicatorViewSize = CGSizeMake(100, 100);
            self.hudView.messageLabel.text = @"连接网络失败，请重新连接";
            [self.hudView.refreshButton setTitle:@"重新连接" forState:UIControlStateNormal];
            [self.hudView.refreshButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
            self.hudView.customImage = [UIImage imageNamed:@"bg_null"];
            [self.hudView showAtView:self.tableView hudType:JHUDLoadingTypeFailure];
        }
        if(type == 2){
            [self.tableView.mj_footer endRefreshing];
        }
        
    }];
    
    
}

-(void)refresh:(id)sender{
    [self loadDataFirst];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArrays count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ABFChatViewCell *cell = [[ABFChatViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        //ABFChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    cell.delegate = self;
        //cell.frame = CGRectMake(0, 0, kScreenWidth, 90);
    ABFChatInfo *model = self.dataArrays[indexPath.row];
    [cell setModel:model];
        //NSLog(@"name........=%@",model.name);
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABFChatInfo *model = self.dataArrays[indexPath.row];
    //return 50+model.contextHeight+10 + model.infoHeight + 10;
    return 60+model.contextHeight+model.imagesHeight+40+10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = LINE_BG;
    return lineView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 如果点击的是右边的tableView，不做任何处理
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    if([self.typeId isEqualToString:@"1"]){
        ABFChatViewController *vc = [[ABFChatViewController alloc] init];
        vc.model = self.data[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }*/
    
}

-(void)pushForImage:(ABFChatInfo *)model imageIndex:(NSInteger)index{
    NSLog(@"title=%@",model.context);
    NSLog(@"index=%ld",index);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
