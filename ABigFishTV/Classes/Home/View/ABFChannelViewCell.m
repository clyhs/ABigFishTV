//
//  ABFChannelViewCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/24.
//  Copyright © 2017年 陈立宇. All rights reserved.
//


#import "ABFChannelViewCell.h"

@implementation ABFChannelViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //定义CELL单元格内容
        [self addPlayerImageView];
        
        [self addTitleLab];
        
        [self addEyeImageView];
        
        [self addHitLab];
        
        [self addBottomLine];
        
        //[self addPlayImage];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //定义CELL单元格内容
        [self addPlayerImageView];
        
        [self addTitleLab];
        
        [self addEyeImageView];
        
        [self addHitLab];
        
        [self addBottomLine];
        
        [self addPlayImage];
        
    }
    return self;
    
}

-(void)addTitleLab{
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textAlignment =NSTextAlignmentLeft;
    [self addSubview:_titleLab];
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

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_playImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        
        make.width.mas_equalTo(130);
        make.height.equalTo(self).offset(-20);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(150);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [_eyeImageView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(self).offset(self.frame.size.height-30);
        make.left.equalTo(self).offset(150);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [_hitLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(173);
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
