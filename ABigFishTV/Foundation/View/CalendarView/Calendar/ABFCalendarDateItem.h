//
//  ABFCalendarDateItem.h
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/10.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABFCalendarDateItemDelegate <NSObject>

- (void)touchDayItemWithDay:(NSInteger)day;

@end

@class ABFDateItemModel;

@interface ABFCalendarDateItem : UIView

@property (nonatomic, weak) id<ABFCalendarDateItemDelegate> delegate;

- (void)setupWithDayItemModel:(ABFDateItemModel *) dayItemModel;

@end
