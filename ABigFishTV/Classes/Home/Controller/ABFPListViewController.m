//
//  ABFPListViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/4.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFPListViewController.h"
#import "ABFCommentViewCell.h"
#import "AppDelegate.h"
#import "ABFCommentInfo.h"
#import <PPNetworkHelper.h>
#import "ABFCommentView.h"
#import "ABFCommentTFView.h"
#import "ABFProgramInfo.h"
#import "ABFProgramViewCell.h"
#import "JHUD.h"
#import "ABFMJRefreshGifHeader.h"
#import "ABFMJRefreshGifFooter.h"
#import "ABFProgramModel.h"

@interface ABFPListViewController ()<UITableViewDelegate,UITableViewDataSource,ABFCommentDelegate,ABFCommentTFDelegate,ABFCommentViewCellDelegate>



@property(nonatomic,assign) NSInteger      commentType;
@property(nonatomic,strong) ABFCommentInfo *currentModel;
@property(nonatomic,assign) NSInteger      replyIndex;

@property(nonatomic,strong) UIView         *bgView;
@property(nonatomic,strong) UIImageView    *bgImageView;
@property (nonatomic)       JHUD *hudView;
@property(nonatomic,assign) NSInteger curIndexPage;

@end

@implementation ABFPListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSMutableArray new];
    _curIndexPage = 1;
    [self addTableView];
    [self addBgView];
    [self loadDataFirst];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addBgView{
    
    CGFloat height = kScreenHeight -( kScreenWidth*9/16+20 );
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    NSLog(@"height=%f",self.height);
    _bgView.frame = CGRectMake(0, 0, kScreenWidth, height);
    [self.view addSubview:_bgView];
    self.hudView = [[JHUD alloc]initWithFrame:_bgView.bounds];
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"bg_null"];
    _bgImageView.frame = CGRectMake(kScreenWidth/2 - 50, height/2 -90, 100, 100);
    [self.bgView addSubview:_bgImageView];
    _bgView.alpha = 0;
}

- (void) addTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = LINE_BG;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //[self.view addSubview:tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView = tableView;
    [self.tableView registerClass:[ABFProgramViewCell class] forCellReuseIdentifier:@"programCell"];
    
}

- (void)addRefreshHeader
{
    ABFMJRefreshGifHeader *header = [ABFMJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefresh)];
    self.tableView.mj_header = header;
}

- (void)addRefreshFooter{
    if([self.typeId isEqualToString:@"11"]){
        ABFMJRefreshGifFooter *footer = [ABFMJRefreshGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataMore)];
        self.tableView.mj_footer = footer;
    }
    
}

- (void) loadRefresh{
    _curIndexPage = 1;
    if([self.typeId isEqualToString:@"11"]){
        NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentUrl];
        fullUrl = [fullUrl stringByAppendingFormat:@"11/%ld",self.uid];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
        [self loaddata:fullUrl type:1];
    }else if([self.typeId isEqualToString:@"12"]){
        
        //NSString *fullUrl = [BaseUrl stringByAppendingString:TVProgramUrl];
        NSString *fullUrl = @"https://m.tvsou.com/api/ajaxGetPlay";
        //fullUrl = [fullUrl stringByAppendingFormat:@"/%ld",self.uid];
        //NSDate *senddate=[NSDate date];
        //NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        //[dateformatter setDateFormat:@"YYYYMMdd"];
        //NSString *locationString=[dateformatter stringFromDate:senddate];
        //NSLog(@"%@",locationString);
        //fullUrl = [fullUrl stringByAppendingFormat:@"/%@",locationString];
        [self loaddata:fullUrl type:1];
    }
    
}

- (void) loadDataMore{
    _curIndexPage++;
    if([self.typeId isEqualToString:@"11"]){
        NSString *fullUrl = [BaseUrl stringByAppendingString:TVCommentUrl];
        fullUrl = [fullUrl stringByAppendingFormat:@"11/%ld",self.uid];
        fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"/%ld",_curIndexPage]];
        [self loaddata:fullUrl type:2];
    }
}

-(void) loadDataFirst{
    self.hudView.messageLabel.text = @"数据加载中...";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    [self loadRefresh];
}

