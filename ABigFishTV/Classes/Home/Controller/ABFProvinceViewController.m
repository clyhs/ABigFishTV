//
//  ABFProvinceViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/14.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFProvinceViewController.h"
#import "ABFVideoListViewController.h"
#import "TitleLineLabel.h"
#import "ABFProvViewController.h"
#import "ABFProvNaviViewController.h"
#import "AppDelegate.h"
#import <PPNetworkHelper.h>
#import "ABFRegionInfo.h"
#import "JHUD.h"

static NSUInteger titleTabHeight = 40 ;

@interface ABFProvinceViewController ()<UIScrollViewDelegate,PassValueDelegate>

//ui
@property(weak,nonatomic)    UIScrollView *titleTabScrollView;
@property(weak,nonatomic)    UIScrollView *detailScrollView;
@property(weak,nonatomic)    UIView       *bgLineView;

@property(nonatomic,weak)    UIView       *addView;

@property(nonatomic,assign)  NSInteger currentIndex;

@property(weak,nonatomic)    ABFProvViewController *provListViewController;
//data
@property(nonatomic,strong)  NSArray    *titleArrays;

@property(nonatomic) JHUD    *hudView;

@property(nonatomic,assign)  BOOL flag;



@end

@implementation ABFProvinceViewController
/*
- (NSArray *)titleArrays{
    if (_titleArrays == nil) {
        _titleArrays = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"channels.plist" ofType:nil]];
    }
    return _titleArrays;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_255(250, 250, 250);
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    //调整的是UIScrollView显示内容的位置
    self.automaticallyAdjustsScrollViewInsets = NO;
    //[AppDelegate APP].allowRotation = false;
    _currentIndex = 0;
    [self loadData];
    
    [self setAddViewUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate APP].allowRotation = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [self addNavigationBarView];
    
}

- (void)addNavigationBarView{
    self.navigationController.navigationBar.backgroundColor = COMMON_COLOR;
    //self.navigationController.navigationBar.alpha = 0.8;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(backClick:)
      forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize: 14.0]];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0,60,20);
    [leftBtn setImage:[UIImage imageNamed:@"btn_nback"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(selectClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0,0,20,20);
    [rightBtn setImage:[UIImage imageNamed:@"icon_square"] forState:UIControlStateNormal];
    //[self.view addSubview:rightBtn];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)rightClick:(id)sender{
    NSLog(@"right");
    //_collectionView
    ABFProvViewController *vc = self.childViewControllers[self.currentIndex];
    
    UIButton *btn = sender;
    
    btn.selected = !btn.selected;
    self.flag = btn.selected;
    if(btn.selected){
        [vc changeCell:YES];
        
    }else{
        [vc changeCell:NO];
    }
    
}

-(void)loadData{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:RegionUrl];
    //self.hudView.messageLabel.text = @"数据加载中...";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    [PPNetworkHelper GET:fullUrl parameters:nil responseCache:^(id responseCache) {
        //加载缓存数据
    } success:^(id responseObject) {
        
        NSArray *temArray=[responseObject objectForKey:@"data"];
        
        NSLog(@"success%ld",[temArray count]);
        
        NSArray *arrayM = [ABFRegionInfo mj_objectArrayWithKeyValuesArray:temArray];
        self.titleArrays = [arrayM mutableCopy];
        
        [self addChildViewController];
        
        self.provListViewController = self.childViewControllers[0];
        
        [self initTitleTabScrollView];
        [self setFirstTitleTab];
        [self initDetailScrollView];
        
        [self.hudView hide];
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        self.hudView.indicatorViewSize = CGSizeMake(60, 60);
        self.hudView.messageLabel.text = @"连接网络失败，请重新连接";
        [self.hudView.refreshButton setTitle:@"重新连接" forState:UIControlStateNormal];
        [self.hudView.refreshButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        self.hudView.customImage = [UIImage imageNamed:@"nullData"];
        [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
        
    }];
    
}

-(void)refresh:(id)sender{
    [self loadData];
}

-(void)setAddViewUI{
    
}
-(void)passValue:(NSString *)value{
    NSLog(@"get backcall value=%@",value);
    
    NSString  *strIndex = value;
    NSInteger index = [strIndex intValue];
    CGFloat offsetX = index * self.detailScrollView.frame.size.width;
    
    CGFloat offsetY = self.detailScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.detailScrollView setContentOffset:offset animated:YES];
    [self setScrollToTopWithTableViewIndex:index];
    
    
}

-(void)selectClick:(id)sender{
    
    ABFProvNaviViewController *vc = [[ABFProvNaviViewController alloc] init];
    //把当前控制器作为背景
    self.definesPresentationContext = YES;
    vc.delegate = self;
    //vc.dataArrays = self.titleArrays;
    vc.dataArrays = [self.titleArrays mutableCopy];
    //设置模态视图弹出样式
    //vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:vc animated:YES completion:nil];

}

-(void)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加子控制器
- (void)addChildViewController{
    //懒加载时，不能用_titleArray.count
    for (int i=0 ; i<self.titleArrays.count ;i++){
        ABFProvViewController *vc = [[ABFProvViewController alloc] init];
        ABFRegionInfo *model = self.titleArrays[i];
        vc.title = model.name;
        vc.code = [NSString stringWithFormat:@"%ld",model.code];
        [self addChildViewController:vc];
    }
    
}

//**************init ui**********

- (void)initTitleTabScrollView{
    
    UIScrollView *titleTabScrollView = [[UIScrollView alloc] init];
    titleTabScrollView.backgroundColor = RGB_255(250, 250, 250);
    titleTabScrollView.bounces = YES;
    titleTabScrollView.alwaysBounceHorizontal = YES;
    //titleTabScrollView.scrollEnabled = YES;
    titleTabScrollView.scrollEnabled = YES;
    //titleTabScrollView.pagingEnabled = YES;
    
    CGFloat width = SCREEN_WIDTH;
    titleTabScrollView.contentSize = CGSizeMake(self.titleArrays.count*60, 0);
    titleTabScrollView.frame = CGRectMake(0, 0, width,titleTabHeight);
    
    _titleTabScrollView = titleTabScrollView;
    //不显示垂直滚动条
    _titleTabScrollView.showsHorizontalScrollIndicator = NO;
    //不显示水平滚动条
    _titleTabScrollView.showsVerticalScrollIndicator = NO;
    //关闭点击导航栏滚到顶部
    _titleTabScrollView.scrollsToTop = NO;
    for (int i = 0; i < self.titleArrays.count; i++) {
        CGFloat lblW = 60;
        CGFloat lblH = 40;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW;
        TitleLineLabel *tll = [[TitleLineLabel alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        //tll.text =_titleArrays[i][@"name"];
        tll.text = vc.title;
        tll.frame = CGRectMake(lblX, lblY, lblW, lblH);
        [self.titleTabScrollView addSubview:tll];
        tll.tag = i;
        //设置视图是否可以接收到用户的事件和消息
        tll.userInteractionEnabled = YES;
        [tll addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    [self.view addSubview:_titleTabScrollView];
}

- (void)setFirstTitleTab{
    TitleLineLabel *tll = [self.titleTabScrollView.subviews firstObject];
    tll.bottomLine.hidden = NO;
    tll.scale = 1.0;
}

- (void)initDetailScrollView{
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    UIScrollView *detailScrollView = [[UIScrollView alloc] init];
    detailScrollView.frame = CGRectMake(0, titleTabHeight, SCREEN_WIDTH, SCREEN_HEIGHT-titleTabHeight);
    detailScrollView.backgroundColor = [UIColor clearColor];
    detailScrollView.contentSize = CGSizeMake(contentX, 0);
    detailScrollView.pagingEnabled = YES;
    detailScrollView.showsHorizontalScrollIndicator = NO;
    self.detailScrollView = detailScrollView;
    self.detailScrollView.delegate = self;
    [self.view addSubview:detailScrollView];
    
    // 添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.detailScrollView.bounds;
    [self.detailScrollView addSubview:vc.view];
    
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    TitleLineLabel *labelLeft = self.titleTabScrollView.subviews[leftIndex];
    //labelLeft.backgroundColor = [UIColor yellowColor];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.titleTabScrollView.subviews.count) {
        TitleLineLabel *labelRight = self.titleTabScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.titleTabScrollView.frame.size.width;
    _currentIndex = index;
    
    TitleLineLabel *titleLabel = (TitleLineLabel *)self.titleTabScrollView.subviews[index];
    
    CGFloat offsetx = titleLabel.center.x - self.titleTabScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.titleTabScrollView.contentSize.width - self.titleTabScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        //offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.titleTabScrollView.contentOffset.y);
    [self.titleTabScrollView setContentOffset:offset animated:YES];
    
    ABFProvViewController *vc = self.childViewControllers[index];
    vc.index = index;
    
    [self.titleTabScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            TitleLineLabel *temlabel = self.titleTabScrollView.subviews[idx];
            temlabel.scale = 0.0;
            temlabel.bottomLine.hidden = YES;
        }else{
            TitleLineLabel *temlabel = self.titleTabScrollView.subviews[idx];
            temlabel.bottomLine.hidden = NO;
        }
    }];
    [self setScrollToTopWithTableViewIndex:index];
    
    if (vc.view.superview) return;
    
    vc.view.frame = scrollView.bounds;
    [self.detailScrollView addSubview:vc.view];
}

/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    TitleLineLabel *titlelable = (TitleLineLabel *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.detailScrollView.frame.size.width;
    CGFloat offsetY = self.detailScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.detailScrollView setContentOffset:offset animated:YES];
    
    [self setScrollToTopWithTableViewIndex:titlelable.tag];
}

#pragma mark - ScrollToTop

- (void)setScrollToTopWithTableViewIndex:(NSInteger)index
{
    
    self.provListViewController.collectionView.scrollsToTop = NO;
    self.provListViewController = self.childViewControllers[index];
    self.provListViewController.collectionView.scrollsToTop = YES;
    
    
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
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
