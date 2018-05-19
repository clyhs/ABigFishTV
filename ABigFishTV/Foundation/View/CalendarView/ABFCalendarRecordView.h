//
//  ABFCalendarRecordView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/11.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABFCalendarTitleBarView.h"
#import "ABFCalendarView.h"

@protocol ABFCalendarRecordViewDelegate <NSObject>

@required
- (void)calendarRecordDidSelectedDate:(NSDate *)date;

@end

@interface ABFCalendarRecordView : UIView

@property(nonatomic,strong) ABFCalendarTitleBarView *titleBarView;
@property(nonatomic,strong) ABFCalendarView         *calendarView;

@property (nonatomic, weak) id<ABFCalendarRecordViewDelegate> delegate;

- (void)resetCalendarWithDate:(NSDate *)date;
- (void)resetCalendarFrame;

@end
