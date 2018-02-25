//
//  ABFLeftTableViewCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/8.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFLeftTableViewCell.h"

@implementation ABFLeftTableViewCell

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
        self.contentView.backgroundColor = LINE_BG;
        //[self setEffect];
        [self addTitleLab];
        //[self addRightLine];
        [self addBottomLine];
        //[self addIcon];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.contentView.backgroundColor = LINE_BG;
        //[self setEffect];
        [self addTitleLab];
        //[self addRightLine];
        //[self addBottomLine];
        //[self addIcon];
    }
    return self;
}

-(void)setEffect{
    //self.contentView.backgroundColor =[UIColor clearColor];
    //self.contentView.alpha = 0.9;
    

}

-(void)addIcon{
    
    _icon = [[UIImageView alloc] init];
    
    [self addSubview:_icon];
    

}

-(void)addTitleLab{
    
    _titleLab = [[UILabel alloc] init];
    //_titleLab.backgroundColor = RGB_255(47, 79, 79);
    _titleLab.textAlignment =NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:14];
    _titleLab.textColor = COMMON_COLOR;
    [self addSubview:_titleLab];
}

-(void)addRightLine{
    _rightLine = [[UIView alloc] init];
    _rightLine.backgroundColor =  [UIColor lightGrayColor];

    [self addSubview:_rightLine];

}

-(void)addBottomLine{

    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = RGB_255(230, 230, 230);
    [self addSubview:_bottomLine];
}

-(void)setIconUrl:(NSString *)iconUrl{
    _iconUrl = iconUrl;
    [_icon sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@""]];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.height.mas_equalTo(25);
    }];
    
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(0.8);
        make.height.mas_equalTo(self);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(0.8);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(8);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
}



@end
