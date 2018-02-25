//
//  ABFChatHeaderSectionView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFChatHeaderSectionView.h"

@implementation ABFChatHeaderSectionView

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
        self.backgroundColor = [UIColor whiteColor];
        [self addLeftLineView];
        [self addGoodLab];
        [self addBottomLine];
        [self addTitleLabel];
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
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB_255(155, 155, 155);
    [self addSubview:titleLabel];
    _titleLab = titleLabel;
}

- (void)addBottomLine{
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = LINE_BG;
    [self addSubview:bottomLine];
    _bottomLine = bottomLine;
    
}

- (void)addGoodLab{
    
    UILabel *gLabel = [[UILabel alloc]init];
    gLabel.font = [UIFont systemFontOfSize:14];
    gLabel.textColor = RGB_255(155, 155, 155);
    gLabel.text = @"点赞 ";
    [self addSubview:gLabel];
    _goodLab = gLabel;
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat edging = 12;
    _leftLineView.frame = CGRectMake(12, edging, 3, CGRectGetHeight(self.frame)-2*edging);
    _titleLab.frame = CGRectMake(CGRectGetMaxX(_leftLineView.frame)+8, 0, 200, CGRectGetHeight(self.frame));
    _goodLab.frame = CGRectMake(kScreenWidth-60, 0, 60, CGRectGetHeight(self.frame));
    _bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame)-0.5, kScreenWidth, 0.5);
}




@end
