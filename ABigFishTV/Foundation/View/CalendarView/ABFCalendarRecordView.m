//
//  ABFCalendarRecordView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/11.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "ABFCalendarRecordView.h"
#import "ABFCalendarTitleBarView.h"
#import "ABFCalendarView.h"
#import "NSDate+ABFDate.h"

@interface ABFCalendarRecordView()<ABFCalendarTitleBarViewDelegate,ABFCalendarDelegate>

@property(nonatomic,strong) ABFCalendarTitleBarView *titleBarView;
@property(nonatomic,strong) ABFCalendarView         *calendarView;
@property (nonatomic, strong) NSDate                *currentDate;

@end

const CGFloat kMinimumInteritemSpacing = 0;
const CGFloat kMinimumLineSpacing = 1;

@implementation ABFCalendarRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        [self setupUI];
        //self.titleView.delegate = self;
        self.titleBarView.delegate = self;
        
        self.calendarView.delegate = self;
        [self.titleBarView setupWithDate:[NSDate date]];
        
        NSLog(@"ABFCalendarRecordView init");
        [self.titleBarView setTitleFontSize:24 weekdayFontSize:15];
        
    }
    
    return self;
}

-(void)setupUI{
    
    ABFCalendarTitleBarView *titleBarView = [[ABFCalendarTitleBarView alloc] init];
    [self addSubview: titleBarView];
    _titleBarView = titleBarView;
    ABFCalendarView *calendarView = [[ABFCalendarView alloc] init];
    [self addSubview:calendarView];
    _calendarView = calendarView;

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    CGFloat height = (kScreenWidth/9.5+10)*6;
    [_titleBarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.equalTo(self);
        make.height.mas_equalTo(64);
    }];
    [_calendarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(64);
        make.width.equalTo(self);
        make.height.mas_equalTo(height);
    }];
}

- (void)resetCalendarFrame
{
    [self.calendarView resetSubviewFrame];
    //    [self bringSubviewToFront:self.calendar];
}

- (void)toLastMonth
{
    // 日历跳到上一个月
    
    [self.calendarView slideToLastMonth];
}

- (void)toNextMonth
{
    // 日历跳到下一个月
    
    [self.calendarView slideToNextMonth];
}

- (void)resetCalendarWithDate:(NSDate *)date
{
    self.currentDate = date;
    
    [self.calendarView resetCalanderWithDate:date];
    [self.titleBarView setupWithDate:date];
}

#pragma mark - ABFCalendarTitleBarViewDelegate

- (void)titleBarLeftButtonClicked
{
    [self toLastMonth];
}

- (void)titleBarRightButtonClicked
{
    [self toNextMonth];
}

#pragma mark - ABFCalendarDelegate

- (void)calendarSlideFinishWithDisplayDate:(NSDate *)displayDate
{
    [self.titleBarView setupWithDate:displayDate];
}

- (void)calendarDidSelectedDate:(NSDate *)date
{
    [self.delegate calendarRecordDidSelectedDate:date];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
