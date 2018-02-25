//
//  ABFHomeViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFHomeViewController.h"
#import "TitleLineLabel.h"
#import "LoadingView.h"
#import "ABFMenuView.h"
#import "TitleHeaderSectionView.h"
#import "ABFCollectionReusableView.h"
#import "ABFHomeTopCollectionReusableView.h"
#import "ABFCollectionViewCell.h"
#import "ABFTelevisionInfo.h"
#import "ABFHomeInfo.h"
#import "ABFChannelListViewController.h"
#import "ABFPlayerViewController.h"
#import "ABFAllChannelViewController.h"
#import "ABFProvinceViewController.h"
#import "ABFSearchViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ABFHttpManager.h"
#import "JHUD.h"
#import "ABFMJRefreshGifHeader.h"
#import "SDCycleScrollView.h"
#import "ABFProvinceInfo.h"
#import <CoreLocation/CoreLocation.h>

//static NSUInteger titleTabHeight = 40 ;

@interface ABFHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,NavBindingDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,
    CLLocationManagerDelegate>{
    
}

//ui
@property(nonatomic,weak)   ABFMenuView *channelView;

@property(nonatomic,weak)   ABFHomeTopCollectionReusableView *headerView;

@property (nonatomic)       JHUD *hudView;

@property(nonatomic,weak)   SDCycleScrollView *sdcsv;
//data
@property(nonatomic,strong) NSMutableArray *menuArray;

@property(nonatomic,strong) NSMutableArray *recordData;

@property(nonatomic,strong) ABFHomeInfo    *homeInfo;

@property(nonatomic,strong) NSMutableArray *images;

@property(nonatomic,strong) NSString       *headerTitle;

@property(nonatomic,assign) BOOL update;

@property(nonatomic,assign) NSString *code;

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation ABFHomeViewController

#pragma mark - ******************** 懒加载


- (NSMutableArray*)menuArray{
    
    if(_menuArray == nil){
        _menuArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"channels.plist" ofType:nil]];
    }

    return _menuArray;
}

- (NSMutableArray*)recordData{
    if(_recordData == nil){
        _recordData = [NSMutableArray new];
        
        NSArray *array= [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"provinces.plist" ofType:nil]];
        for (NSDictionary *obj in array) {
            ABFProvinceInfo *p = [ABFProvinceInfo new];
            p.fullname = [obj objectForKey:@"fullname"];
            p.shortname = [obj objectForKey:@"shortname"];
            p.code = [obj objectForKey:@"code"];
            
            [_recordData addObject:p];
        }
    }
    return _recordData;
}

-(void) initData{
    NSArray *imageArray = [NSArray arrayWithObjects:
                           @"http://www.comke.net/public/upload/ad/img2017-02-1223-38-41.gif",
                           @"http://www.comke.net/public/upload/ad/img2017-02-1200-48-46.gif",
                           @"http://www.comke.net/public/upload/ad/img2017-02-1200-54-23.gif",nil];
    _images = [[NSMutableArray array] init];
    _images = [NSMutableArray arrayWithArray:imageArray];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //self.edgesForExtendedLayout = UIRectEdgeBottom;
    //调整的是UIScrollView显示内容的位置
    self.automaticallyAdjustsScrollViewInsets = NO;
    //[AppDelegate APP].area = @"推荐";
    
    
    
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    //[self addTableView];
    [self initData];
    [self addCollectionView];
    //[self initChannelView];
    //[self setCollectionHeaderView];
    [self loadDataFirst];
    self.update = YES;
    [self addRefreshHeader];
    
    [self startLocation];
    
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [AppDelegate APP].allowRotation = false;
    
    //self.navigationController.navigationBarHidden=YES;
    //隐藏
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initNavigationBar];
    [self.tabBarController.tabBar setHidden:NO];
    
    if (self.update == YES) {
        [self.tableView.mj_header beginRefreshing];
        self.update = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _collectionView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-self.tabBarController.tabBar.frame.size.height);
    self.channelView.frame = CGRectMake(0, 0, kScreenWidth, 160);
}


