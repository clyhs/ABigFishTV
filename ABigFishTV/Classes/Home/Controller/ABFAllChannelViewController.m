//
//  ABFAllChannelViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/8.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFAllChannelViewController.h"
#import "NavigationBarView.h"
#import "ABFLeftTableViewCell.h"
#import "ABFChannelViewCell.h"
#import "TitleHeaderSectionView.h"
#import "ABFPlayerViewController.h"
#import "JHUD.h"
#import "ABFRightTableViewCell.h"
#import <PPNetworkHelper.h>
#import "AppDelegate.h"
#import "ABFDictInfo.h"
#import "ABFTelevisionInfo.h"

@interface ABFAllChannelViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,weak)    NavigationBarView        *navBar;

@property (nonatomic)         JHUD                     *hudView;

@property (nonatomic, strong) NSMutableArray           *dataArrays;

@property (strong, nonatomic) NSIndexPath              *currentSelectIndexPath;

@property (strong,nonatomic)  UISwipeGestureRecognizer *recognizer;

@property(nonatomic,strong)   UIView                   *mainView;


@end

@implementation ABFAllChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    [self setMainView];
    //[AppDelegate APP].allowRotation = false;
    UISwipeGestureRecognizer *recognizer= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    [self addTableView];
    [self loadData];
    
    
}

- (void)setMainView{
    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:_mainView];
    
    self.hudView = [[JHUD alloc]initWithFrame:self.mainView.bounds];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏
    [AppDelegate APP].allowRotation = false;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setStatusBarBackgroundColor:COMMON_COLOR];
    [self.tabBarController.tabBar setHidden:YES];
    [self addNavigationBarView];
    //[UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)addNavigationBarView{
    self.navigationController.navigationBar.backgroundColor = COMMON_COLOR;
    //self.navigationController.navigationBar.alpha = 0.8;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(backClick:)
      forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[leftBtn setTitle:@"" forState:UIControlStateNormal];
    //[leftBtn setFont:[UIFont systemFontOfSize: 14.0]];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0,60,20);
    [leftBtn setImage:[UIImage imageNamed:@"icon_lightback"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height - 20);
    //_leftTableView.frame = CGr
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)addTableView{

    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    leftTableView.backgroundColor = LINE_BG;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    [self.mainView addSubview:leftTableView];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTableView.bounces = NO;
    _leftTableView = leftTableView;
    [leftTableView registerClass:[ABFLeftTableViewCell class] forCellReuseIdentifier:@"leftcell"];
    
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    rightTableView.backgroundColor = [UIColor clearColor];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    [self.mainView addSubview:rightTableView];
    rightTableView.bounces = NO;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView =rightTableView;
    [rightTableView registerClass:[ABFRightTableViewCell class] forCellReuseIdentifier:@"rightcell"];
    
    _leftTableView.frame = CGRectMake(0, 0, kScreenWidth*0.25, kScreenHeight-64);
    _rightTableView.frame = CGRectMake(kScreenWidth*0.25, 0, kScreenWidth*0.75, kScreenHeight-64);
}

