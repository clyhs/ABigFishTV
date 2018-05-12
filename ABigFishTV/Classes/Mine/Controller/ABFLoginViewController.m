//
//  ABFLoginViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/9.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFLoginViewController.h"
#import "ABFNavigationBarView.h"
#import "MBProgressHUD.h"

#import <PPNetworkHelper.h>
#import <ShareSDK/ShareSDK.h>
#import "ABFUserInfo.h"
#import "AppDelegate.h"

@interface ABFLoginViewController ()<UITextFieldDelegate>

@property(nonatomic,weak) ABFNavigationBarView *nav;

@property(nonatomic,weak) UIView *baseView;
@property(nonatomic,weak) UIView *bg;
@property(nonatomic,weak) UIButton *loginBtn;
@property(nonatomic,weak) UIImageView *usernameIcon;
@property(nonatomic,weak) UIImageView *passwordIcon;
@property(nonatomic,weak) UIButton    *eyeIcon;
@property(nonatomic,weak) UITextField *usernameTF;
@property(nonatomic,weak) UITextField *passwordTF;

@property(nonatomic,weak) UIImageView *logo;
@property(nonatomic,strong) UIImageView *wcIV;
@property(nonatomic,strong) UIImageView *qqIV;
@property(nonatomic,strong) UIImageView *sinaIV;

@property(nonatomic,strong) UIView    *otherLoginView;

@property(nonatomic,strong) UILabel   *otherLab;
@property(nonatomic,strong) UIView    *leftLine;
@property(nonatomic,strong) UIView    *rightLine;

@end

@implementation ABFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self setBgImageUI];
    [self setLogoUI];
    [self setBaseViewUI];
    [self setUsernameAndPasswordUI];
    [self setLoginBtnUI];
    [self setOtherLoginViewUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    //self.navigationController.navigationBar.backgroundColor = LINE_BG;
    [AppDelegate APP].allowRotation = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.tabBarController.tabBar setHidden:YES];
    [self setNaviUI];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

-(void)setNaviUI{
    
    self.navigationItem.title =@"登录";
    //self.navigationController.navigationBar.barTintColor =[UIColor blackColor];
    //self.navigationController.navigationBar.alpha = 0.8;
    self.navigationController.navigationBar.barTintColor = COMMON_COLOR;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(backClick:)
     forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //[leftBtn setTitle:@"" forState:UIControlStateNormal];
    //[leftBtn setFont:[UIFont systemFontOfSize: 14.0]];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize: 14]];
    [leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(20,20,40,20);
    
    [leftBtn setImage:[UIImage imageNamed:@"btn_nback"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn ];
    //UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    //self.navigationItem.leftBarButtonItem = leftBtnItem;

}

-(void)setBgImageUI{
    UIImageView *bg = [[UIImageView alloc] init];
    bg.frame = self.view.bounds;
    //bg.backgroundColor = [UIColor blackColor];
    //bg.alpha = 0.7;
    [bg setImage:[UIImage imageNamed:@"loginbg_3"]];
    //bg.backgroundColor = RGB_255(135, 206, 250);
    bg.alpha = 0.9;
    [self.view addSubview:bg];
    //_bg = bg;
}

-(void)setLogoUI{
    
    UIImageView *logoView = [[UIImageView alloc] init];
    [logoView setImage:[UIImage imageNamed:@"profile"]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.layer.masksToBounds = YES;
    logoView.layer.cornerRadius = 50;
    logoView.layer.borderWidth = 2;
    //logo.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    logoView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:logoView];
    _logo = logoView;
    [logoView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-150);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];

}

-(void)setBaseViewUI{
    __weak typeof (self) weakSelf = self;
    
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.masksToBounds = YES;
    baseView.layer.cornerRadius = 6;
    baseView.layer.borderWidth = 0.0;
    baseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //baseView.layer.borderColor = RGB_255(175, 238, 238).CGColor;

    
    [self.view addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-50);
        make.size.mas_equalTo(CGSizeMake(260, 80));
    }];
    _baseView = baseView;
    
    UIView *lineBg = [[UIView alloc] init];
    lineBg.backgroundColor = LINE_BG;
    [self.baseView addSubview:lineBg];
    [lineBg mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.baseView);
        make.left.equalTo(self.baseView.mas_left).offset(4);
        make.right.equalTo(self.baseView.mas_right).offset(-4);
        make.height.mas_equalTo(0.5);
    }];
    
}

