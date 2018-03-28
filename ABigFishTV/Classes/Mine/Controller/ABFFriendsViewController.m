//
//  ABFFriendsViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/6.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFFriendsViewController.h"
#import "ABFNavigationBarView.h"
#import "AppDelegate.h"
#import "ABFUserInfo.h"
#import "JHUD.h"
#import "ABFFriendTableCell.h"
#import "ABFHttpManager.h"
#import "ABFMJRefreshGifHeader.h"
#import "ABFMJRefreshGifFooter.h"

@interface ABFFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) ABFNavigationBarView *naviView;

@property(nonatomic,strong) NSMutableArray *dataArrays;

@property (nonatomic) JHUD *hudView;

@property(nonatomic,assign) NSInteger curIndexPage;

@property(nonatomic,strong) UIView *mainView;
@end

@implementation ABFFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableView];
    [self setuiMainView];
    self.hudView = [[JHUD alloc]initWithFrame:self.mainView.bounds];
    [self addRefreshHeader];
    [self addRefreshFooter];
    [self loadDataFirst];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏
    [AppDelegate APP].allowRotation = false;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self addNavigationBarView];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
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
    
    //self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -64);
    
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
    
    self.title = @"粉丝";
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
    //tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight -64);
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.editing = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.mainView addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    [tableView registerClass:[ABFFriendTableCell class] forCellReuseIdentifier:@"mycell"];
    
}

- (void) loadRefresh{
    _curIndexPage = 1;
    NSString *fullUrl = [BaseUrl stringByAppendingString:UserFriendsUrl];
    if([AppDelegate APP].user){
        NSString *userId = [NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id];
        fullUrl = [fullUrl stringByAppendingString:userId];

        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
        NSLog(@"url=%@",fullUrl);
        [self loadData:fullUrl type:1];
    }
    
    //
}

- (void) loadDataMore{
    _curIndexPage++;
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVRecordUrl];
    if([AppDelegate APP].user){
        NSString *userId = [NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id];
        fullUrl = [fullUrl stringByAppendingString:userId];
        
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
        NSLog(@"url=%@",fullUrl);
        [self loadData:fullUrl type:2];
    }
    
    
}

-(void) loadDataFirst{
    self.hudView.messageLabel.text = @"数据加载中...";
    [self.hudView showAtView:self.tableView hudType:JHUDLoadingTypeCircle];
    [self loadRefresh];
}

- (void) loadData:(NSString *)url type:(NSInteger)type{
    
    NSLog(@"url=%@",url);
    
    [[ABFHttpManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *temArray=[responseObject objectForKey:@"data"];
        NSLog(@"success%ld",[temArray count]);
        NSArray *arrayM = [ABFUserInfo mj_objectArrayWithKeyValuesArray:temArray];
        
        if(type == 1){
            
            if(self.dataArrays > 0){
                
            }else{
                self.dataArrays = [arrayM mutableCopy];
                
            }
            [self.tableView reloadData];
            [self.hudView hide];
            [self.tableView.mj_header endRefreshing];
        }
        if(type == 2){
            if(arrayM.count > 0){
                //self.dataArrays = [self.dataArrays arrayByAddingObjectsFromArray:arrayM];
                [self.dataArrays addObjectsFromArray:arrayM];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    ABFUserInfo *model = self.dataArrays[indexPath.row];
    ABFFriendTableCell *cell = (ABFFriendTableCell *)[tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