-(void)loadData{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVAllChannelUrl];
    self.hudView.messageLabel.text = @"数据加载中...";
    [self.hudView showAtView:self.mainView hudType:JHUDLoadingTypeCircle];
    [PPNetworkHelper GET:fullUrl parameters:nil responseCache:^(id responseCache) {
        //加载缓存数据
    } success:^(id responseObject) {
        
        NSArray *temArray=[responseObject objectForKey:@"data"];
        
        NSLog(@"success%ld",[temArray count]);
        
        NSArray *arrayM = [ABFDictInfo mj_objectArrayWithKeyValuesArray:temArray];
        self.dataArrays = [arrayM mutableCopy];
        
        
        //NSLog(@"%d",[self.dataArrays count]);
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
        [self.hudView hide];
        
    } failure:^(NSError *error) {
        self.hudView.indicatorViewSize = CGSizeMake(100, 100);
        self.hudView.messageLabel.text = @"连接网络失败，请重新连接";
        [self.hudView.refreshButton setTitle:@"重新连接" forState:UIControlStateNormal];
        self.hudView.customImage = [UIImage imageNamed:@"bg_null"];
        [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
        
    }];

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(tableView == self.rightTableView) return self.dataArrays.count;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.leftTableView){
        
        return [self.dataArrays count];
    }
    if(tableView == self.rightTableView){
        
        return [[self.dataArrays[section] valueForKey:@"tvs"] count];
        
    }
    return 0;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) return nil;
    return [self.dataArrays[section] valueForKey:@"name"];
}*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.leftTableView){
        ABFLeftTableViewCell *cell = (ABFLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"leftcell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ABFLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"leftcell"];
        }
        ABFDictInfo *model = self.dataArrays[indexPath.row];
        cell.titleLab.text = model.name;
        [cell setIconUrl:model.icon];
        return cell;
    }
    
    if(tableView == self.rightTableView){
        
        ABFRightTableViewCell *cell = (ABFRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"rightcell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ABFRightTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"rightcell"];
        }
    
        NSMutableArray *tvs =[ABFTelevisionInfo mj_objectArrayWithKeyValuesArray:[self.dataArrays[indexPath.section] valueForKey:@"tvs"]];
        ABFTelevisionInfo *model = tvs[indexPath.row];

        [cell setModel:model];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushVC:)];
        [cell addGestureRecognizer:tap];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;

    }
    
    return nil;
}

-(void)pushVC:(id)sender{
    NSLog(@"123");
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    ABFRightTableViewCell *cell = (ABFRightTableViewCell *)tap.view;
    
    ABFPlayerViewController *vc = [[ABFPlayerViewController alloc] init];
    
    vc.playUrl = cell.model.url_1;
    vc.uid = cell.model.id;
    vc.tvTitle = cell.model.name;
    vc.model = cell.model;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 如果点击的是右边的tableView，不做任何处理
    if (tableView == self.rightTableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    // 点击左边的tableView，设置选中右边的tableView某一行。左边的tableView的每一行对应右边tableView的每个分区
    if (tableView == self.leftTableView){
        NSMutableArray *tvs =[ABFTelevisionInfo mj_objectArrayWithKeyValuesArray:[self.dataArrays[indexPath.row] valueForKey:@"tvs"]];
        
        if(tvs.count > 0){
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
            [self.rightTableView scrollToRowAtIndexPath:scrollIndexPath
                                    atScrollPosition:UITableViewScrollPositionTop animated:YES];
            self.currentSelectIndexPath = indexPath;
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.leftTableView) return 40;
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(tableView == self.rightTableView) return 0.1f;
    
    return 1.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectLeftTableViewWithScrollView:(UIScrollView *)scrollView {
    if (self.currentSelectIndexPath) {
        return;
    }
    // 如果现在滑动的是左边的tableView，不做任何处理
    if ((UITableView *)scrollView == self.leftTableView) return;
    // 滚动右边tableView，设置选中左边的tableView某一行。indexPathsForVisibleRows属性返回屏幕上可见的cell的indexPath数组，利用这个属性就可以找到目前所在的分区
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightTableView.indexPathsForVisibleRows.firstObject.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{ // 监听tableView滑动
    [self selectLeftTableViewWithScrollView:scrollView];

    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 重新选中一下当前选中的行数，不然会有bug
    if (self.currentSelectIndexPath) self.currentSelectIndexPath = nil;
}



-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        NSLog(@"swipe left");
        
        //执行程序
        [UIView animateWithDuration:0.5 animations:^{
        
            _leftTableView.alpha = 0;
            _rightTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
            [_rightTableView reloadData];
        }];
        
        
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        NSLog(@"swipe right");
        [UIView animateWithDuration:0.5 animations:^{
            _leftTableView.alpha = 1;
            _rightTableView.frame = CGRectMake(kScreenWidth*0.25, 64, kScreenWidth*0.75, kScreenHeight-64);
            [_rightTableView reloadData];
        }];
        
        //执行程序
    }
}





@end