//***********nav*************
//设置导航栏的颜色
- (void)initNavigationBar{
    [self.navigationController.navigationBar setBarTintColor:COMMON_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault] ;
    
    [self setNavinationItemButtons];
}

//设置导航的按钮
- (void)setNavinationItemButtons{

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0,0,20,20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(searchClick:)
      forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0,0,20,20);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_logo"]];
    self.navigationItem.titleView = imageView;
}

-(void)searchClick:(id)sender{
    NSLog(@"....");
    ABFSearchViewController *vc = [[ABFSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//***********nav*************

/********channels****/

- (void)initChannelView{
    ABFMenuView *channelView = [[ABFMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160) menuArray:self.menuArray];
    //[self.collectionView addSubview:channelView];
    self.channelView = channelView;
    self.channelView.delegate = self;
    
}


- (void)addRefreshHeader
{
    ABFMJRefreshGifHeader *header = [ABFMJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.collectionView.mj_header = header;
    
}

- (void)addCollectionView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//item左右间隔
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;//设置滚动方向,默认垂直方向.
    flowLayout.headerReferenceSize=CGSizeMake(self.view.frame.size.width, 40);//头视图的大小
    //flowLayout.sectionHeadersPinToVisibleBounds = YES;
    flowLayout.sectionFootersPinToVisibleBounds = YES;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    _collectionView = collectionView;
    [_collectionView registerClass:[ABFCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_collectionView registerClass:[ABFHomeTopCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topheaderView"];
    [_collectionView registerClass:[ABFCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];

    [self.view addSubview:collectionView];
    
}

/********channels*****/

- (void) loadDataFirst{

    self.hudView.messageLabel.text = @"数据加载中...";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    [self loadData];
}


- (void) loadData{
    
    
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVIndexUrl];
    
    if([AppDelegate APP].postcode != nil){
        //[AppDelegate APP].area = @"北京";
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",[AppDelegate APP].postcode]];
    }
    
    [[ABFHttpManager manager]GET:fullUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *temArray=[responseObject objectForKey:@"data"];
        
        NSLog(@"success");
        
        self.homeInfo = [ABFHomeInfo mj_objectWithKeyValues:temArray];
        
        NSInteger image_nums = [self.homeInfo.ads count];
        if(image_nums > 0){
            //NSLog(@"images count%d",image_nums);
            [_images removeAllObjects];
            
            for(ABFTelevisionInfo *tv in [self.homeInfo valueForKey:@"ads"]){
                [_images addObject:tv.bg];
                NSLog(@"%@",[NSString stringWithFormat:@"%@",tv.name]);
            }
            _sdcsv.imageURLStringsGroup = [_images copy];
        }
        
        [self.collectionView.mj_header endRefreshing];
        
        
        
        [self.collectionView reloadData];
        [self.hudView hide];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error%@",error);
        [self.collectionView.mj_header endRefreshing];
        self.hudView.indicatorViewSize = CGSizeMake(100, 100);
        self.hudView.messageLabel.text = @"连接网络失败，请重新连接";
        [self.hudView.refreshButton setTitle:@"重新连接" forState:UIControlStateNormal];
        [self.hudView.refreshButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        self.hudView.customImage = [UIImage imageNamed:@"bg_null"];
        [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
        
    }];
    
    
    
}
-(void)refresh:(id)sender{
    [self loadDataFirst];
}

//*********************

-(NSArray *) commentsInSection:(NSInteger)section{
    
    if(section == 0){
        return [self.homeInfo valueForKey:@"recommends"];
    }/*else if(section == 1){
        return [self.homeInfo valueForKey:@"news"];
    }*/else if(section == 1){
        return [self.homeInfo valueForKey:@"hots"];
    }else if(section == 2){
        return [self.homeInfo valueForKey:@"cartoons"];
    }else if(section == 3){
        return [self.homeInfo valueForKey:@"foreigns"];
    }else if(section == 4){
        return [self.homeInfo valueForKey:@"hongkongs"];
    }
    
    return nil;
}

-(ABFTelevisionInfo *) commentInIndexPath:(NSIndexPath *) indexPath{
    
    return [self commentsInSection:indexPath.section][indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(section == 0){
        return [[self.homeInfo valueForKey:@"recommends"] count];
    }
    
    if(section == 1){
    
        return [[self.homeInfo valueForKey:@"hots"] count];
    }
    if(section == 2){
        
        return [[self.homeInfo valueForKey:@"cartoons"] count];
    }
    
    if(section == 3){
        
        return [[self.homeInfo valueForKey:@"foreigns"] count];
    }
    
    if(section == 4){
        
        return [[self.homeInfo valueForKey:@"hongkongs"] count];
    }
    
    
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //UICollectionReusableView *reusableview = nil;
    
    if(kind == UICollectionElementKindSectionHeader){
        /**
         *
         * 注意:虽然这里没有看到明显的initWithFrame方法,但是在获取重用视图的时候,系统会自动调用initWithFrame方法的.所以在initWithFrame里面进行初始化操作,是没有问题的!
         */
        if(indexPath.section == 0){
            ABFHomeTopCollectionReusableView *headerView = (ABFHomeTopCollectionReusableView *)[collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topheaderView" forIndexPath:indexPath];
            if([AppDelegate APP].area == nil){
                [AppDelegate APP].area = @"北京";
            }
            headerView.title = [NSString stringWithFormat:@"%@",[AppDelegate APP].area];
            headerView.moreBtn.hidden = YES;
            
            
            //menu
            ABFMenuView *channelView = [[ABFMenuView alloc] init];
            self.channelView = channelView;
            channelView.delegate = self;
            [channelView setMenuArray:self.menuArray];
            //[headerView.topView insertSubview:channelView atIndex:1];
            [headerView.topView addSubview:channelView];
            //ad
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 150) delegate:self placeholderImage:nil];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            cycleScrollView.currentPageDotColor = [UIColor whiteColor];
            
            cycleScrollView.placeholderImage = [UIImage imageWithColor:RGB_255(245, 245, 245)];
            _sdcsv = cycleScrollView;
            cycleScrollView.imageURLStringsGroup = [_images copy];
            //[headerView.adView insertSubview:cycleScrollView atIndex:1];
            [headerView.adView addSubview:cycleScrollView];
            _headerView = headerView;
            
            return headerView;
            
        }/*else if(indexPath.section == 1){
            ABFCollectionReusableView *headerView = (ABFCollectionReusableView *)[collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            headerView.title = @"最新";
            return headerView;
        }*/else if(indexPath.section == 1){
            ABFCollectionReusableView *headerView = (ABFCollectionReusableView *)[collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            headerView.title = @"热门";
            headerView.moreBtn.hidden = NO;
            return headerView;
        }else if(indexPath.section == 2){
            ABFCollectionReusableView *headerView = (ABFCollectionReusableView *)[collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            headerView.title = @"动漫";
            headerView.moreBtn.hidden = NO;
            return headerView;
        }else if(indexPath.section == 3){
            ABFCollectionReusableView *headerView = (ABFCollectionReusableView *)[collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            headerView.title = @"日韩";
            headerView.moreBtn.hidden = NO;
            return headerView;
        }else if(indexPath.section == 4){
            ABFCollectionReusableView *headerView = (ABFCollectionReusableView *)[collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            headerView.title = @"港澳台";
            headerView.moreBtn.hidden = NO;
            return headerView;
        }
        
        //reusableview = headerView;
    }

    return nil;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ABFCollectionViewCell *cell = (ABFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    ABFTelevisionInfo *model = [self commentInIndexPath:indexPath];
    
    NSLog(@".......%@",model.name);
    
    cell.titleLab.text = [NSString stringWithFormat:@"%@",model.name];
    [cell setModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return CGSizeMake(kScreenWidth, 200+150);
    }
    return CGSizeMake(kScreenWidth, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = kScreenWidth/2;
    CGFloat height = width * 9 /16+40;
    return CGSizeMake(width, height);
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
    ABFTelevisionInfo *model = [self commentInIndexPath:indexPath];
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

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}





- (void)pushVC:(id)sender name:(NSString *)name url:(NSString *)url
{
    
    if([name isEqualToString:@"全部"]){
        
        ABFAllChannelViewController *vc = [[ABFAllChannelViewController alloc] init];
        vc.title = name;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if([name isEqualToString:@"地方台"]){
    
        ABFProvinceViewController *vc = [[ABFProvinceViewController alloc] init];
        vc.title = name;
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
    
        ABFChannelListViewController *webVC = [[ABFChannelListViewController alloc] init];
        
        webVC.title = name;
        webVC.url = url;
        
        NSLog(@"url:%@",url);
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    
}

- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.desiredAccuracy=  kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        //self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
        NSLog(@"%@",error);
    }
}

//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);//石家庄市
            NSLog(@"--%@",placemark.name);//黄河大道221号
            NSLog(@"++++%@",placemark.subLocality); //裕华区
            NSLog(@"country == %@",placemark.country);//中国
            NSLog(@"administrativeArea == %@",placemark.administrativeArea); //河北省
            
            BOOL result = [city containsString:@"市"];
            if(result){
                city = [city stringByReplacingOccurrencesOfString:@"市"withString:@""];
            }
            //self.headerTitle = placemark.administrativeArea;
            //[AppDelegate APP].area = placemark.administrativeArea;
            //self.headerView.title = [NSString stringWithFormat:@"推荐-%@",[AppDelegate APP].area];
            //[self.collectionView reloadData];
            
            
            for(ABFProvinceInfo *p in self.recordData){
                
                if([p.fullname isEqualToString:placemark.administrativeArea]){
                    [AppDelegate APP].area  =city;
                    self.headerView.title = [NSString stringWithFormat:@"%@",[AppDelegate APP].area];
                    
                    //[AppDelegate APP].area = p.shortname;
                    [AppDelegate APP].postcode = p.code;
                    //[self.collectionView reloadData];
                    
                    NSString *fullUrl = [BaseUrl stringByAppendingString:TVProvinceForIndexUrl];
                    fullUrl = [fullUrl stringByAppendingFormat:@"%@",p.code];
                    NSLog(@"%@",fullUrl);
                    
                    
                    [[ABFHttpManager manager]GET:fullUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSArray *temArray=[responseObject objectForKey:@"data"];
                        //NSLog(@"success%ld",[temArray count]);
                        //self.homeInfo = [ABFHomeInfo mj_objectWithKeyValues:temArray];
                        NSArray *arrayM = [ABFTelevisionInfo mj_objectArrayWithKeyValuesArray:temArray];
                        NSMutableArray *temp = [NSMutableArray new];
                        if(temArray.count > 0){
                            for(ABFProvinceInfo *p in arrayM){
                                //NSString *num = [arrayM objectAtIndex:arc];
                                [temp addObject:p];
                            }
                            self.homeInfo.recommends = [temp copy];
                            [self.collectionView reloadData];
                        }
                        
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"error%@",error);
                    }];
                    
                }
                
                NSLog(@"%@",p.code);
            }
            
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
    
}

-(void) loadProvinceTVData{

    NSString *fullUrl = [BaseUrl stringByAppendingString:TVProvinceUrl];
    fullUrl = [fullUrl stringByAppendingFormat:@"/%@",self.code];
    [[ABFHttpManager manager]GET:fullUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *temArray=[responseObject objectForKey:@"data"];
        NSLog(@"success%ld",[temArray count]);
        NSArray *arrayM = [ABFTelevisionInfo mj_objectArrayWithKeyValuesArray:temArray];
        NSMutableArray *temp = [NSMutableArray new];
        if(temArray.count > 2){
            for(int i = 0; i< 2; i++){
                int arc = arc4random() % temArray.count;
                //NSString *num = [arrayM objectAtIndex:arc];
                [temp addObject:[arrayM objectAtIndex:arc]];
            }
            self.homeInfo.recommends = [temp copy];
            [self.collectionView reloadData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error%@",error);
    }];

    
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
