//
//  ABFCollectionViewCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFCollectionViewCell.h"

@implementation ABFCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //定义CELL单元格内容
        
        [self addIcon];
        
        [self addTitleLabel];
        
        [self addEyeImageView];
        
        [self addHitLab];
        
    }
    return self;
    
}



-(void)addTitleLabel{
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textAlignment =NSTextAlignmentCenter;
    [self addSubview:_titleLab];

}

-(void)addIcon{
    
    _icon = [[UIImageView alloc] init];
    _icon.backgroundColor = LINE_BG;
    _icon.layer.borderWidth = 0.1f;
    _icon.layer.borderColor = [UIColor whiteColor].CGColor;
    _icon.layer.masksToBounds = YES;
    _icon.layer.cornerRadius = 4;
    [self addSubview:_icon];
    
}

-(void)addEyeImageView{
    UIImageView *eyeImageView = [[UIImageView alloc] init];
    [eyeImageView setImage:[UIImage imageNamed:@"icon_eye"]];
    [self.icon addSubview:eyeImageView];
    _eyeImageView = eyeImageView;
}

-(void)addHitLab{
    
    _hitLab = [[UILabel alloc] init];
    _hitLab.backgroundColor = [UIColor clearColor];
    _hitLab.textAlignment =NSTextAlignmentLeft;
    _hitLab.font = [UIFont systemFontOfSize:12];
    _hitLab.textColor = [UIColor lightGrayColor];
    
    [self.icon addSubview:_hitLab];
}

-(void)setModel:(ABFTelevisionInfo *)model{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:_model.bg] placeholderImage:[UIImage imageNamed:@""]];
    _hitLab.text =[NSString stringWithFormat:@"%ld",_model.hit] ;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(5);
        make.width.mas_offset(kScreenWidth/2-10);
        make.height.mas_equalTo(self.frame.size.height-30);
    }];
    
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(self.frame.size.height-30);
        make.width.equalTo(self);
        make.height.equalTo(@30);
    }];
    
    [_eyeImageView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.bottom.equalTo(self.icon).offset(-2);
        make.left.equalTo(self.icon).offset(5);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [_hitLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.icon).offset(25);
        make.bottom.equalTo(self.icon).offset(-2);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(18);
    }];
    

}



@end