-(void)loaddata:(NSString *)url type:(NSInteger)type{
    
    if([self.typeId isEqualToString:@"11"]){
        [PPNetworkHelper GET:url parameters:nil responseCache:^(id responseCache) {
            //加载缓存数据
        } success:^(id responseObject) {
            NSArray *temArray=[responseObject objectForKey:@"data"];
            //NSLog(@"11 ...success%ld",[temArray count]);
            if([temArray count]>0){
                [self addRefreshFooter];
            }
            NSArray *arrayM = [ABFCommentInfo mj_objectArrayWithKeyValuesArray:temArray];
            if(type == 1){
                self.data = [arrayM mutableCopy];
                if([self.data count] == 0){
                        _bgView.alpha = 1;
                }else{
                    _bgView.alpha = 0;
                    [self.tableView reloadData];
                }
                [self.tableView.mj_header endRefreshing];
                
            }else if(type == 2){
                self.data = [[self.data arrayByAddingObjectsFromArray:arrayM] mutableCopy];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                self.tableView.mj_footer.hidden = YES;
            
            }
            [self.hudView hide];
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
                self.tableView.mj_footer.hidden = YES;
            }
            
        }];
        //[self.tableView reloadData];
    }else if([self.typeId isEqualToString:@"12"]){
        NSMutableDictionary *params = [NSMutableDictionary new];
        NSDate *senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYYMMdd"];
        NSString *locationString=[dateformatter stringFromDate:senddate];
        if( ![self.channelid isEqualToString:@""] && self.channelid!=nil) {
            NSLog(@"channelid is not null");
            [params setObject:self.channelid forKey:@"channelid"];
            [params setObject:locationString forKey:@"date"];
            [PPNetworkHelper POST:url parameters:params responseCache:^(id responseCache) {
                //加载缓存数据
            } success:^(id responseObject) {
                NSArray *temArray=[responseObject objectForKey:@"list"];
                NSLog(@"12 ... success%ld",[temArray count]);
                NSArray *arrayM = [ABFProgramModel mj_objectArrayWithKeyValuesArray:temArray];
                self.data = [arrayM mutableCopy];
                if(self.data.count == 0){
                    _bgView.alpha = 1;
                }else{
                    _bgView.alpha = 0;
                    [self.tableView reloadData];
                }
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = YES;
                [self.hudView hide];
            } failure:^( NSError *error) {
                NSLog(@"error%@",error);
                [self.tableView.mj_header endRefreshing];
                self.hudView.indicatorViewSize = CGSizeMake(100, 100);
                self.hudView.messageLabel.text = @"连接网络失败，请重新连接";
                [self.hudView.refreshButton setTitle:@"重新连接" forState:UIControlStateNormal];
                [self.hudView.refreshButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
                self.hudView.customImage = [UIImage imageNamed:@"bg_null"];
                [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
            }];
        }else{
            NSLog(@"channelid is null");
            _bgView.alpha = 1;
            [self.hudView hide];
        }
        
        
        
        
    }
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
    
    if([self.typeId isEqualToString:@"11"]){
        ABFCommentInfo *model = self.data[indexPath.row];
        
        ABFCommentViewCell *cell = [[ABFCommentViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [cell setModel:model];
        cell.delegate = self;
        return cell;
    }else if([self.typeId isEqualToString:@"12"]){
        //ABFProgramInfo *model = self.data[indexPath.row];
        ABFProgramModel *model = self.data[indexPath.row];
        ABFProgramViewCell *cell = (ABFProgramViewCell *)[tableView dequeueReusableCellWithIdentifier:@"programCell" forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }
    
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = LINE_BG;
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.typeId isEqualToString:@"11"]){
        ABFCommentInfo *model = self.data[indexPath.row];
        return 50+model.contextHeight+model.replyHeight+25+30;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(void)pushForButton:(ABFCommentInfo *)model index:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(pushlistForButton:index:)]) {
        [self.delegate pushlistForButton:model index:tag];
    }
}

-(void)pushForReplyButton:(ABFCommentInfo *)model index:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(pushlistForReplyButton:index:)]) {
        [self.delegate pushlistForReplyButton:model index:tag];
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
