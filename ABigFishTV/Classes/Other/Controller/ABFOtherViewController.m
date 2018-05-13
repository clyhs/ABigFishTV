//
//  ABFOtherViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFOtherViewController.h"
#import "MyLayout.h"
#import "ABFOtherSimpleCell.h"
#import "MXParallaxHeader.h"
#import "ABFSearchViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "SDCycleScrollView.h"


@interface ABFOtherViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,SDCycleScrollViewDelegate>{
    NSMutableArray *_images;
}

@property(nonatomic,weak)    UIView *navView;
@property(nonatomic,weak)    UIView *searchView;
@property(nonatomic,weak)    MyFloatLayout *mylayout;
@property(nonatomic,strong)  NSMutableArray *menuArrays;
@property(nonatomic,strong)  NSMutableArray *dataArrays;
@property(nonatomic,weak)    UILabel *titleLab;
@property(nonatomic,weak)    SDCycleScrollView *sdcsView;
@property(nonatomic,assign)  double nheight;
@property(nonatomic,assign)  CGFloat adHeight;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation ABFOtherViewController

-(NSMutableArray *)menuArrays{

    if(_menuArrays == nil){
        _menuArrays = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test.plist" ofType:nil]];
    }
    return _menuArrays;
}

-(NSMutableArray *)dataArrays{
    
    if(_dataArrays == nil){
        _dataArrays = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"others.plist" ofType:nil]];
    }
    return _dataArrays;
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
    self.view.backgroundColor = LINE_BG;
    //self.title = @"";
    self.adHeight = kScreenWidth /3;
    //[AppDelegate APP].allowRotation = false;
    [self initData];
    [self addTableView];
    
    [self addTableHeaderView];
    
    [self loaddata];
    
    [self startLocation];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegate APP].allowRotation = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setStatusBarBackgroundColor:COMMON_COLOR];
    //隐藏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self initNavigationBar];
    
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    _tableView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height+statusBar.frame.size.height, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height-statusBar.frame.size.height);
    
}

//设置导航栏的颜色
- (void)initNavigationBar{
    //UIView *navView = [[UIView alloc] init];
    //navView.backgroundColor = COMMON_COLOR;
    //[self.view addSubview:navView];
    [self.navigationController.navigationBar setBarTintColor:COMMON_COLOR];
    //_navView = self.navigationController.navigationBar.v;
    self.navigationController.navigationBar.translucent = NO;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 80, 25)];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:20];
    if([AppDelegate APP].area !=nil){
        title.text = [AppDelegate APP].area;
    }else{
        title.text = @"发现";
    }
    
    _titleLab = title;
    
    [self.navigationController.navigationBar addSubview:title];
    
    [self setupSearchUI];
    [self makeConstraints];
}

- (void)setupSearchUI{
    
    UIView *searchView = [[UIView alloc] init];
    //searchView.backgroundColor = RGB_255(17, 120, 246);
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 12;
    [self.navigationController.navigationBar addSubview:searchView];
    searchView.frame= CGRectMake(80, 6, kScreenWidth-80-20, 26);
    _searchView = searchView;
    
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 16, 16)];
    [searchImage setImage:[UIImage imageNamed:@"icon_lightsearch"]];
    [searchView addSubview:searchImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    [searchView addGestureRecognizer:tap];
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 150, 25)];
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
    placeHolderLabel.text = @"请输入关键字";
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [searchView addSubview:placeHolderLabel];
}

- (void)makeConstraints{
    
    /*
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
     make.height.mas_equalTo(self.navigationController.navigationBar.frame.size.height);
    }];*/
    /*
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navView).offset(80);
        make.top.equalTo(self.navView).offset(30);
        make.height.mas_equalTo(25);
        make.right.equalTo(self.navView).offset(-20);
    }];*/
    
}

/*********table********/

- (void) addTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = LINE_BG;
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[ABFOtherSimpleCell class] forCellReuseIdentifier:@"mycell"];
    _tableView = tableView;
    
}

