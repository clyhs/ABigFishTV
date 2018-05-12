//
//  ABFCollectionTopCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/14.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "ABFCollectionTopCell.h"

@implementation ABFCollectionTopCell

-(instancetype)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self addAdView];
        [self addTopView];
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
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = kScreenWidth * 9 / 16 ;
    _adView.frame = CGRectMake(0, 0, kScreenWidth, height);
    _topView.frame = CGRectMake(0, height, kScreenWidth, 160);
    //_adView.frame = CGRectMake(0, 160, kScreenWidth, height);
    //_topView.frame = CGRectMake(0, 0, kScreenWidth, 160);

}

@end
