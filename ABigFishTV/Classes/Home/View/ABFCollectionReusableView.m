//
//  ABFCollectionReusableView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFCollectionReusableView.h"

@interface ABFCollectionReusableView()

@property (nonatomic, weak) UIView  *leftLineView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView  *bottomLine;
@property (nonatomic, weak) UIView  *topLine;

@end

@implementation ABFCollectionReusableView

- (id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        [self addLeftLineView];
        [self addTitleLabel];
        [self addMoreBtn];
        [self addBottomLine];
        [self addTopLine];
    }
    return self;

}


- (void) addLeftLineView{
    
    UIView *leftLineView = [[UIView alloc]init];
    leftLineView.backgroundColor = RGB_255(30,144,255);
    [self addSubview:leftLineView];
    _leftLineView = leftLineView;
}

- (void)addTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = RGB_255(155, 155, 155);
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)addMoreBtn{
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    //moreBtn.backgroundColor = [UIColor greenColor];
    [moreBtn setTitleColor:RGB_255(155, 155, 155) forState:UIControlStateNormal];
    moreBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self addSubview:moreBtn];
    _moreBtn = moreBtn;
    

}

- (void)addBottomLine{
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = LINE_BG;
    [self addSubview:bottomLine];
    _bottomLine = bottomLine;

}

- (void)addTopLine{
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = LINE_BG;
    [self addSubview:topLine];
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
    CGFloat edging = 12;
    _leftLineView.frame = CGRectMake(12, edging, 3, CGRectGetHeight(self.frame)-2*edging);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_leftLineView.frame)+8, 0, 200, CGRectGetHeight(self.frame));
    _moreBtn.frame = CGRectMake(kScreenWidth-60, 0, 60, CGRectGetHeight(self.frame));
    _bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, kScreenWidth, 0.5);
    _topLine.frame =CGRectMake(0, 0, kScreenWidth, 0.5);
}

@end