- (void) addTableHeaderView{
    
    NSInteger count = [self.menuArrays count];
    MyFloatLayout *mylayout  = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    mylayout.wrapContentHeight = YES;
    mylayout.myWidth = kScreenWidth;
    mylayout.myTop = 0;
    mylayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    mylayout.gravity = MyGravity_Horz_Fill;
    mylayout.subviewSpace = 10;
    
    CGFloat w = 90.0f;
    CGFloat totalheight = 25.0f;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"热门关键词：";
    titleLab.textColor = COMMON_COLOR;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font =[UIFont systemFontOfSize:14];
    titleLab.mySize = CGSizeMake(90,25);
    [mylayout addSubview:titleLab];
    
    for(int i=0;i<count;i++){
        
        NSString *name = [self.menuArrays[i] objectForKey:@"name"] ;
        CGFloat width = [name length] *12 +25;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:name forState:UIControlStateNormal];
        btn.tintColor = [UIColor lightGrayColor];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.mySize = CGSizeMake(width,25);
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改
        btn.layer.borderColor = RGB_255(204,204,204).CGColor;
        btn.layer.borderWidth = 1.0f;//设置边框颜色
        btn.tag =  i;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(searchAction:)
      forControlEvents:UIControlEventTouchUpInside];
        [mylayout addSubview:btn];
        
        w = w + width + 20;
        NSLog(@"w=%f,screenw=%f",w,kScreenWidth);
        if(w >= kScreenWidth){
            totalheight = totalheight + 30;
            w = width;
        }
    }
    mylayout.backgroundColor = [UIColor whiteColor];
    _mylayout = mylayout;
    NSLog(@"%f",totalheight);
    NSLog(@"%f",mylayout.myHeight);
    int i = 0;
    i = totalheight / 25.0f;
    CGFloat nheight = 0.0f;
    NSLog(@"%d",i);
    if(i <= 1){
        nheight = 25 + totalheight;
        
    }else{
        nheight = (i-1)*25 + totalheight;
    }
    _nheight = nheight;
    
    
    UIView  *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,nheight+self.adHeight)];
    
    [self addCycleScrollView];
    UIView *adView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,self.adHeight)];
    
    [adView addSubview:_sdcsView];
    [headerView addSubview:adView];
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, self.adHeight, kScreenWidth,nheight)];
    [myView addSubview:mylayout];
    [headerView addSubview:myView];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _tableView.parallaxHeader.view = headerView;
    _tableView.parallaxHeader.height = nheight +self.adHeight;
    _tableView.parallaxHeader.mode = MXParallaxHeaderModeFill;
}


- (void)addCycleScrollView
{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.adHeight) delegate:self placeholderImage:nil];
    //cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    cycleScrollView.placeholderImage = [UIImage imageWithColor:RGB_255(245, 245, 245)];
    
    cycleScrollView.imageURLStringsGroup = [_images copy];
    //_tableView.tableHeaderView = cycleScrollView;
    _sdcsView = cycleScrollView;
}

-(void)loaddata{
    [self.tableView reloadData];
}

-(void)searchAction:(id)sender{
    UIButton *btn = sender;
    NSLog(@"btn.tag=%ld",btn.tag);
    NSString *name = [self.menuArrays[btn.tag] objectForKey:@"name"];
    
    ABFSearchViewController *vc = [[ABFSearchViewController alloc] init];
    NSLog(@"search text=%@",name);
    vc.searchKey = name;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)onClick:(id)sender{
    NSLog(@"....");
    ABFSearchViewController *vc = [[ABFSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArrays count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *title = [self.dataArrays[indexPath.row] objectForKey:@"name"];
    //NSLog(@"title=%@",title);
    ABFOtherSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    cell.textLabel.text = title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
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
            //[AppDelegate APP].area = placemark.administrativeArea;
            _titleLab.text = city;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
