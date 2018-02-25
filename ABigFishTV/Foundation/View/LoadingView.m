//
//  LoadingView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/28.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{

    if (self = [super init]) {
        _edgeInset = UIEdgeInsetsZero;
        self.backgroundColor = [UIColor redColor];
        [self addTitleLabel];
    }
    return self;
}

+ (void)showLoadingView:(UIView *)view{
    [self showLoadingView:view edgeInset:UIEdgeInsetsZero];
}

+ (void)showLoadingView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset
{
    LoadingView *loadingView = [[LoadingView alloc] init];
    
    loadingView.edgeInset = edgeInset;
    
    [loadingView showView:view];
}

- (void)showView:(UIView *)view
{
    if (!view) {
        return ;
    }
    if (self.superview != view) {
        
        [self removeFromSuperview];
        
        [view addSubview:self];
        
        [view bringSubviewToFront:self];
        
        [self addConstraintInView:view edgeInset:_edgeInset];
    }
    
}

- (void) addConstraintInView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInset.top]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:edgeInset.left]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:edgeInset.right]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInset.bottom]];
    
    
}

- (void) addTitleLabel{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"test...";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"system" size:12];
    titleLabel.textColor = RGB_255(30, 130, 245);
    titleLabel.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@40);
        
    }];
    

}

@end
