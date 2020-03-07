//
//  ABFSearchViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/15.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFSearchViewController.h"
#import <PPNetworkHelper.h>
#import "JHUD.h"
#import "ABFTelevisionInfo.h"
#import "ABFMineSimpleCell.h"
#import "AppDelegate.h"
#import "ABFPlayerViewController.h"

@interface ABFSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,weak) UIView *navView;

@property(nonatomic,strong) UITextField *searchTF;

@property (weak, nonatomic) UISearchBar *searchBar;

@property (nonatomic) JHUD *hudView;

@property (nonatomic, strong) NSMutableArray *dataArrays;

@property(nonatomic,strong) UIView     *mainView;


@end

@implementation ABFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //[AppDelegate APP].allowRotation = false;
    [self setuiMainView];
    [self setNaviUI];
    [self setSearchTF];
    [self addTableView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegate APP].allowRotation = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setStatusBarBackgroundColor:LINE_BG];
    _searchBar.hidden=NO;
    _searchBar.alpha = YES;
    //隐藏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    if(self.searchKey){
        self.searchTF.text = self.searchKey;
        [self loadData];
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    _searchBar.hidden=YES;
    _searchBar.alpha = 0;
    _searchTF.inputView = nil;
    [_searchTF resignFirstResponder];
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

- (void)setuiMainView{
    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.frame = CGRectMake(0,0, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:_mainView];
}

-(void)setNaviUI{
    
    //UIView *navView = [[UIView alloc] init];
    //navView.backgroundColor = LINE_BG;
    //[self.view addSubview:navView];
    //_navView = navView;
    [self.navigationController.navigationBar setBarTintColor:LINE_BG];
    //_navView = self.navigationController.navigationBar.v;
    self.navigationController.navigationBar.translucent = NO;
    /*
    [_navView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.height.mas_equalTo(64);
        make.right.equalTo(self.view).offset(0);
    }];*/
    
    
}



-(void)setSearchTF{
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.backgroundColor = LINE_BG;
    searchBar.barTintColor = LINE_BG;
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.showsCancelButton = YES;
    searchBar.frame = CGRectMake(0, 5, kScreenWidth, self.navigationController.navigationBar.frame.size.height-10);
    
    [self.navigationController.navigationBar addSubview:searchBar];
    /*
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.navView.mas_left).offset(0);
        make.right.equalTo(self.navView.mas_right).offset(0);
        make.top.equalTo(self.navView).offset(5);
        make.height.mas_equalTo(self.navView);
    }];*/
    _searchBar = searchBar;
    UITextField *searchField = nil;
    UIButton *cancelButton = nil;
    if (@available(iOS 13.0, *)) {
        searchField = searchBar.searchTextField;
        searchBar.backgroundColor = [UIColor whiteColor];
        cancelButton = [self findViewWithClassName:NSStringFromClass([UIButton class]) inView:searchBar];
        [searchField setValue:RGB_255(197,197,197) forKeyPath:@"placeholderLabel.textColor"];
    }else{
        searchField = [searchBar valueForKey:@"_searchField"];
        UIView *backgroundView = [searchBar valueForKey:@"_background"];
        backgroundView.backgroundColor = [UIColor whiteColor];
        cancelButton = [searchBar valueForKey:@"_cancelButton"];
        [searchField setValue:RGB_255(197,197,197) forKeyPath:@"_placeholderLabel.textColor"];
    }
    //UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    //UIView *backgroundView = [searchBar valueForKey:@"_background"];
    //UIButton *cancelButton = [searchBar valueForKey:@"_cancelButton"];
    //backgroundView.backgroundColor = [UIColor whiteColor];
    // 设置输入文字的大小及颜色
    searchField.font = [UIFont systemFontOfSize:12];
    searchField.textColor = RGB_255(32,32,32);
    
    // 设置占位文字的大小及颜色
    
    //searchField.placeholder = @"搜索";
    searchField.placeholder = @"搜索";
    searchField.layer.cornerRadius = 12.0f;
    searchField.layer.masksToBounds = YES;
    searchField.layer.borderWidth = 0.5f;
    searchField.layer.borderColor = RGBA_255(95,96,108,0.2).CGColor;
    [searchField becomeFirstResponder];
    _searchTF = searchField;
    
    
    // 设置searchField上的搜索图标
    cancelButton.enabled = YES;
    cancelButton.exclusiveTouch = YES;
    [cancelButton setTitle:@"取消"forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backClick:)
      forControlEvents:UIControlEventTouchUpInside];
    

}

- (UIView *)findViewWithClassName:(NSString *)className inView:(UIView *)view{
    Class specificView = NSClassFromString(className);
    if ([view isKindOfClass:specificView]) {
        return view;
    }
    
    if (view.subviews.count > 0) {
        for (UIView *subView in view.subviews) {
            UIView *targetView = [self findViewWithClassName:className inView:subView];
            if (targetView != nil) {
                return targetView;
            }
        }
    }
    
    return nil;
}

#pragma mark - **************** searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    NSLog(@"%@",searchBar.text);
    [searchBar resignFirstResponder];
    
    [self loadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchBar setText:searchText];

}

-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:^{
    //}];
}

-(void)searchClick:(id)sender{
    NSLog(@"search");
    [self loadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height);
}

-(void)loadData{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:SearchTVUrl];
    self.hudView.messageLabel.text = @"数据加载中...";
    [self.hudView showAtView:self.mainView hudType:JHUDLoadingTypeCircle];
    NSDictionary *params = @{@"name":self.searchTF.text};
    [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
        
        NSArray *temArray=[responseObject objectForKey:@"data"];
        
        NSLog(@"success%ld",[temArray count]);
        
        NSArray *arrayM = [ABFTelevisionInfo mj_objectArrayWithKeyValuesArray:temArray];
        self.dataArrays = [arrayM mutableCopy];
        
        [self.tableView reloadData];
        [self.hudView hide];
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        self.hudView.indicatorViewSize = CGSizeMake(100, 100);
        self.hudView.messageLabel.text = @"连接网络失败，请重新连接";
        [self.hudView.refreshButton setTitle:@"重新连接" forState:UIControlStateNormal];
        self.hudView.customImage = [UIImage imageNamed:@"bg_null"];
        [self.hudView showAtView:self.mainView hudType:JHUDLoadingTypeFailure];
        
    }];

}

- (void) addTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    [self.mainView addSubview:tableView];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArrays.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ABFTelevisionInfo *model = self.dataArrays[indexPath.row];
    
    ABFMineSimpleCell *cell = [[ABFMineSimpleCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:model.name];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    //return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];

    ABFPlayerViewController *vc = [[ABFPlayerViewController alloc] init];
    ABFTelevisionInfo *model = self.dataArrays[indexPath.row];
    vc.playUrl = model.url_1;
    vc.uid = model.id;
    vc.model = model;
    //[self.navigationController pushViewController:vc animated:YES];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
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
