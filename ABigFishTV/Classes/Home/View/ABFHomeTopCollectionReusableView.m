//
//  ABFHomeTopCollectionReusableView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/13.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFHomeTopCollectionReusableView.h"

@interface ABFHomeTopCollectionReusableView()

@property (nonatomic, weak) UIView  *leftLineView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView  *bottomLine;
@property (nonatomic, weak) UIView  *topLine;

@end

@implementation ABFHomeTopCollectionReusableView

- (id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        [self addAdView];
        [self addTopView];
        [self addBotView];
        [self addLeftLineView];
        [self addTitleLabel];
        [self addMoreBtn];
        [self addBottomLine];
        [self addTopLine];
    }
    return self;
    
}

-(void) addAdView{
    
    _adView= [[UIView alloc] init];
    _adView.backgroundColor = [UIColor clearColor];
    [self addSubview:_adView];

}

-(void) addTopView{
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor clearColor];
    [self addSubview:_topView];
    /*
    [_topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.equalTo(self);
        make.height.mas_equalTo(160);
    }];*/

}

-(void) addBotView{

    _botView = [[UIView alloc] init];
    _botView.backgroundColor = [UIColor clearColor];
    [self addSubview:_botView];
    /*
    [_topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];*/

}

- (void) addLeftLineView{
    
    UIView *leftLineView = [[UIView alloc]init];
    leftLineView.backgroundColor = RGB_255(30,144,255);
    [self.botView addSubview:leftLineView];
    _leftLineView = leftLineView;
}

- (void)addTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = RGB_255(155, 155, 155);
    [self.botView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)addMoreBtn{
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    //moreBtn.backgroundColor = [UIColor greenColor];
    [moreBtn setTitleColor:RGB_255(155, 155, 155) forState:UIControlStateNormal];
    moreBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.botView addSubview:moreBtn];
    _moreBtn = moreBtn;
    
    
}

- (void)addBottomLine{
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = LINE_BG;
    [self.botView addSubview:bottomLine];
    _bottomLine = bottomLine;
    
}

- (void)addTopLine{
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = LINE_BG;
    [self.botView addSubview:topLine];
    _topLine = topLine;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _topView.frame = CGRectMake(0, 150, kScreenWidth, 160);
    _botView.frame = CGRectMake(0, 160+150, kScreenWidth, 40);
    
    _leftLineView.frame = CGRectMake(12, 12, 3, 40-2*12);
    _titleLabel.frame = CGRectMake(15+8, 0, 200, 40);
    _moreBtn.frame = CGRectMake(kScreenWidth-60, 0, 60, 40);
    _bottomLine.frame = CGRectMake(0, 39.5, kScreenWidth, 0.5);
    _topLine.frame =CGRectMake(0, 0, kScreenWidth, 0.5);
}

@end
