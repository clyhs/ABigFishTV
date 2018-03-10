//
//  NavigationBarView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "NavigationBarView.h"

@interface NavigationBarView()

@property (weak, nonatomic) UIButton *backBtn;
@property (weak, nonatomic) UILabel  *titleLabel;
@property (weak, nonatomic) UIView   *backgroundView;

@end

@implementation NavigationBarView

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
        self.backgroundColor = COMMON_COLOR;
        [self addBackgroundView];
        [self addBackBtn];
        [self addTitleLabel:@""];
    
    }
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = COMMON_COLOR;
        [self addBackgroundView];
        [self addBackBtn];
        [self addTitleLabel:title];
        
    }

    return self;
}

- (void)addBackBtn{
    
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //self.backBtn.frame = CGRectMake(0, 0, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    //[self.backBtn setImage:[UIImage imageNamed:@"back_video_highlight"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(navBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backgroundView addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.backgroundView).offset(0);
        make.top.equalTo(self.backgroundView).offset(5);
        make.width.height.equalTo(@40);
    }];
    
    self.backBtn = backBtn;

}

- (void)addTitleLabel:(NSString *)title{

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 15, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:FONTNAME size:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    _title = title;
    [self.backgroundView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)addBackgroundView{

    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = self.bounds;
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
}


- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha
{
    _backgroundAlpha = backgroundAlpha;
    if (_backgroundView) {
        _backgroundView.alpha = backgroundAlpha;
    }
}


- (void)navBack:(id)sender {
    NSLog(@"back");
    if (_navBackHandle) {
        _navBackHandle();
    }else {
        UIViewController *VC = [self viewController];
        if (VC && VC.navigationController) {
            NSLog(@",....");
            [VC.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"hhh");
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
