//
//  ABFProvNaviViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/16.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFProvNaviViewController.h"
#import "MyLayout.h"
#import "AppDelegate.h"
#import "ABFRegionInfo.h"

@interface ABFProvNaviViewController ()

@property(nonatomic,weak) UIButton *closeBtn;

@property(nonatomic,weak) UILabel  *titleLab;

@end

@implementation ABFProvNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //[AppDelegate APP].allowRotation = false;
    //[self.view addSubview:self.closeBtn];
    [self setCloseBtn];
    [self setTitleLab];
    [self setProvNaviUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AppDelegate APP].allowRotation = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    [self.tabBarController.tabBar setHidden:YES];
    
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


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

-(void)setCloseBtn{
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor blackColor];
    [closeBtn addTarget:self action:@selector(closeClick:)
           forControlEvents:UIControlEventTouchUpInside];
    //[closeBtn setFont:[UIFont systemFontOfSize: 14.0]];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //closeBtn.frame = CGRectMake(10,10,24,24);
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    closeBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    closeBtn.alpha = 0.1;
    closeBtn.layer.masksToBounds = YES;
    closeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    closeBtn.layer.borderWidth = 1;
    closeBtn.layer.cornerRadius = 20;
    _closeBtn = closeBtn;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-20);
        // 这里宽高比16：9,可自定义宽高比
        make.height.width.mas_equalTo(40);
    }];

}

-(void)setProvNaviUI{

    NSInteger count = [self.dataArrays count];
    MyFloatLayout *mylayout  = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    mylayout.wrapContentHeight = YES;
    mylayout.myWidth = kScreenWidth;
    mylayout.myTop = 0;
    mylayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    mylayout.gravity = MyGravity_Horz_Fill;
    mylayout.subviewSpace = 10;
    
    
    for (int i=0 ; i<self.dataArrays.count ;i++){
        //vc.title = self.titleArrays[i][@"name"];
        ABFRegionInfo *model = self.dataArrays[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:model.name forState:UIControlStateNormal];
        btn.tintColor = [UIColor lightGrayColor];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.mySize = CGSizeMake((kScreenWidth-80)/4,25);
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改
        btn.layer.borderColor = RGB_255(204,204,204).CGColor;
        btn.layer.borderWidth = 1.0f;//设置边框颜色
        btn.tag = i;
        [btn addTarget:self action:@selector(selectClick:)
           forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [mylayout addSubview:btn];

    }
    CGFloat height = (count / 4 + 1)*(25+12) ;
    UIView *naviView = [[UIView alloc] init];
    naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviView];
    [naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(height);
    }];
    [naviView addSubview:mylayout];

}

-(void)setTitleLab{
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"各省份：";
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLab];
    _titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.left.equalTo(self.view).offset(20);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(100);
    }];

}

-(void)selectClick:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    NSString *strIndex = [NSString stringWithFormat:@"%ld",index];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //通过委托协议传值
        [self.delegate passValue:strIndex];
    }];

}

-(void)closeClick:(id)sender{
    NSLog(@"close");
    [self dismissViewControllerAnimated:YES completion:^{
        //通过委托协议传值
        //[self.delegate passValue:@"ululong"];
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