-(void) setUsernameAndPasswordUI{
    
    UIImageView *usernameIcon = [[UIImageView alloc] init];
    [usernameIcon setImage:[UIImage imageNamed:@"username"]];
   
    [self.baseView addSubview:usernameIcon];
    _usernameIcon = usernameIcon;
    //usernameIcon.backgroundColor = [UIColor yellowColor];
    
    UITextField *usernameTF = [[UITextField alloc] init];
    [usernameTF setBackgroundColor:[UIColor clearColor]];
    [usernameTF setTextColor:[UIColor grayColor]];
    [usernameTF setClearButtonMode:UITextFieldViewModeWhileEditing]; //编辑时会出现个修改X
    [usernameTF setTag:101];
    //[usernameTF setReturnKeyType:UIReturnKeyNext]; //键盘下一步Next
    [usernameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone]; //关闭首字母大写
    [usernameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    //[usernameTF becomeFirstResponder]; //默认打开键盘
    [usernameTF setFont:[UIFont systemFontOfSize:14]];
    [usernameTF setDelegate:self];
    [usernameTF setPlaceholder:@"用户名或电子邮箱"];
    [usernameTF setText:@"test123"];
    [usernameTF setHighlighted:YES];
    [self.baseView addSubview:usernameTF];
    _usernameTF = usernameTF;

    [usernameIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.baseView).offset(5);
        make.top.equalTo(self.baseView).offset(8);
        make.height.mas_equalTo(24);
        make.width.mas_offset(24);
    }];
    
    [usernameTF mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.usernameIcon.mas_right).offset(5);
        make.top.equalTo(self.baseView).offset(6);
        make.height.mas_equalTo(28);
        make.right.equalTo(self.baseView.mas_right).offset(-5);
    }];
    
    
    UIImageView *passwordIcon = [[UIImageView alloc] init];
    [passwordIcon setImage:[UIImage imageNamed:@"password"]];
    [self.baseView addSubview:passwordIcon];
    _passwordIcon = passwordIcon;
    //passwordIcon.backgroundColor = [UIColor yellowColor];
    UITextField *passwordTF = [[UITextField alloc] init];
    
    [passwordTF setBackgroundColor:[UIColor clearColor]];
    [passwordTF setKeyboardType:UIKeyboardTypeDefault];
    [passwordTF setBorderStyle:UITextBorderStyleNone];
    [passwordTF setAutocapitalizationType:UITextAutocapitalizationTypeNone]; //关闭首字母大写
    [passwordTF setReturnKeyType:UIReturnKeyDone]; //完成
    [passwordTF setSecureTextEntry:YES]; //验证
    [passwordTF setDelegate:self];
    [passwordTF setTag:102];
    [passwordTF setPlaceholder:@"密码"];
    [passwordTF setTextColor:[UIColor grayColor]];
    [passwordTF setFont:[UIFont systemFontOfSize:14]];
    [passwordTF setText:@"123456"];
    [self.baseView addSubview:passwordTF];
    _passwordTF = passwordTF;
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.passwordIcon.mas_right).offset(4);
        make.top.equalTo(self.baseView).offset(46);
        make.height.mas_equalTo(28);
        make.right.equalTo(self.baseView.mas_right).offset(-40);
    }];
    
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.baseView).offset(4);
        make.top.equalTo(self.baseView).offset(48);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(26);
    }];
    
    
    UIButton *eyeIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    //[eyeIcon.imageView setImage:[UIImage imageNamed:@"btn_closeeye"]];
    [eyeIcon setImage:[UIImage imageNamed:@"btn_closeeye"] forState:UIControlStateNormal];
    [eyeIcon setImage:[UIImage imageNamed:@"btn_openeye"] forState:UIControlStateSelected];
    [self.baseView addSubview:eyeIcon];
    [eyeIcon addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
    _eyeIcon = eyeIcon;
    [eyeIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.baseView).offset(0);
        make.top.equalTo(self.baseView).offset(40);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];

}

-(void)setLoginBtnUI{

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = COMMON_COLOR;
    [loginBtn setTintColor:COMMON_COLOR];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5.0;
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    _loginBtn = loginBtn;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.baseView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(260);
    }];
}

