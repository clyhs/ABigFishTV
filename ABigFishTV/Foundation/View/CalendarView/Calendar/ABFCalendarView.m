//
//  ABFCalendarView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/10.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "ABFCalendarView.h"
#import "ABFDateItemModel.h"
#import "ABFCalendarDateItem.h"
#import "NSDate+ABFDate.h"

@interface ABFCalendarView()

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *displayDate;  // 当前所显示月份里的日期

// 保存数据的数组
@property (nonatomic, copy) NSArray *currentMonthDataArray;
@property (nonatomic, copy) NSArray *nextMonthDataArray;
@property (nonatomic, copy) NSArray *lastMonthDataArray;

// 用来包含每个月YSCalendarDayItem的父视图
@property (nonatomic, strong) UIView *currentMonthDaysView;
@property (nonatomic, strong) UIView *nextMonthDaysView;
@property (nonatomic, strong) UIView *lastMonthDaysView;

// dayItem数组
@property (nonatomic, strong) NSArray *currentMonthDayItemArray;
@property (nonatomic, strong) NSArray *nextMonthDayItemArray;
@property (nonatomic, strong) NSArray *lastMonthDayItemArray;

//@property (nonatomic, strong) YSDatabaseManager *databaseManager;
@property (nonatomic, assign) BOOL bSlideToLastMonth;
@property (nonatomic, assign) BOOL bNeedSlide;

@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation ABFCalendarView

static const NSInteger kColunm = 7;
static const NSInteger kRow = 6;
static const CGFloat kDuration = 0.6;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
