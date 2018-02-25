//
//  ABFNoticeController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/20.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFNoticeController.h"
#import "ABFNavigationBarView.h"
#import "ABFNoticeInfo.h"
#import "ABFUserInfo.h"
#import "JHUD.h"
#import "ABFHttpManager.h"
#import "ABFMJRefreshGifHeader.h"
#import "AppDelegate.h"
#import "ABFPlayerViewController.h"
#import "ABFNoticeCell.h"

@interface ABFNoticeController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *dataArrays;

@property (nonatomic) JHUD *hudView;

@property(nonatomic,assign) NSInteger curIndexPage;

@property(nonatomic,strong) ABFNavigationBarView *naviView;

@end

@implementation ABFNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    _curIndexPage = 1;
    [self addTableView];
    [self loadData];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight -64);
    
}


- (void)addNavigationBarView{
    
    self.title = @"消息";
    /*
    ABFNavigationBarView *naviView = [[ABFNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    naviView.title = self.title;
    naviView.backgroundColor = COMMON_COLOR;
    [naviView setLeftBtnImageName:@"icon_lightback"];
    [self.view addSubview:naviView];
    _naviView = naviView;*/
    self.navigationController.navigationBar.barTintColor = COMMON_COLOR;
    //self.navigationController.navigationBar.alpha = 0.8;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(backClick:)
      forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0,60,20);
    [leftBtn setImage:[UIImage imageNamed:@"btn_nback"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
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
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    
}

- (void) loadData{
    //NSInteger curIndexPage = _curIndexPage;
    
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:NoticeListUrl];
    
    if([AppDelegate APP].user){
        NSLog(@"url=%@",fullUrl);
        self.hudView.messageLabel.text = @"数据加载中...";
        [self.hudView showAtView:self.tableView hudType:JHUDLoadingTypeCircle];
        [[ABFHttpManager manager]GET:fullUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *temArray=[responseObject objectForKey:@"data"];
            if(temArray.count>0){
                _curIndexPage++;
            }
            NSLog(@"success%ld",[temArray count]);
            NSArray *arrayM = [ABFNoticeInfo mj_objectArrayWithKeyValuesArray:temArray];
            
            if(self.dataArrays.count == 0){
                self.dataArrays = [arrayM mutableCopy];
            }else{
                //self.dataArrays = [arrayM arrayByAddingObjectsFromArray:self.dataArrays];
                //self.dataArrays = [[arrayM arrayByAddingObjectsFromArray:self.dataArrays] mutableCopy];
                self.dataArrays = [[self.dataArrays arrayByAddingObjectsFromArray:arrayM] mutableCopy];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.hudView hide];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error%@",error);
            [self.tableView.mj_header endRefreshing];
            self.hudView.indicatorViewSize = CGSizeMake(100, 100);
            self.hudView.messageLabel.text = @"连接网络失败，请重新连接";
            [self.hudView.refreshButton setTitle:@"重新连接" forState:UIControlStateNormal];
            [self.hudView.refreshButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
            self.hudView.customImage = [UIImage imageNamed:@"bg_null"];
            [self.hudView showAtView:self.tableView hudType:JHUDLoadingTypeFailure];
        }];
    }
    
}

-(void)refresh:(id)sender{
    [self loadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArrays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ABFNoticeInfo *model = self.dataArrays[indexPath.row];
    ABFNoticeCell *cell = [[ABFNoticeCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
                           
    cell.model = model;
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
