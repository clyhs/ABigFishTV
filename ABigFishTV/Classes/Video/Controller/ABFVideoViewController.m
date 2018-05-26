//
//  ABFVideoViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFVideoViewController.h"
#import "ABFVideoListViewController.h"
#import "TitleLineLabel.h"
#import "AppDelegate.h"
#import "ABFChatController.h"
static NSUInteger titleTabHeight = 64 ;

@interface ABFVideoViewController ()<UIScrollViewDelegate>

//ui
@property(weak,nonatomic) UIView       *topView;
@property(weak,nonatomic) UIScrollView *titleTabScrollView;
@property(weak,nonatomic) UIScrollView *detailScrollView;
@property(weak,nonatomic) UIView       *bgLineView;
@property(nonatomic,strong) UIView     *mainView;
@property(weak,nonatomic) UIButton     *addBtn;

@property(weak,nonatomic) ABFVideoListViewController *videoListViewController;

@property(strong,nonatomic) NSMutableArray *titleLabArray;

//data
@property(nonatomic,strong) NSArray    *titleArrays;

@end

@implementation ABFVideoViewController

- (NSArray *)titleArrays{
    if (_titleArrays == nil) {
        _titleArrays = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"menus.plist" ofType:nil]];
    }
    return _titleArrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //self.edgesForExtendedLayout = UIRectEdgeBottom;
    //调整的是UIScrollView显示内容的位置
    self.automaticallyAdjustsScrollViewInsets = NO;
    //[AppDelegate APP].allowRotation = false;
    _titleLabArray = [NSMutableArray new];
    [self setuiMainView];
    [self addChildViewController];
    
    self.videoListViewController = self.childViewControllers[0];
    //[self setTopView];
    [self initTitleTabScrollView];
    
    [self setFirstTitleTab];
    [self initDetailScrollView];
    [self addBtnUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate APP].allowRotation = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //_navView = self.navigationController.navigationBar.v;
    self.navigationController.navigationBar.translucent = NO;
    [self setStatusBarBackgroundColor:RGB_255(250, 250, 250)];
    _titleTabScrollView.hidden=NO;
    _titleTabScrollView.alpha = 1;
    _addBtn.hidden=NO;
    _addBtn.alpha = 1;
}

-(void)viewWillDisappear:(BOOL)animated{
    _titleTabScrollView.hidden=YES;
    _titleTabScrollView.alpha = 0;
    _addBtn.hidden=YES;
    _addBtn.alpha = 0;
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}


- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0,0, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height);
    //_topView.frame = CGRectMake(kScreenWidth/4, 0, kScreenWidth/2, self.navigationController.navigationBar.frame.size.height);
    _titleTabScrollView.frame = CGRectMake(0, 0, kScreenWidth,self.navigationController.navigationBar.frame.size.height);
    CGFloat h = self.navigationController.navigationBar.frame.size.height - 40;
    for (int i = 0; i < self.titleArrays.count; i++) {
    
        CGFloat lblW = (SCREEN_WIDTH)/ 4;
        CGFloat lblH = 40;
        CGFloat lblY = h;
        CGFloat lblX = (i+1) * lblW;
        TitleLineLabel *labelLeft = self.titleTabScrollView.subviews[i];
        labelLeft.frame = CGRectMake(lblX, lblY, lblW, lblH);
    }
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    _detailScrollView.frame = CGRectMake(0, statusBar.frame.size.height, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height);
    _addBtn.frame = CGRectMake(kScreenWidth-40,5,40,40);
    
}

