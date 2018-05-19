//
//  ABFCalendarTitleBarView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/11.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "ABFCalendarTitleBarView.h"
#import "ABFCalendarTitleDateView.h"
#import "ABFCalendarWeekView.h"
#import "NSDate+ABFDate.h"

@interface ABFCalendarTitleBarView()<ABFCalendarTitleDateViewDelegate>

//@property(nonatomic,strong) ABFCalendarTitleDateView *titleView;
//@property(nonatomic,strong) ABFCalendarWeekView      *weekView;

@end

@implementation ABFCalendarTitleBarView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = LINE_BG;
        [self setupUI];
        self.titleView.delegate = self;
        NSLog(@"ABFCalendarTitleBarView init");
    }
    
    return self;
}

-(void)setupUI{
    ABFCalendarTitleDateView *titleView = [[ABFCalendarTitleDateView alloc] init];
    [self addSubview:titleView];
    _titleView = titleView;
    ABFCalendarWeekView *weekView =[[ABFCalendarWeekView alloc] init];
    [self addSubview:weekView];
    _weekView = weekView;
}

- (void)setupWithDate:(NSDate *)date
{
    NSInteger year = [date yearValue];
    NSInteger month = [date monthValue];
    
    [self.titleView setLabelWithYear:year month:month];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize weekdayFontSize:(CGFloat)weekdayFontSize
{
    [self.titleView setTitleLabelFontSize:titleFontSize];
    [self.weekView setLabelsFontSize:weekdayFontSize];
}

- (void)calendarTitleLeftButtonClicked
{
    [self.delegate titleBarLeftButtonClicked];
}

- (void)calendarTitleRightButtonClicked
{
    [self.delegate titleBarRightButtonClicked];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [_weekView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(40);
        make.width.equalTo(self);
        make.height.mas_equalTo(24);
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
