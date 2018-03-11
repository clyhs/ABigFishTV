//
//  ABFCalendarWeekView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/11.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "ABFCalendarWeekView.h"

@interface ABFCalendarWeekView()

@property (nonatomic, strong)  UILabel *sunLabel;
@property (nonatomic, strong)  UILabel *monLabel;
@property (nonatomic, strong)  UILabel *tueLabel;
@property (nonatomic, strong)  UILabel *wedLabel;
@property (nonatomic, strong)  UILabel *thuLabel;
@property (nonatomic, strong)  UILabel *friLabel;
@property (nonatomic, strong)  UILabel *satLabel;


@end

@implementation ABFCalendarWeekView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = LINE_BG;
        [self setupUI];
        
    }
    
    return self;
}

-(void)setupUI{
    
    _sunLabel = [UILabel new];
    _sunLabel.text=@"日";
    _sunLabel.textAlignment = NSTextAlignmentCenter;
    _sunLabel.textColor = COMMON_COLOR;
    
    _monLabel = [UILabel new];
    _monLabel.text=@"一";
    _monLabel.textAlignment = NSTextAlignmentCenter;
    _monLabel.textColor = COMMON_COLOR;
    
    _tueLabel = [UILabel new];
    _tueLabel.text=@"二";
    _tueLabel.textAlignment = NSTextAlignmentCenter;
    _tueLabel.textColor = COMMON_COLOR;
    
    _wedLabel = [UILabel new];
    _wedLabel.text=@"三";
    _wedLabel.textAlignment = NSTextAlignmentCenter;
    _wedLabel.textColor = COMMON_COLOR;
    
    _thuLabel = [UILabel new];
    _thuLabel.text=@"四";
    _thuLabel.textAlignment = NSTextAlignmentCenter;
    _thuLabel.textColor = COMMON_COLOR;
    
    _friLabel = [UILabel new];
    _friLabel.text=@"五";
    _friLabel.textAlignment = NSTextAlignmentCenter;
    _friLabel.textColor = COMMON_COLOR;
    
    _satLabel = [UILabel new];
    _satLabel.text=@"六";
    _satLabel.textAlignment = NSTextAlignmentCenter;
    _satLabel.textColor =COMMON_COLOR;
    
    [self addSubview:_sunLabel];
    [self addSubview:_monLabel];
    [self addSubview:_tueLabel];
    [self addSubview:_wedLabel];
    [self addSubview:_thuLabel];
    [self addSubview:_friLabel];
    [self addSubview:_satLabel];

}

- (void)setLabelsFontSize:(CGFloat)fontSize
{
    self.sunLabel.font = [UIFont systemFontOfSize:fontSize];
    self.monLabel.font = [UIFont systemFontOfSize:fontSize];
    self.wedLabel.font = [UIFont systemFontOfSize:fontSize];
    self.thuLabel.font = [UIFont systemFontOfSize:fontSize];
    self.friLabel.font = [UIFont systemFontOfSize:fontSize];
    self.satLabel.font = [UIFont systemFontOfSize:fontSize];
    self.tueLabel.font = [UIFont systemFontOfSize:fontSize];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat width = kScreenWidth/ 7;
    
    [_sunLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(width);
        make.height.equalTo(self);
    }];
    [_monLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(width);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(width);
        make.height.equalTo(self);
    }];
    [_tueLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(width*2);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(width);
        make.height.equalTo(self);
    }];
    [_wedLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(width*3);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(width);
        make.height.equalTo(self);
    }];
    [_thuLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(width*4);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(width);
        make.height.equalTo(self);
    }];
    [_friLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(width*5);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(width);
        make.height.equalTo(self);
    }];
    [_satLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(width*6);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(width);
        make.height.equalTo(self);
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
