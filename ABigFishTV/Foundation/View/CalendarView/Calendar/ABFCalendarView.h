//
//  ABFCalendarView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/10.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABFCalendarDelegate <NSObject>

@required
- (void)calendarDidSelectedDate:(NSDate *)date;

@optional
- (void)calendarSlideFinishWithDisplayDate:(NSDate *)displayDate;


@end

@interface ABFCalendarView : UIView

@property (nonatomic, weak) id<ABFCalendarDelegate> delegate;

//- (void)resetCalanderWithDate:(NSDate *)date;
//- (void)resetSubviewFrame;

//- (void)slideToLastMonth;
//- (void)slideToNextMonth;

@end
