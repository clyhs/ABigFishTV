//
//  ABFCalendarTitleDateView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/11.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "ABFCalendarTitleDateView.h"

@interface ABFCalendarTitleDateView()

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UIButton *leftBtn;
@property(nonatomic,strong) UIButton *rightBtn;

@end

@implementation ABFCalendarTitleDateView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor =COMMON_COLOR;
        [self setupUI];
        NSLog(@"ABFCalendarTitleDateView init");
        
    }
    
    return self;
}

-(void)setupUI{
    _titleLab = [UILabel new];
    _titleLab.adjustsFontSizeToFitWidth = YES;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor whiteColor];
    [self addSubview:_titleLab];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setTitle:@"<<" forState:UIControlStateNormal];
    [_leftBtn setTintColor:[UIColor whiteColor]];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_leftBtn addTarget:self action:@selector(leftClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftBtn];
    
    _rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@">>" forState:UIControlStateNormal];
    [_rightBtn setTintColor:[UIColor whiteColor]];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_rightBtn addTarget:self action:@selector(rightClick:)
       forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_rightBtn];
    
}

- (void)setLabelWithYear:(NSInteger)year month:(NSInteger)month
{
    NSString *text = [NSString stringWithFormat:@"%@年%@月", @(year), @(month)];
    self.titleLab.text = text;
}

- (void)setTitleLabelFontSize:(CGFloat)fontSize
{
    self.titleLab.font = [UIFont systemFontOfSize:fontSize];
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(100);
        make.height.equalTo(self);
    }];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.titleLab.mas_left).offset(-60);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(60);
        make.height.equalTo(self);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.titleLab.mas_right).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(60);
        make.height.equalTo(self);
    }];
}

-(void)leftClick:(id)sender{

    if ([self.delegate respondsToSelector:@selector(calendarTitleLeftButtonClicked)]) {
        [self.delegate calendarTitleLeftButtonClicked];
    }
}

-(void)rightClick:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(calendarTitleRightButtonClicked)]) {
        [self.delegate calendarTitleRightButtonClicked];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
