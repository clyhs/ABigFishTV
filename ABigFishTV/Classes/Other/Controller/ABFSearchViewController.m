//
//  ABFSearchViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/15.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFSearchViewController.h"
#import "ABFHttpManager.h"
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


@end

@implementation ABFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //[AppDelegate APP].allowRotation = false;
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
    //隐藏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    if(self.searchKey){
        self.searchTF.text = self.searchKey;
        [self loadData];
    }
    
    
    
}

-(void)setNaviUI{
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = LINE_BG;
    [self.view addSubview:navView];
    _navView = navView;
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.height.mas_equalTo(64);
        make.right.equalTo(self.view).offset(0);
    }];
    /*
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(backClick:)
      forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(11, 0, 9, 14);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //leftBtn.frame = CGRectMake(0,0,60,20);
    [leftBtn setImage:[UIImage imageNamed:@"icon_grayback"] forState:UIControlStateNormal];
    
    [self.navView addSubview:leftBtn];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.navView).offset(10);
        make.top.equalTo(self.navView).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];*/
    /*
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[rightBtn addTarget:self action:@selector(reachClick:)
      //forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 10, 5);
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    //[rightBtn setFont:[UIFont systemFontOfSize: 18.0]];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize: 18.0]];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //leftBtn.frame = CGRectMake(0,0,60,20);
    //[leftBtn setImage:[UIImage imageNamed:@"icon_grayback"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:rightBtn];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.navView).offset(-10);
        make.top.equalTo(self.navView).offset(22);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(55);
    }];*/

    
    //UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    //self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}



-(void)setSearchTF{
    /*
    UITextField *searchTF = [[UITextField alloc] init];
    [searchTF setBackgroundColor:[UIColor whiteColor]];
    //searchTF.intrinsicContentSize
    //searchTF.frame = CGRectMake(20, 20, 400, 30);
    [searchTF setTextColor:[UIColor darkGrayColor]];
    [searchTF setClearButtonMode:UITextFieldViewModeWhileEditing]; //编辑时会出现个修改X
    [searchTF setTag:101];
    //[usernameTF setReturnKeyType:UIReturnKeyNext]; //键盘下一步Next
    [searchTF setAutocapitalizationType:UITextAutocapitalizationTypeNone]; //关闭首字母大写
    [searchTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    //[usernameTF becomeFirstResponder]; //默认打开键盘
    [searchTF setFont:[UIFont systemFontOfSize:14]];
    [searchTF setDelegate:self];
    [searchTF setPlaceholder:@" 请输入电视台，视频等"];
    //[searchTF setText:@"admin"];
    [searchTF setHighlighted:YES];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    searchTF.leftView = view;
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    
    searchTF.layer.masksToBounds = YES;
    searchTF.layer.cornerRadius = 4;
    searchTF.layer.borderColor = LINE_BG.CGColor;
    searchTF.layer.borderWidth = 1;
    
    [self.navView addSubview:searchTF];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.navView.mas_left).offset(48);
        make.top.equalTo(self.navView).offset(27);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(200);
    }];
    _searchTF = searchTF;*/
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.backgroundColor = LINE_BG;
    searchBar.barTintColor = LINE_BG;
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.showsCancelButton = YES;
    
    [self.navView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.navView.mas_left).offset(0);
        make.right.equalTo(self.navView.mas_right).offset(0);
        make.top.equalTo(self.navView).offset(5);
        make.height.mas_equalTo(self.navView);
    }];
    _searchBar = searchBar;
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    UIView *backgroundView = [searchBar valueForKey:@"_background"];
    UIButton *cancelButton = [searchBar valueForKey:@"_cancelButton"];
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    // 设置输入文字的大小及颜色
    searchField.font = [UIFont systemFontOfSize:12];
    searchField.textColor = RGB_255(32,32,32);
    
    // 设置占位文字的大小及颜色
    [searchField setValue:RGB_255(197,197,197) forKeyPath:@"_placeholderLabel.textColor"];
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
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
}

-(void)loadData{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:SearchTVUrl];
    self.hudView.messageLabel.text = @"数据加载中...";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    NSDictionary *params = @{@"name":self.searchTF.text};
    [[ABFHttpManager manager]POST:fullUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *temArray=[responseObject objectForKey:@"data"];
        
        NSLog(@"success%ld",[temArray count]);
        
        NSArray *arrayM = [ABFTelevisionInfo mj_objectArrayWithKeyValuesArray:temArray];
        self.dataArrays = [arrayM mutableCopy];
        
        [self.tableView reloadData];
        [self.hudView hide];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error%@",error);
        self.hudView.indicatorViewSize = CGSizeMake(100, 100);
        self.hudView.messageLabel.text = @"连接网络失败，请重新连接";
        [self.hudView.refreshButton setTitle:@"重新连接" forState:UIControlStateNormal];
        self.hudView.customImage = [UIImage imageNamed:@"bg_null"];
        [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
        
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
    [self.view addSubview:tableView];
    
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
