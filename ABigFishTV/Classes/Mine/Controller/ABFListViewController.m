//
//  ABFListViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/18.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFListViewController.h"
#import "ABFNavigationBarView.h"
#import "ABFTelevisionInfo.h"
#import "ABFUserInfo.h"
#import "JHUD.h"
#import "ABFHttpManager.h"
#import "ABFMJRefreshGifHeader.h"
#import "AppDelegate.h"
#import "ABFListCommonCell.h"
#import "ABFPlayerViewController.h"
#import "AppDelegate.h"
#import "ABFMJRefreshGifFooter.h"

@interface ABFListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *dataArrays;
@property(nonatomic,retain) NSMutableArray *deleteArrays;

@property (nonatomic) JHUD *hudView;

@property(nonatomic,assign) NSInteger curIndexPage;

@property(nonatomic,strong) ABFNavigationBarView *naviView;
@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic,strong) UIView *detailView;
@property(nonatomic,strong) UIView *mainView;



@end


@implementation ABFListViewController

-(NSMutableArray *)deleteArrays{
    if(!_deleteArrays){
        _deleteArrays = [NSMutableArray array];
    }
    return _deleteArrays;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //[AppDelegate APP].allowRotation = false;
    //self.automaticallyAdjustsScrollViewInsets = YES;
    //self.edgesForExtendedLayout = UIRectEdgeBottom;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _curIndexPage = 1;
    [self addDetailView];
    [self addTableView];
    self.hudView = [[JHUD alloc]initWithFrame:self.detailView.bounds];
    [self addRefreshHeader];
    [self addRefreshFooter];
    [self loadRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏
    [AppDelegate APP].allowRotation = false;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self addNavigationBarView];
    
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

-(void) addDetailView{
    _detailView = [[UIView alloc] init];
    _detailView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -64);
    [self.view addSubview:_detailView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    //self.mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    _detailView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -64);
    _tableView.frame = _detailView.bounds;
}


- (void)addNavigationBarView{
    if(self.index == 102){
        self.title = @"收藏";
    }else if(self.index == 103){
        self.title = @"历史";
    }
    
    self.navigationController.navigationBar.barTintColor = COMMON_COLOR;
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
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(deleteClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0,0,20,20);
    //rightBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [rightBtn setImage:[UIImage imageNamed:@"icon_square"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateSelected];
    UIBarButtonItem *rBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _rightBtn =rightBtn;
    self.navigationItem.rightBarButtonItem = rBtnItem;
    
}


-(void)deleteClick:(id)sender{
    NSLog(@"delete");
    //self.tableView.editing = !self.tableView.editing;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if(self.tableView.editing){
        //[self.rightBtn setImage:[UIImage imageNamed:@"icon_lightdelete"] forState:UIControlStateNormal];
        self.rightBtn.selected = true;
        
    }else{
        //[self.rightBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        self.rightBtn.selected = false;
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        
        if(self.dataArrays.count>0 && self.deleteArrays.count>0){
            NSLog(@"dedatacount%ld",self.deleteArrays.count);
            for(ABFTelevisionInfo *tv in self.deleteArrays){
                [self.dataArrays removeObject:tv];
            }
            //[self.dataArrays removeObjectsInArray:self.deleteArrays];
            
            NSLog(@"datacount%ld",self.dataArrays.count);
        }
        
        NSString *ids = @"";
        for(ABFTelevisionInfo *tv in self.deleteArrays){
            NSLog(@"id=%ld",tv.id);
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%ld,",tv.id]];
        }
        if(ids.length>0){
            ids = [ids substringToIndex:ids.length-1];
            NSLog(@"ids=%@",ids);
            [self deleteAction:ids];
        }
    }
}
-(void)deleteAction:(NSString *)ids{
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVDelRecordUrl];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([AppDelegate APP].user){
        
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"userId"];
        [params setValue:ids forKey:@"ids"];
        if(self.index == 103){
            [params setObject:[NSString stringWithFormat:@"15"] forKey:@"typeId"];
        }else{
            [params setObject:[NSString stringWithFormat:@"14"] forKey:@"typeId"];
        }
        
        NSLog(@"url=%@",fullUrl);
        [[ABFHttpManager manager]POST:fullUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(self.index == 102){
                [AppDelegate APP].user.likenum =[AppDelegate APP].user.likenum - self.deleteArrays.count;
            }else if(self.index == 103){
                [AppDelegate APP].user.history =[AppDelegate APP].user.history - self.deleteArrays.count;
            }
            [self.tableView reloadData];
            NSLog(@"success");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error%@",error);
            
        }];
    }

}

