//
//  ABFNavigationBarView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/10.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFNavigationBarView.h"

@interface ABFNavigationBarView()


@property (weak, nonatomic) UILabel  *titleLabel;
@property (weak, nonatomic) UIView   *backgroundView;

@end

@implementation ABFNavigationBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundViewUI];
        [self setBackBtnUI];
        [self addTitleLabel];
    }
    return self;
    
}

- (void)setBackgroundViewUI{
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = self.bounds;
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
}


- (void)setBackBtnUI{
    
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(navBack:) forControlEvents:UIControlEventTouchUpInside];
    //backBtn.backgroundColor = LINE_BG;
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 3, 5, 5);
    [self.backgroundView addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.backgroundView).offset(8);
        make.top.equalTo(self.backgroundView).offset(26);
        make.width.height.equalTo(@30);
    }];
    
    self.backBtn = backBtn;
    
}

- (void)addTitleLabel{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 20, 100, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:21];
    titleLabel.textColor = [UIColor whiteColor];
    [self.backgroundView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha
{
    _backgroundAlpha = backgroundAlpha;
    if (_backgroundView) {
        _backgroundView.alpha = backgroundAlpha;
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}


-(void)setLeftBtnImageName:(NSString *)leftBtnImageName{
    _leftBtnImageName = leftBtnImageName;
    [_backBtn setImage:[UIImage imageNamed:leftBtnImageName] forState:UIControlStateNormal];
}

- (void)navBack:(id)sender {
    NSLog(@"back");
    if (_navBackHandle) {
        _navBackHandle();
    }else {
        UIViewController *VC = [self viewController];
        if (VC && VC.navigationController) {
            [VC.navigationController popViewControllerAnimated:YES];
        }
        if(VC && VC.presentedViewController){
            [VC dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
