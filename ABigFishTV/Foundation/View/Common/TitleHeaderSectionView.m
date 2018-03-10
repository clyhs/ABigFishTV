//
//  TitleHeaderSectionView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/21.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "TitleHeaderSectionView.h"

@interface TitleHeaderSectionView()

@property (nonatomic, weak) UIView  *leftLineView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView  *bottomLine;
@property (nonatomic, weak) UIView  *topLine;

@end

@implementation TitleHeaderSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = LINE_BG;
    
        [self addLeftLineView];
        
        [self addTitleLabel];
        
        [self addTopLine];
        
        [self addBottomLine];
    }
    
    return self;

}

- (void) addLeftLineView{

    UIView *leftLineView = [[UIView alloc]init];
    leftLineView.backgroundColor = RGB_255(30,144,255);
    [self.contentView addSubview:leftLineView];
    _leftLineView = leftLineView;
}

- (void)addTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB_255(155, 155, 155);
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat edging = 6;
    _leftLineView.frame = CGRectMake(12, edging, 3, CGRectGetHeight(self.frame)-2*edging);
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_leftLineView.frame)+8, 0, 200, CGRectGetHeight(self.frame));
    _bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, kScreenWidth, 0.5);
    _topLine.frame =CGRectMake(0, 0, kScreenWidth, 0.5);
    
}


@end
