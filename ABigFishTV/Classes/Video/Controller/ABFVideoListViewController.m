//
//  ABFVideoListViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFVideoListViewController.h"
#import <PPNetworkHelper.h>
#import "ABFChatViewCell.h"
#import "ABFVideoViewCell.h"
#import "JHUD.h"
#import "MBProgressHUD.h"
#import "ABFChatInfo.h"
#import "ABFInfo.h"
#import "ABFVideoInfo.h"
#import "AppDelegate.h"
#import "ABFPhotoViewController.h"
#import "ABFChatViewController.h"
#import "ABFMJRefreshGifHeader.h"
#import "ABFMJRefreshGifFooter.h"
#import "ABFVideoPlayerViewController.h"

@interface ABFVideoListViewController ()<UITableViewDelegate,UITableViewDataSource,ABFChatImageDelegate>

@property (nonatomic) JHUD *hudView;
@property(nonatomic,strong) NSMutableArray *data;
@property(nonatomic,assign) NSInteger curIndexPage;
@end

@implementation ABFVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"vc...%@",self.typeId);
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    _curIndexPage = 1;
    [self addTableView];
    [self addRefreshHeader];
    [self addRefreshFooter];
    
    [self loadDataFirst];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegate APP].allowRotation = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.tabBarController.tabBar.frame.size.height-24);
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

- (void)addTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = LINE_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    
    [_tableView registerClass:[ABFChatViewCell class] forCellReuseIdentifier:@"mycell"];
}

- (void) loadRefresh{
    _curIndexPage = 1;
    NSString *fullUrl = BaseUrl;
    if([self.typeId isEqualToString:@"1"]){
        fullUrl = [fullUrl stringByAppendingString:ChatUrl];
    }
    
    if([self.typeId isEqualToString:@"2"]){
        fullUrl = [fullUrl stringByAppendingString:VideoUrl];
    }
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
    NSLog(@"url=%@",fullUrl);
    //[self.tableView.mj_header beginRefreshing];
    [self loadData:fullUrl type:1];
}

- (void) loadDataMore{
    _curIndexPage++;
    NSString *fullUrl = BaseUrl;
    if([self.typeId isEqualToString:@"1"]){
        fullUrl = [fullUrl stringByAppendingString:ChatUrl];
    }
    
    if([self.typeId isEqualToString:@"2"]){
        fullUrl = [fullUrl stringByAppendingString:VideoUrl];
    }
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
    NSLog(@"url=%@",fullUrl);
    //[self.tableView.mj_footer beginRefreshing];
    [self loadData:fullUrl type:2];
}

-(void) loadDataFirst{
    self.hudView.messageLabel.text = @"数据加载中...";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    [self loadRefresh];
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
        if([self.typeId isEqualToString:@"1"]){
            arrayM = [ABFChatInfo mj_objectArrayWithKeyValuesArray:temArray];
        }
        
        if([self.typeId isEqualToString:@"2"]){
            arrayM = [ABFVideoInfo mj_objectArrayWithKeyValuesArray:temArray];
        }
        
        if(type == 1){
            
            
            self.data = [arrayM mutableCopy];
            [self.tableView reloadData];
            
            [self.hudView hide];
            [self.tableView.mj_header endRefreshing];
        }
        if(type == 2){
            if(arrayM.count > 0){
                //self.data = [self.data arrayByAddingObjectsFromArray:arrayM];
                //self.data = [[arrayM arrayByAddingObjectsFromArray:self.data] mutableCopy];
                self.data = [[self.data arrayByAddingObjectsFromArray:arrayM] mutableCopy];
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
            [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
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
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.typeId isEqualToString:@"1"]){
        
        ABFChatViewCell *cell = [[ABFChatViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        //ABFChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
        cell.delegate = self;
        //cell.frame = CGRectMake(0, 0, kScreenWidth, 90);
        ABFChatInfo *model = self.data[indexPath.row];
        [cell setModel:model];
        //NSLog(@"name........=%@",model.name);
        return cell;
    }
    if([self.typeId isEqualToString:@"2"]){
        ABFVideoViewCell *cell = [[ABFVideoViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        //cell.frame = CGRectMake(0, 0, kScreenWidth, 90);
        ABFVideoInfo *model = self.data[indexPath.row];
        [cell setModel:model];
        //NSLog(@"name........=%@",model.name)
        return cell;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.typeId isEqualToString:@"1"]){
        ABFChatInfo *model = self.data[indexPath.row];
        //return 50+model.contextHeight+10 + model.infoHeight + 10;
        return 50+model.contextHeight+model.imagesHeight+40+10;
    }
    
    if([self.typeId isEqualToString:@"2"]){
        ABFVideoInfo *model = self.data[indexPath.row];
        return model.titleHeight+kScreenWidth * 9/16+50+15+5;
    }
    
    return 0;
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
    
    if([self.typeId isEqualToString:@"1"]){
        ABFChatViewController *vc = [[ABFChatViewController alloc] init];
        vc.model = self.data[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
    
        ABFVideoPlayerViewController *vc = [[ABFVideoPlayerViewController alloc] init];
        ABFVideoInfo *model = self.data[indexPath.row];
        vc.playUrl = [model.url  stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        vc.uid = model.id;
        vc.tvTitle = model.title;
        vc.model = model;
        //vc.hidesBottomBarWhenPushed = YES;
        //vc.tabBarController.tabBar.hidden = YES;
        //[self.navigationController pushViewController:vc animated:YES];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

-(void)pushForImage:(ABFChatInfo *)model imageIndex:(NSInteger)index{
    NSLog(@"title=%@",model.context);
    NSLog(@"index=%ld",index);
    //ABFPhotoViewController *vc = [[ABFPhotoViewController alloc] init];
    //vc.model = model;
    //vc.index = index;
    //[self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
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