- (void)setuiMainView{
    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:_mainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBtnUI{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //rightBtn.frame = CGRectMake(kScreenWidth-40,22,40,40);
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(7, 11, 15, 11);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setImage:[UIImage imageNamed:@"icon_grayadd"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar insertSubview:rightBtn atIndex:99  ];
    _addBtn = rightBtn;
    
}



-(void)addClick:(id)sender{
    NSLog(@"add");
    ABFChatController *vc = [[ABFChatController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//添加子控制器
- (void)addChildViewController{
    //懒加载时，不能用_titleArray.count
    for (int i=0 ; i<self.titleArrays.count ;i++){
        ABFVideoListViewController *vc = [[ABFVideoListViewController alloc] init];
        vc.title = self.titleArrays[i][@"name"];
        NSNumber *typeId =self.titleArrays[i][@"typeId"] ;
        vc.typeId = [NSString stringWithFormat:@"%@",typeId];
        NSLog(@"typeId=%@",typeId);
        [self addChildViewController:vc];
    }
    
}

//**************init ui**********

-(void)setTopView{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:topView];
    _topView = topView;
}

- (void)initTitleTabScrollView{
    
    UIScrollView *titleTabScrollView = [[UIScrollView alloc] init];
    titleTabScrollView.backgroundColor = RGB_255(250, 250, 250);
    
    CGFloat width = SCREEN_WIDTH;
    titleTabScrollView.contentSize = CGSizeMake(width, 0);
    
    _titleTabScrollView = titleTabScrollView;
    //不显示垂直滚动条
    _titleTabScrollView.showsHorizontalScrollIndicator = NO;
    //不显示水平滚动条
    _titleTabScrollView.showsVerticalScrollIndicator = NO;
    //关闭点击导航栏滚到顶部
    _titleTabScrollView.scrollsToTop = NO;
    
    for (int i = 0; i < self.titleArrays.count; i++) {
        //CGFloat lblW = (SCREEN_WIDTH)/ 4;
        //CGFloat lblH = 40;
        //CGFloat lblY = 18;
        //CGFloat lblX = (i+1) * lblW;
        TitleLineLabel *tll = [[TitleLineLabel alloc]init];
        tll.font = [UIFont systemFontOfSize:18];
        UIViewController *vc = self.childViewControllers[i];
        //tll.text =_titleArrays[i][@"name"];
        tll.text = vc.title;
        //tll.frame = CGRectMake(lblX, lblY, lblW, lblH);
        [self.titleTabScrollView addSubview:tll];
        tll.tag = i;
        //设置视图是否可以接收到用户的事件和消息
        tll.userInteractionEnabled = YES;
        //[_titleLabArray addObject:tll];
    }
    [self.navigationController.navigationBar addSubview:_titleTabScrollView];
}

- (void)setFirstTitleTab{
    TitleLineLabel *tll = [self.titleTabScrollView.subviews firstObject];
    tll.bottomLine.hidden = NO;
    tll.scale = 1.0;
}

- (void)initDetailScrollView{
    
    
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    UIScrollView *detailScrollView = [[UIScrollView alloc] init];
    
    detailScrollView.backgroundColor = [UIColor clearColor];
    detailScrollView.contentSize = CGSizeMake(contentX, 0);
    detailScrollView.pagingEnabled = YES;
    detailScrollView.showsHorizontalScrollIndicator = NO;
    self.detailScrollView = detailScrollView;
    self.detailScrollView.delegate = self;
    [self.mainView addSubview:detailScrollView];
    
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
    
    TitleLineLabel *titleLabel = (TitleLineLabel *)self.titleTabScrollView.subviews[index];
    
    CGFloat offsetx = titleLabel.center.x - self.titleTabScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.titleTabScrollView.contentSize.width - self.titleTabScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.titleTabScrollView.contentOffset.y);
    [self.titleTabScrollView setContentOffset:offset animated:YES];
    
    ABFVideoListViewController *vc = self.childViewControllers[index];
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

#pragma mark - ScrollToTop

- (void)setScrollToTopWithTableViewIndex:(NSInteger)index
{
    //self.newsViewController.tableView.scrollsToTop = NO;
    self.videoListViewController = self.childViewControllers[index];
    //self.newsViewController.tableView.scrollsToTop = YES;
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
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
