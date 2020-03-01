//
//  ABFProvViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/14.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFProvViewController.h"
#import "ABFCollectionViewCell.h"
#import "ABFPlayerViewController.h"
#import "ABFTelevisionInfo.h"
#import "JHUD.h"
#import <PPNetworkHelper.h>
#import "ABFMJRefreshGifFooter.h"
#import "ABFMJRefreshGifHeader.h"
#import "ABFCollectionSimpleCell.h"

@interface ABFProvViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic) JHUD *hudView;

@property(nonatomic,strong) NSMutableArray *dataArrays;

@property(nonatomic,assign) NSInteger curIndexPage;

@property(nonatomic,assign) CGFloat width;

@property(nonatomic,assign) CGFloat height;

@property(nonatomic,assign) NSInteger type;

@end

@implementation ABFProvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setTitleLabUI];
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    [self addCollectionView];
    [self addRefreshHeader];
    [self addRefreshFooter];
    _curIndexPage = 1;
    [self loadDataFirst];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    //_collectionView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-self.tabBarController.tabBar.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setStatusBarBackgroundColor:COMMON_COLOR];
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


- (void)addRefreshHeader
{
    ABFMJRefreshGifHeader *header = [ABFMJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefresh)];
    self.collectionView.mj_header = header;
    
}

- (void)addRefreshFooter{
    ABFMJRefreshGifFooter *footer = [ABFMJRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataMore)];
    self.collectionView.mj_footer = footer;
}

-(void)setTitleLabUI{
    
    UILabel *tab = [[UILabel alloc] init];
    tab.text = self.code;
    tab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tab];
    [tab mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.view).offset(0);
        
        make.width.height.mas_equalTo(100);
    }];
    

}

- (void)addCollectionView{
    
    self.type = 1;
    
    self.width = kScreenWidth/2;
    self.height = self.width*9/16 + 40;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.0f;//item左右间隔
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;//设置滚动方向,默认垂直方向.
    flowLayout.headerReferenceSize=CGSizeMake(self.view.frame.size.width, 0);//头视图的大小
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -44-64);
    
    _collectionView = collectionView;
    
    [_collectionView registerClass:[ABFCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_collectionView registerClass:[ABFCollectionSimpleCell class] forCellWithReuseIdentifier:@"simpleCell"];
    
    [self.view addSubview:collectionView];
    
}

-(void)changeCell:(BOOL)flag{
    
    
    
     if(flag){
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

- (void) loadRefresh{
    _curIndexPage = 1;
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVProvinceUrl];
    fullUrl = [fullUrl stringByAppendingFormat:@"/%@",self.code];
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
    [self loadData:fullUrl type:1];
}

- (void) loadDataMore{
    _curIndexPage++;
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVProvinceUrl];
    fullUrl = [fullUrl stringByAppendingFormat:@"/%@",self.code];
    fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
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
        NSLog(@"success%ld",[temArray count]);
        NSArray *arrayM = [ABFTelevisionInfo mj_objectArrayWithKeyValuesArray:temArray];
        
        if(type == 1){
            if(self.dataArrays > 0){
                
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
                //self.dataArrays = [[arrayM arrayByAddingObjectsFromArray:self.dataArrays] mutableCopy];
                self.dataArrays = [[self.dataArrays arrayByAddingObjectsFromArray:arrayM] mutableCopy];
                [self.collectionView reloadData];
                [self.collectionView.mj_footer endRefreshing];
            }else{
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        
    } failure:^( NSError *error) {
        NSLog(@"error%@",error);
        
        if(type == 1){
            [self.collectionView.mj_header endRefreshing];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArrays.count;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    /*
    ABFCollectionViewCell *cell = (ABFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    ABFTelevisionInfo *model = self.dataArrays[indexPath.row];
    
    //NSLog(@".......%@",model.name);
    
    cell.titleLab.text = [NSString stringWithFormat:@"%@",model.name];
    [cell setModel:model];
    return cell;*/
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
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //CGFloat width = kScreenWidth/2;
    //CGFloat height = width * 9 /16+40;
    return CGSizeMake(self.width, self.height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView *reusableview = nil;
    
    if(kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = (UICollectionReusableView *)[collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        
        headerView.backgroundColor = [UIColor clearColor];
        reusableview = headerView;
    }
    
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(kScreenWidth, 0.0);
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
    vc.playUrl = model.url_1;
    vc.uid = model.id;
    vc.tvTitle = model.name;
    vc.model = model;
    //vc.hidesBottomBarWhenPushed = YES;
    //vc.tabBarController.tabBar.hidden = YES;
    //[self.navigationController pushViewController:vc animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
