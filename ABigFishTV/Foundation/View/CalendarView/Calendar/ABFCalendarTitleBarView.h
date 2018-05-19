//
//  ABFCalendarTitleBarView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/11.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABFCalendarWeekView.h"
#import "ABFCalendarTitleDateView.h"


@protocol ABFCalendarTitleBarViewDelegate <NSObject>

@required
- (void)titleBarLeftButtonClicked;
- (void)titleBarRightButtonClicked;

@end

@interface ABFCalendarTitleBarView : UIView

@property(nonatomic,strong) ABFCalendarTitleDateView *titleView;
@property(nonatomic,strong) ABFCalendarWeekView      *weekView;

@property (nonatomic, weak) id<ABFCalendarTitleBarViewDelegate> delegate;

- (void)setupWithDate:(NSDate *)date;
- (void)setTitleFontSize:(CGFloat)titleFontSize weekdayFontSize:(CGFloat)weekdayFontSize;


@end
