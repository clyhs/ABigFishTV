//
//  ABFCalendarTitleDateView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/11.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABFCalendarTitleDateViewDelegate <NSObject>

@required
- (void)calendarTitleLeftButtonClicked;
- (void)calendarTitleRightButtonClicked;

@end

@interface ABFCalendarTitleDateView : UIView

@property (nonatomic, weak) id<ABFCalendarTitleDateViewDelegate> delegate;

- (void)setLabelWithYear:(NSInteger)year month:(NSInteger)month;
- (void)setTitleLabelFontSize:(CGFloat)fontSize;

@end
