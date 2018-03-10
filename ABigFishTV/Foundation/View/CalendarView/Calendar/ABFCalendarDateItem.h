//
//  ABFCalendarDateItem.h
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/10.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABFCalendarDayItemDelegate <NSObject>

- (void)touchDayItemWithDay:(NSInteger)day;

@end

@class ABFDayItemModel;

@interface ABFCalendarDateItem : UIView

@property (nonatomic, weak) id<ABFCalendarDayItemDelegate> delegate;

- (void)setupWithDayItemModel:(ABFDayItemModel *) dayItemModel;

@end
