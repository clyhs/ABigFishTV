//
//  ABFImageCollectionCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/27.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFImageCollectionCell.h"

@implementation ABFImageCollectionCell

-(instancetype)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setProfilePhotoUI];
        [self setCloseButtonUI];
    }
    return self;
    
}

-(void)setProfilePhotoUI{

    _profilePhoto = [[UIImageView alloc] init];
    [self addSubview:_profilePhoto];
}

-(void)setCloseButtonUI{
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self addSubview:_closeButton];
    

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    [_profilePhoto mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
    }];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.height.mas_equalTo(20);
    }];
}

@end