- (void)setuiMainView{
    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor yellowColor];
    _mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:_mainView];
}

- (void)addTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.editing = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.detailView addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[ABFListCommonCell class] forCellReuseIdentifier:@"mycell"];
    _tableView = tableView;
    
    
}

- (void) loadRefresh{
    _curIndexPage = 1;
    NSString *fullUrl = [BaseUrl stringByAppendingString:TVRecordUrl];
    if([AppDelegate APP].user){
        NSString *userId = [NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id];
        fullUrl = [fullUrl stringByAppendingString:userId];
        
        if(self.index == 102){
            fullUrl = [fullUrl stringByAppendingString:@"/14"];
        }else if(self.index == 103){
            fullUrl = [fullUrl stringByAppendingString:@"/15"];
        }
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
        
        if(self.index == 102){
            fullUrl = [fullUrl stringByAppendingString:@"/14"];
        }else if(self.index == 103){
            fullUrl = [fullUrl stringByAppendingString:@"/15"];
        }
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
        NSLog(@"url=%@",fullUrl);
        [self loadData:fullUrl type:2];
    }
    
    
}

- (void) loadData:(NSString *)url type:(NSInteger)type{
    
    NSLog(@"url=%@",url);
    if(type == 1){
        self.hudView.messageLabel.text = @"数据加载中...";
        [self.hudView showAtView:self.detailView hudType:JHUDLoadingTypeCircle];
    }
    [[ABFHttpManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *temArray=[responseObject objectForKey:@"data"];
        NSLog(@"success%ld",[temArray count]);
        NSArray *arrayM = [ABFTelevisionInfo mj_objectArrayWithKeyValuesArray:temArray];
        
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
            [self.hudView showAtView:self.detailView hudType:JHUDLoadingTypeFailure];
        }
        if(type == 2){
            [self.tableView.mj_footer endRefreshing];
        }
        
    }];
    
}


-(void)refresh:(id)sender{
    [self loadRefresh];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArrays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ABFListCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];


    ABFTelevisionInfo *model = self.dataArrays[indexPath.row];
    [cell setModel:model];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.tableView.editing){
        NSLog(@"table delete");
        //[self.deleteArrays arrayByAddingObject:self.dataArrays[indexPath.row]];
        //[self.deleteArrays addObjectsFromArray:[self.dataArrays[indexPath.row]]];
        //[self.deleteArrays addObject:self.dataArrays[indexPath.row]];
        //[self.d]
        //[self.deleteArrays add]
        ABFTelevisionInfo *model = self.dataArrays[indexPath.row];
        //[self.deleteArrays addObject:model];
        [self.deleteArrays addObject:model];
        NSLog(@"count=%ld",self.deleteArrays.count);
        
    }else{
        ABFPlayerViewController *vc = [[ABFPlayerViewController alloc] init];
        ABFTelevisionInfo *model = self.dataArrays[indexPath.row];
        vc.playUrl = model.url_1;
        vc.uid = model.id;
        vc.tvTitle = model.name;
        vc.model = model;
        //vc.hidesBottomBarWhenPushed = YES;
        //[self.navigationController pushViewController:vc animated:YES];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.tableView.editing){
        ABFTelevisionInfo *model = self.dataArrays[indexPath.row];
        [self.deleteArrays removeObject:model];
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataArrays removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
    [tableView setEditing:NO animated:YES];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}



-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
