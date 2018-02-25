//
//  ABFChannelListViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFChannelListViewController.h"
#import "NavigationBarView.h"
#import "ABFChannelViewCell.h"
#import "ABFTelevisionInfo.h"
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "AppDelegate.h"
#import "ABFPlayerViewController.h"
#import "JHUD.h"
#import "ABFHttpManager.h"
#import "ABFMJRefreshGifHeader.h"
#import "ABFMJRefreshGifFooter.h"
#import "ABFCollectionViewCell.h"
#import "ABFCollectionSimpleCell.h"

@interface ABFChannelListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak) NavigationBarView *navBar;

@property(nonatomic,strong) NSMutableArray *dataArrays;

@property (nonatomic) JHUD *hudView;

@property(nonatomic,assign) NSInteger curIndexPage;

@property(nonatomic,assign) CGFloat width;

@property(nonatomic,assign) CGFloat height;

@property(nonatomic,assign) NSInteger type;

@end

@implementation ABFChannelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    //[AppDelegate APP].allowRotation = false;
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    _curIndexPage = 1;
    [self addCollectionView];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _collectionView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    
}

- (void)addRefreshHeader
{
    ABFMJRefreshGifHeader *header = [ABFMJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefresh)];
    self.collectionView.mj_header = header;
    
}

- (void)addRefreshFooter{
    ABFMJRefreshGifFooter *footer = [ABFMJRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataMore)];
    
    self.collectionView.mj_footer = footer;
}


- (void)addNavigationBarView{
    self.navigationController.navigationBar.backgroundColor = COMMON_COLOR;
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
    [leftBtn setImage:[UIImage imageNamed:@"icon_lightback"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0,0,20,20);
    [rightBtn setImage:[UIImage imageNamed:@"icon_square"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"icon_column"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(rightClick:)
       forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;

}



- (void) loadRefresh{
    _curIndexPage = 1;
    NSString *fullUrl = [BaseUrl stringByAppendingString:self.url];
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
    //[self.tableView.mj_header beginRefreshing];
    [self loadData:fullUrl type:1];
}

- (void) loadDataMore{
    _curIndexPage++;
    NSString *fullUrl = [BaseUrl stringByAppendingString:self.url];
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
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
    
    [[ABFHttpManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *temArray=[responseObject objectForKey:@"data"];
        /*
        if(temArray.count>0){
            _curIndexPage++;
        }*/
        NSLog(@"success%ld",[temArray count]);
        NSArray *arrayM = [ABFTelevisionInfo mj_objectArrayWithKeyValuesArray:temArray];
        
        if(type == 1){
            
            if([self.dataArrays count]> 0){
                
            }else{
                self.dataArrays = [arrayM mutableCopy];
                [self.collectionView reloadData];
            }
            [self.hudView hide];
            [self.collectionView.mj_header endRefreshing];
        }
        if(type == 2){
            if(arrayM.count > 0){
                //self.dataArrays = [self.dataArrays arrayByAddingObjectsFromArray:arrayM];
                self.dataArrays = [[self.dataArrays arrayByAddingObjectsFromArray:arrayM] mutableCopy];
                [self.collectionView reloadData];
                [self.collectionView.mj_footer endRefreshing];
            }else{
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
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
            [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
        }
        if(type == 2){
            [self.collectionView.mj_footer endRefreshing];
        }
        
    }];
    
}

-(void)refresh:(id)sender{
    [self loadDataFirst];
}


- (void)addCollectionView{
    self.type = 1;
    
    self.width = kScreenWidth/2;
    self.height = self.width*9/16 + 40;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.0f;//item左右间隔
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;//设置滚动方向,默认垂直方向.
    //flowLayout.headerReferenceSize=CGSizeMake(self.view.frame.size.width, 0);//头视图的大小
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    
    _collectionView = collectionView;
    
    [_collectionView registerClass:[ABFCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    [_collectionView registerClass:[ABFCollectionSimpleCell class] forCellWithReuseIdentifier:@"simpleCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    [self.view addSubview:collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArrays.count;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ABFTelevisionInfo *model = self.dataArrays[indexPath.row];
    
    if(self.type == 1){
        ABFCollectionViewCell *cell = (ABFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
        cell.titleLab.text = [NSString stringWithFormat:@"%@",model.name];
        [cell setModel:model];
        return cell;
    }else if(self.type == 2){
        ABFCollectionSimpleCell *cell = (ABFCollectionSimpleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
        cell.titleLab.text = [NSString stringWithFormat:@"%@",model.name];
        [cell setModel:model];
        return cell;
    }
    
    
    //NSLog(@".......%@",model.name);
    return nil;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"widht=%f",self.width);
    return CGSizeMake(self.width, self.height);
}
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = (UICollectionReusableView *)[collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        
        headerView.backgroundColor = [UIColor clearColor];
        reusableview = headerView;
    }
    
    
    return reusableview;
}*/



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(kScreenWidth, 0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[collectionView deselectRowAtIndexPath:indexPath animated:YES];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ABFPlayerViewController *vc = [[ABFPlayerViewController alloc] init];
    ABFTelevisionInfo *model = self.dataArrays[indexPath.row];
    vc.playUrl = [model.url_1  stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];;
    vc.uid = model.id;
    vc.model = model;
    vc.tvTitle = model.name;
    //vc.hidesBottomBarWhenPushed = YES;
    //vc.tabBarController.tabBar.hidden = YES;
    //[/self.navigationController pushViewController:vc animated:YES];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)rightClick:(id)sender{
    NSLog(@"right");
    //_collectionView
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    if(btn.selected){
        self.width = kScreenWidth;
        NSLog(@"widht=%f",self.width);
        self.height = (self.width*9/16)/2+10+10;
        self.type = 2;
        [self.collectionView reloadData];
    }else{
        self.width = kScreenWidth/2;
        self.height = self.width*9/16 + 40;
        self.type = 1;
        [self.collectionView reloadData];
    }
    
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
