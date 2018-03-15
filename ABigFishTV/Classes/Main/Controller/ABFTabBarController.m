//
//  ABFTabBarController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFTabBarController.h"
#import "ABFHomeViewController.h"
#import "ABFVideoViewController.h"
#import "ABFOtherViewController.h"
#import "ABFMineViewController.h"
#import "ABFNavigationController.h"

@interface ABFTabBarController ()

@end

@implementation ABFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initChildController];
    
    [self initTabBar];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)initChildController{

    ABFHomeViewController *hvc = [[ABFHomeViewController alloc] init];
    
    [self addChildController:hvc title:@"首页" imageName:@"tab_home" selectedImageName:@"tab_home_highlight" navVc:[ABFNavigationController class]];
    
    ABFVideoViewController *vvc = [[ABFVideoViewController alloc] init];
    [self addChildController:vvc title:@"视频" imageName:@"tab_video" selectedImageName:@"tab_video_highlight" navVc:[ABFNavigationController class]];
    
    ABFOtherViewController *ovc = [[ABFOtherViewController alloc] init];
    [self addChildController:ovc title:@"发现" imageName:@"tab_other" selectedImageName:@"tab_other_highlight" navVc:[ABFNavigationController class]];
    
    ABFMineViewController *mvc = [[ABFMineViewController alloc] init];
    [self addChildController:mvc title:@"我" imageName:@"tab_mine" selectedImageName:@"tab_mine_highlight" navVc:[ABFNavigationController class]];
}

- (void)addChildController:(UIViewController*) childController title:(NSString*) title imageName:(NSString*) imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc{
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置一下选中tabbar文字颜色
    
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : COMMON_COLOR }forState:UIControlStateSelected];
    ABFNavigationController *nav = [[navVc alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];


}

- (UIImage *)imageWithColor:(UIColor *)color{
    // 一个像素
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) initTabBar{
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:RGB_255(250, 250, 250)]];
    //  设置tabbar
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [self setBarLineView];
}
/*因为​Autolayout只能对uiview和它的子类起作用。UIBarButtonItem不继承自UIView*/
- (void) setBarLineView{
    UIView *lineView = [[UIView alloc] init];
    
    lineView.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
    
    lineView.backgroundColor = LINE_BG;
    [self.tabBar addSubview:lineView];
    
    /*
    [lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.tabBar).offset(0);
        make.right.equalTo(self.tabBar).offset(0);
        make.top.equalTo(self.tabBar).offset(0);
        make.height.equalTo(@1);
    }];*/
    
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
