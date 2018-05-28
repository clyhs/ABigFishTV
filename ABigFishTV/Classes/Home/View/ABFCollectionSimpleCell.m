//
//  ABFCollectionSimpleCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/5.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFCollectionSimpleCell.h"
#import "ABFTelevisionInfo.h"

@implementation ABFCollectionSimpleCell

-(instancetype)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self addPlayerImageView];
        
        [self addTitleLab];
        
        [self addEyeImageView];
        
        [self addHitLab];
        
        [self addBottomLine];
        
        [self addPlayTitleLab];
        
    }
    return self;
    
}

-(void)addTitleLab{
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textAlignment =NSTextAlignmentLeft;
    [self addSubview:_titleLab];
}

-(void)addPlayTitleLab{
    
    _playtitleLab = [[UILabel alloc] init];
    _playtitleLab.backgroundColor = [UIColor clearColor];
    _playtitleLab.textColor = COMMON_COLOR;
    _playtitleLab.font = [UIFont systemFontOfSize:14];
    _playtitleLab.textAlignment =NSTextAlignmentLeft;
    [self addSubview:_playtitleLab];
    
    _nexttitleLab = [[UILabel alloc] init];
    _nexttitleLab.backgroundColor = [UIColor clearColor];
    _nexttitleLab.textColor = [UIColor lightGrayColor];
    _nexttitleLab.font = [UIFont systemFontOfSize:14];
    _nexttitleLab.textAlignment =NSTextAlignmentLeft;
    [self addSubview:_nexttitleLab];
}

-(void)addPlayerImageView{
    
    UIImageView *playerImageView = [[UIImageView alloc] init];
    playerImageView.layer.borderWidth = 0.8f;
    playerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    playerImageView.layer.masksToBounds = YES;
    playerImageView.layer.cornerRadius = 4;
    [self addSubview:playerImageView];
    _playImageView = playerImageView;
    
}

-(void)addEyeImageView{
    UIImageView *eyeImageView = [[UIImageView alloc] init];
    
    [eyeImageView setImage:[UIImage imageNamed:@"icon_eye"]];
    
    [self addSubview:eyeImageView];
    _eyeImageView = eyeImageView;
}

-(void)addHitLab{
    
    _hitLab = [[UILabel alloc] init];
    _hitLab.backgroundColor = [UIColor clearColor];
    _hitLab.textAlignment =NSTextAlignmentLeft;
    _hitLab.font = [UIFont systemFontOfSize:12];
    _hitLab.textColor = [UIColor lightGrayColor];
    [self addSubview:_hitLab];
}

-(void)addBottomLine{
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_BG;
    [self addSubview:_bottomLine];
}

-(void)addPlayImage{
    
    _playImage = [[UIImageView alloc] init];
    [_playImage setImage:[UIImage imageNamed:@"btn_playplus"]];
    [_playImageView addSubview:_playImage];
    
}

-(void)setPlayerImage:(NSString *)url{
    
    //_playImageView.frame = CGRectMake(5, 5, 120, self.frame.size.height-5);
    _playImageView.backgroundColor=[UIColor lightGrayColor];
    [_playImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
    
}

-(void)setModel:(ABFTelevisionInfo *)model{
    _model = model;
    [_playImageView sd_setImageWithURL:[NSURL URLWithString:model.bg] placeholderImage:[UIImage imageNamed:@""]];
    _hitLab.text =[NSString stringWithFormat:@"%ld",_model.hit] ;
    _playtitleLab.text = [NSString stringWithFormat:@"%@",model.playtitle];
    _nexttitleLab.text =[NSString stringWithFormat:@"%@",model.nexttitle];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_playImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-self.frame.size.width/2-5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.playImageView.mas_right).offset(10);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [_playtitleLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.playImageView.mas_right).offset(10);
        make.top.equalTo(self).offset(35);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(20);
    }];
    [_nexttitleLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.playImageView.mas_right).offset(10);
        make.top.equalTo(self).offset(55);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [_eyeImageView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(self).offset(self.frame.size.height-30);
        make.left.equalTo(self.playImageView.mas_right).offset(10);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [_hitLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.eyeImageView.mas_right).offset(5);
        make.top.equalTo(self).offset(self.frame.size.height-30);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(18);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(0.8);
    }];
    
    [_playImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.playImageView);
        make.width.height.mas_equalTo(50);
    }];
    
    
}

@end