-(void)setOtherLoginViewUI{
    
    _leftLine = [[UIView alloc] init];
    _leftLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_leftLine];
    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_bottom).offset(-145);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(20);
        make.width.mas_equalTo(kScreenWidth/2 - 20 - 50);
    }];
    
    _rightLine = [[UIView alloc] init];
    _rightLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rightLine];
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_bottom).offset(-145);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(kScreenWidth/2 + 50);
        make.width.mas_equalTo(kScreenWidth/2 - 20 - 50);
    }];
    
    _otherLab = [[UILabel alloc] init];
    _otherLab.textColor = [UIColor whiteColor];
    _otherLab.text = @"其它登录方式";
    _otherLab.font = [UIFont systemFontOfSize:14];
    _otherLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_otherLab];
    [_otherLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_bottom).offset(-160);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
    }];
    
    _otherLoginView = [[UIView alloc] init];
    _otherLoginView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_otherLoginView];
    [_otherLoginView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_bottom).offset(-100);
        make.height.mas_equalTo(50);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
    }];
    CGFloat width = (kScreenWidth - 80)/3;
    _wcIV = [[UIImageView alloc] init];
    _wcIV.backgroundColor = [UIColor whiteColor];
    _wcIV.layer.masksToBounds = YES;
    _wcIV.layer.cornerRadius = 20;
    //_wcIV.layer.borderColor = [UIColor whiteColor].CGColor;
    //_wcIV.layer.borderWidth = 1.0f;
    _wcIV.image = [UIImage imageNamed:@"icon_weichat"];
    [_otherLoginView addSubview:_wcIV];
    [_wcIV mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.otherLoginView.mas_top).offset(0);
        make.left.equalTo(self.otherLoginView).offset(width/2-20);
        make.width.height.mas_equalTo(40);
    }];
    _wcIV.userInteractionEnabled = YES;
    _wcIV.tag = 1;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMenu:)];
    [_wcIV addGestureRecognizer:tap1];
    
    _qqIV = [[UIImageView alloc] init];
    _qqIV.backgroundColor = [UIColor whiteColor];
    _qqIV.layer.masksToBounds = YES;
    _qqIV.layer.cornerRadius = 20;
    _qqIV.image = [UIImage imageNamed:@"icon_qq"];
    [_otherLoginView addSubview:_qqIV];
    [_qqIV mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.otherLoginView.mas_top).offset(0);
        make.left.equalTo(self.otherLoginView).offset(width+(width/2-20));
        make.width.height.mas_equalTo(40);
    }];
    _qqIV.userInteractionEnabled = YES;
    _qqIV.tag = 2;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMenu:)];
    [_qqIV addGestureRecognizer:tap2];
    
    _sinaIV = [[UIImageView alloc] init];
    _sinaIV.backgroundColor = [UIColor whiteColor];
    _sinaIV.layer.masksToBounds = YES;
    _sinaIV.layer.cornerRadius = 20;
    _sinaIV.image = [UIImage imageNamed:@"icon_sina"];
    [_otherLoginView addSubview:_sinaIV];
    [_sinaIV mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.otherLoginView.mas_top).offset(0);
        make.left.equalTo(self.otherLoginView).offset(2*width+(width/2-20));
        make.width.height.mas_equalTo(40);
    }];

    _sinaIV.userInteractionEnabled = YES;
    _sinaIV.tag = 3;
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMenu:)];
    [_sinaIV addGestureRecognizer:tap3];
}

-(void)OnTapMenu:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *view = (UIView *)tap.view;
    if(view.tag == 1){
        NSLog(@"weichat");
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
                 
                 [self registerByOther:user.uid type:@"weichat" icon:user.icon];
                 
                 
             }
             
             else
             {
                 NSLog(@"%@",error);
             }
             
         }];
    }else if(view.tag == 2){
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
                 
                 NSLog(@"icon=%@",user.icon);
                 
                 [self registerByOther:user.uid type:@"qq" icon:user.icon];
             }
             
             else
             {
                 NSLog(@"%@",error);
             }
             
         }];
    }else if(view.tag == 3){
    
        [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
                 
                 [self registerByOther:user.uid type:@"weibo" icon:user.icon];
             }
             
             else
             {
                 NSLog(@"%@",error);
             }
             
         }];
    }
    
}

-(void)registerByOther:(NSString *)uid type:(NSString *)type icon:(NSString *)icon{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:UserRegisterUrl];
    //if([AppDelegate APP].user){
        
    NSMutableDictionary *params = [NSMutableDictionary new];
    int userid = [self getRandomNumber:10000000 to:99999999];
    NSString *username = [NSString stringWithFormat:@"tv%d",userid];
    [params setObject:username forKey:@"username"];
    [params setObject:type forKey:@"type"];
    [params setObject:uid forKey:@"uid"];
    
    [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
            NSLog(@"success");
        NSObject *obj = [responseObject objectForKey:@"data"];
        ABFUserInfo *user = [ABFUserInfo mj_objectWithKeyValues:obj];
        NSLog(@"username=%@",user.username);
        user.profile = icon;
        [AppDelegate APP].user = user;
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
            
    } failure:^(NSError *error) {
            NSLog(@"error%@",error);
    }];
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from +1)));
}

-(void)backClick:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)loginAction:(id)sender{
    
    NSString *fullUrl = [BaseUrl stringByAppendingString:LoginUrl];
    //fullUrl = [fullUrl stringByAppendingString:[NSString stringWithFormat:@"username=%@&password=%@",self.usernameTF.text,@"123456"]];
    NSLog(@"url=%@",fullUrl);
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:self.usernameTF.text forKey:@"username"];
    [params setObject:self.passwordTF.text forKey:@"password"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PPNetworkHelper POST:fullUrl parameters:params success:^(id responseObject) {
        
        NSObject *obj = [responseObject objectForKey:@"data"];
        ABFUserInfo *user = [ABFUserInfo mj_objectWithKeyValues:obj];
        
        NSLog(@"username=%@",user.username);
        
        [AppDelegate APP].user = user;
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        
    }];

}

-(void)eyeAction:(id)sender{

    UIButton *btn = (UIButton *)sender;
    btn.selected=!btn.selected;
    if(btn.selected){
        [_passwordTF setSecureTextEntry:NO];
    }else{
        [_passwordTF setSecureTextEntry:YES];
    }
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
